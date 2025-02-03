/*==================================================================================================
 = This file is part of the Navitaire Kiosk application.
 = Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
 =================================================================================================*/

 import { expect, Locator, Page } from '@playwright/test';

 export class AboutPageElements {
   private readonly page: Page;
   private readonly aboutPageLink: Locator;
   private readonly aboutDescriptionLocator;
 
   constructor(public readonly pageInit: Page) {
     this.page = pageInit;
     this.aboutPageLink = this.page.locator('a[href="/about"]')
     this.aboutDescriptionLocator = '.col-2-3 > div > app-feature-block > div > .icon-block-description';
   }

   public async clickAboutPageLink(){
    await this.aboutPageLink.click();
   }

   public async assertActiveAboutPage() {
    const isActive = await this.aboutPageLink.evaluate((element) => element.classList.contains('active'));
    expect(isActive).toBe(true);
   }

   public async assertInactiveAboutPage() {
    const isActive = await this.aboutPageLink.evaluate((element) => element.classList.contains('active'));
    expect(isActive).toBe(false);
   }

   public async confirmAboutDescriptionCount (count : number) {
    await this.page.waitForSelector(this.aboutDescriptionLocator);
    const descriptionCount = await this.page.locator(this.aboutDescriptionLocator).count();
    expect(descriptionCount).toEqual(count);
   }
 }
 