/*==================================================================================================
 = This file is part of the Navitaire Kiosk application.
 = Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
 =================================================================================================*/

 import { test as base } from '@playwright/test';
import { HomePageElements } from './home-page';
 
 
 export const test = base.extend<{
   homePageElements: HomePageElements;
 
 }>({
    homePageElements: async ({ page }, use) => {
     await use(new HomePageElements(page));
   }
 });
 export { expect } from '@playwright/test';
 