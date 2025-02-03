<#
.SYNOPSIS
Series of commands that helps build the Sample Application to local server

.DESCRIPTION
  Performs building and running the Sample Application. 

.PARAMETER Run
  -$UpdateLocalRepository -branchName parameter will pull and checkout desired branch.
  -$ChangeURL parameter will override configured env variable URL in $StartSampleApplicationService. Should not be combined with other parameters
  -$StartSampleApplicationService parameter will build and start Sample Application Services.
  -$TestSampleApplicationService parameter will run the tests
  -$EndSampleApplicationService parameter will kill Sample Application process

.EXAMPLE 
    .\help.build-sample-application.ps1 -UpdateLocalRepository -branchName "<Branch Name>"
    .\help.build-KioskLocalJobs.ps1 -ChangeURL
    .\help.build-sample-application.ps1 StartSampleApplicationService 
    .\help.build-sample-application.ps1 TestSampleApplicationService 
    .\help.build-sample-application.ps1 EndSampleApplicationService
    .\help.build-sample-application.ps1 -UpdateLocalRepository -branchName "<Branch Name>"  StartSampleApplicationService TestSampleApplicationService EndSampleApplicationService 

.NOTES
/*==================================================================================================
 = This file is part of the Navitaire Kiosk application.
 = Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
 =================================================================================================*/
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false, ParameterSetName = 'UpdateLocalRepositoryWithBranch')]
    [switch]$UpdateLocalRepository,
    [Parameter(Mandatory = $false, ParameterSetName = 'UpdateLocalRepositoryWithBranch')]
    [string]$branchName,

    [switch]$ChangeURL,
    [switch]$StartSampleApplicationService,
    [switch]$TestSampleApplicationService,
    [switch]$EndSampleApplicationService
)

Function ChooseURL {

    # Calculate the maximum text width
    $maxLength = 0

    $fileContent = Get-Content -Raw -Path '.\e2e\playwright\data-files\test-url.json'
    $jsonData = $fileContent | ConvertFrom-Json

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Select a URL to test'
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(125, 130)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(200, 130)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Please select a URL to test:'
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10, 40)

    foreach ($property in $jsonData.PSObject.Properties) {
        #  Find the longest text in $jsonData
        $name = $property.Name
        $values = $property.Value
        #  We choose our selected item
        if ($name -ne '_comment') {
            foreach ($urls in $values) {
                if ($maxLength -lt $urls.Length) {
                    $maxLength = $urls.Length 
                }         
            }
            [void] $listBox.Items.Add($values)
        }
    }

    $form.Controls.Add($listBox)

    $toolTip = New-Object System.Windows.Forms.ToolTip

    $listBox.Add_MouseHover({
            $point = $listBox.PointToClient([System.Windows.Forms.Control]::MousePosition)
            $index = $listBox.IndexFromPoint($point)

            if ($index -ge 0) {
                # Set the tooltip text for the hovered item
                $toolTip.SetToolTip($listBox, $listBox.GetItemText($listBox.Items[$index]))
            }
            else {
                # Clear the tooltip when not hovering over an item
                $toolTip.SetToolTip($listBox, "")
            }
        })
    $form.Topmost = $true

    $label.Text = 'Please select a URL:'
    $maxLengthForm = $maxLength + 350
    $maxLengthList = $maxLength + 300
    $form.Size = New-Object System.Drawing.Size($maxLengthForm, 200)
    $listBox.Size = New-Object System.Drawing.Size($maxLengthList, 80)
    $listBox.HorizontalScrollbar = $true
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $env:URL = $listBox.SelectedItem
        if ($null -eq $env:URL) {
            Write-Host 'Please select URL to test.'  -ForegroundColor Red
            exit
        }
    }
    else {
        Write-Host 'Please select URL to test.'  -ForegroundColor Red
        exit
    }
    return $env:URL
}

Function Check-Sample-Application-Service {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect('localhost', 4200)
    Write-Host 'There is established connection for http://localhost:4200' -ForegroundColor Green
    $tcpClient.Close()
}

if ($ChangeURL) {
    $env:URL = ChooseURL
}

## Pre-requisite: Current location is the Kiosk local git reporsitory
if ($UpdateLocalRepository) {
    git pull

    if ($branchName -ne "") {
        git checkout $branchName
    }
    else {
        Write-Host 'Please input branch name. Use this command "-UpdateLocalRepository -branchName <branch name>"'  -ForegroundColor Red
        exit
    }
}


if ($StartSampleApplicationService) {

    $env:URL = ChooseURL

    #### Start of Validation ###

    Write-Host '==============Validation has started==============' -ForegroundColor Green

    ### Node version Validation
    $installedNodeVersion = node -v
    $requiredNodeVersion = 'v18.*.*'
    $requiredNodeVersionMatch = '^v18\.\d+\.\d+$'
    if ($installedNodeVersion -match $requiredNodeVersionMatch) {
        Write-Host 'Correct node version is installed'  -ForegroundColor Green
    }
    else {
        Write-Host "Incorrect node version is installed: $installedNodeVersion. Required version is: $requiredNodeVersion"  -ForegroundColor Red
        exit
    }

    ### Playwright Validation
    $isPlaywrightAvailable = npm list -g playwright
    if ($isPlaywrightAvailable -ne $null) {
        Write-Host 'Playwright is installed'  -ForegroundColor Green
    }
    else {
        Write-Host 'Playwright is NOT installed. Please install playwright using this command: npm install playwright'  -ForegroundColor Red
        exit
    }


    Write-Host '==============Validation is successful=============='  -ForegroundColor Green

    #### End of Validation ###


    # install all packages declared in package.json
    Write-Host 'Running npm install.'-ForegroundColor Green
    npm i
    Write-Host 'Installation completed!'-ForegroundColor Green

    # installation of playwright dependencies
    Write-Host 'Running playwright dependency installation.'-ForegroundColor Green
    npx playwright install --with-deps chromium
    npx playwright install-deps
    Write-Host 'Installation completed!'-ForegroundColor Green

    # starting the server
    Start-Process -FilePath 'cmd.exe' -ArgumentList '/c npm run ng serve' -NoNewWindow
    $timeout = 120
    $elapsedTime = 0
    $interval = 5


    while ($elapsedTime -lt $timeout) {
        try {
            $webRequest = Invoke-WebRequest -Uri http://localhost:4200;
            Write-Host "You can now access Sample Application using http://localhost:4200/" -ForegroundColor Green
            break
        }
        catch {
            Write-Host "..........The site is not up and accessible. Waiting for $interval seconds..." -ForegroundColor Red
            Start-Sleep -Seconds $interval
            $elapsedTime += $interval
        }
    }

    if ($elapsedTime -ge $timeout) {
        Write-Host 'Timeout reached. TCP connection not established.' -ForegroundColor Red
    }
} 

if ($TestSampleApplicationService) {

    try {
        Check-Sample-Application-Service

        if ($env:URL -eq $null) {
            $env:URL = ChooseURL
        }

        npx playwright test --project=chromium --workers=4
        Write-Host 'Completed all tests.' -ForegroundColor Green
    }
    catch {
        Write-Host 'No TCP connection established yet.' -ForegroundColor Red
    }

}

if ($EndSampleApplicationService) {

    $portNumber = 4200
    $localAddress = '127.0.0.1'

    try {
        
        Check-Sample-Application-Service
        $processID = (Get-NetTCPConnection | Where-Object { $_.LocalAddress -eq $localAddress -and $_.LocalPort -eq $portNumber }).OwningProcess
        foreach ($id in $processID) {
            if ($id -eq 0) {
                ##do nothing
            }
            else {
                Write-Host 'Ending Sample Application Service in http://localhost:4200.'  -ForegroundColor Green
                taskkill /PID $id /F
                Write-Host 'Sample Application Service is now down. http://localhost:4200 is no longer accessible.'  -ForegroundColor Green
                exit
            }
        }
    }
    catch {
        Write-Host 'No TCP connection established yet.' -ForegroundColor Red
        exit
    }
} 