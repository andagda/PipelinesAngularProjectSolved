import { defineConfig } from '@playwright/test';

export default defineConfig({
	testDir: './e2e/playwright',
	fullyParallel: true,
	workers: 2,
	retries: 2,
	use: {
		/* Base URL to use in actions like `await page.goto('/')`. */
		baseURL: process.env.URL,

		/* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
		trace: 'retain-on-failure',
		video: 'retain-on-failure',
		screenshot: 'only-on-failure',
	},
	projects: [
		{
			name: 'chromium',
			use: { browserName: 'chromium' },
		},
		{
			name: 'firefox',
			use: { browserName: 'firefox' },
		},
		{
			name: 'webkit',
			use: { browserName: 'webkit' },
		},
	],
});
