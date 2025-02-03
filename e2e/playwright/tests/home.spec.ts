/*==================================================================================================
= This file is part of the Navitaire Kiosk application.
= Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
=================================================================================================*/

import { test } from '../fixtures/base';


test.beforeEach('SHOULD open URL', async ({ page }) => {
  const url = process.env.URL;
  if (url) {
      await page.goto(url);
    } else {
      throw new Error('URL is not defined in the environment variables');
    }
});

test.describe('Home Page', () => {
  test('SHOULD display start creating today button', async ({
    homePageElements
  }) => {
    await homePageElements.assertStartCreatingTodayButton();
  });

  test('SHOULD show Home as active page', async ({
    homePageElements
  }) => {
    await homePageElements.assertActiveHomePage();
  });

  test('SHOULD show the section header', async ({
    commonPageElements
  }) => {
    const sectionHeader = 'A FREE AND SIMPLE LANDING PAGE';
    await commonPageElements.assertSectionHeaderOne(sectionHeader);
  })

  test('SHOULD show the section description', async ({
    commonPageElements
  }) => {
    const sectionDescription = 'Namari is free landing page template you can use for your projects. It is free to use for your personal and commercial projects, enjoy!';
    await commonPageElements.assertSectionHeaderTwo(sectionDescription);
  })

  test('SHOULD show Home as not active page when other page is selected', async ({
    homePageElements,
    aboutPageElements
  }) => {
    await aboutPageElements.clickAboutPageLink();
    await homePageElements.assertInactiveHomePage();
  });

});
