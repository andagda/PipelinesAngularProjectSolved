/*==================================================================================================
= This file is part of the Navitaire Kiosk application.
= Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
=================================================================================================*/

import { test } from '../fixtures/base';

test.beforeEach('SHOULD open URL', async ({ page, aboutPageElements }) => {
	const url = process.env.URL;
	if (url) {
		await page.goto(url);
	} else {
		throw new Error('URL is not defined in the environment variables');
	}
	await aboutPageElements.clickAboutPageLink();
});

test.describe('About Page', () => {
	test('SHOULD show About as active page @pr-validation', async ({
		aboutPageElements,
	}) => {
		await aboutPageElements.assertActiveAboutPage();
	});

	test('SHOULD show the section header', async ({ commonPageElements }) => {
		const sectionHeader = 'SUCCESS';
		await commonPageElements.assertSectionHeaderThree(sectionHeader);
	});

	test('SHOULD show the section title', async ({ commonPageElements }) => {
		const sectionTitle = 'How We Help You To Sell Your Product';
		await commonPageElements.assertSectionHeaderTwo(sectionTitle);
	});

	test('SHOULD have displayed 4 description about the sample application @pr-validation', async ({
		aboutPageElements,
	}) => {
		const descriptionCount = 4;
		await aboutPageElements.confirmAboutDescriptionCount(descriptionCount);
	});

	test('SHOULD show About page as not active page when other page is selected @post-pr-validation', async ({
		homePageElements,
		aboutPageElements,
	}) => {
		await homePageElements.clickHomePageLink();
		await aboutPageElements.assertInactiveAboutPage();
	});
});
