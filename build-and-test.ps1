# set the URL environment variable to localhost
$env:URL = "http://localhost:4200/"
# Run step to install the dependencies
npm install
# Install playwright browser dependencies
npx playwright install
