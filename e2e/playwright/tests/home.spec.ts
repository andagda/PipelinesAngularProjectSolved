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
  });
  