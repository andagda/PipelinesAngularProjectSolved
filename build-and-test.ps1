# set the URL environment variable to localhost
$env:URL = "http://localhost:4200/"
# Run step to install the dependencies
npm install
# Install playwright browser dependencies
npx playwright install
Write-Host "Starting the Angular application in the background..." -ForegroundColor Blue
$job = Start-Job { ng serve --host 0.0.0.0 --port 4200 }
Write-Host "Angular application started with Job ID: $($job.Id)" -ForegroundColor Cyan
# Wait for the server to start
Start-Sleep -Seconds 10
Write-Host "Running Playwright tests..." -ForegroundColor Blue
npm run test
Stop-Job $job.Id
Write-Host "Angular application stopped." -ForegroundColor Green
