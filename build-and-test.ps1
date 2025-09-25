# set the URL environment variable to localhost
$env:URL = "http://localhost:4200/"
# Run step to install the dependencies
npm install
# Install playwright browser dependencies
npx playwright install
Write-Host "Starting the Angular application in the background..." -ForegroundColor Blue
$job = Start-Job { ng serve }
Write-Host "Angular application started with Job ID: $($job.Id)" -ForegroundColor Cyan
npx playwright test e2e/playwright/tests
Stop-Job $job.Id
Write-Host "Angular application stopped." -ForegroundColor Green
