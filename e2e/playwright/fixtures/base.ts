/*==================================================================================================
 = This file is part of the Navitaire Kiosk application.
 = Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
 =================================================================================================*/

import { test as base } from '@playwright/test';
import { HomePageElements } from './home-page';
import { AboutPageElements } from './about-page';
import { CommonPageElements } from './common';
 

export const test = base.extend<{
  homePageElements: HomePageElements;
  aboutPageElements: AboutPageElements;
  commonPageElements: CommonPageElements;
}>({
  homePageElements: async ({ page }, use) => {
    await use(new HomePageElements(page));
  },
  aboutPageElements: async ({ page }, use) => {
    await use(new AboutPageElements(page));
  },
  commonPageElements: async ({ page }, use) => {
    await use(new CommonPageElements(page));
  }
});
export { expect } from '@playwright/test';
 