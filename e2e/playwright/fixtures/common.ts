/*==================================================================================================
 = This file is part of the Navitaire Kiosk application.
 = Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
 =================================================================================================*/

 import { expect, Locator, Page } from '@playwright/test';

 export class CommonPageElements {
   private readonly page: Page;
   private readonly aboutPageLink: Locator;
   private readonly sectionText: Locator;
 
   constructor(public readonly pageInit: Page) {
     this.page = pageInit;
     this.aboutPageLink = this.page.locator('a[href="/about"]');
     this.sectionText = this.page.locator('.section-heading');
   }

   public async clickAboutPageLink(){
    await this.aboutPageLink.click();
   }

   public async assertSectionHeaderOne(section: string){
    await expect(this.sectionText.locator('h1')).toHaveText(section);
   }

   public async assertSectionHeaderTwo(section: string){
    await expect(this.sectionText.locator('h2')).toHaveText(section);
   }

   public async assertSectionHeaderThree(section: string){
    await expect(this.sectionText.locator('h3')).toHaveText(section);
   }

   
 }
 