/*==================================================================================================
 = This file is part of the Navitaire Kiosk application.
 = Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
 =================================================================================================*/

 import { expect, Locator, Page } from '@playwright/test';

 export class HomePageElements {
   private readonly page: Page;
   private readonly startCreatingTodayButton: Locator;
 
   constructor(public readonly pageInit: Page) {
     this.page = pageInit;
     this.startCreatingTodayButton = this.page.getByRole('link', { name: 'START CREATING TODAY' });
   }
 
   public async assertStartCreatingTodayButton() {
     await expect(this.startCreatingTodayButton).toBeVisible();
   }
 }
 