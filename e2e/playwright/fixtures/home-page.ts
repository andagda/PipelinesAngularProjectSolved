/*==================================================================================================
 = This file is part of the Navitaire Kiosk application.
 = Copyright © Navitaire LLC, an Amadeus company. All rights reserved.
 =================================================================================================*/

 import { expect, Locator, Page } from '@playwright/test';

 export class HomePageElements {
   private readonly page: Page;
   private readonly startCreatingTodayButton: Locator;
   private readonly homePageLink: Locator;
   private readonly sectionText: Locator;
 
   constructor(public readonly pageInit: Page) {
     this.page = pageInit;
     this.startCreatingTodayButton = this.page.getByRole('link', { name: 'START CREATING TODAY' });
     this.homePageLink = this.page.locator('a[href="/home"]').filter({ hasText: 'Home' });
     this.sectionText = this.page.locator('.section-heading');
   }
 
   public async assertStartCreatingTodayButton() {
     await expect(this.startCreatingTodayButton).toBeVisible();
   }

   public async assertActiveHomePage() {
    const isActive = await this.homePageLink.evaluate((element) => element.classList.contains('active'));
    expect(isActive).toBe(true);
   }

   public async assertInactiveHomePage() {
    const isActive = await this.homePageLink.evaluate((element) => element.classList.contains('active'));
    expect(isActive).toBe(false);
   }

   public async assertSectionHeaderOneHomePage(sectionHeader: string){
    await expect(this.sectionText.locator('h1')).toHaveText(sectionHeader);
   }

   public async assertSectionHeaderTwoHomePage(sectionDescription: string){
    await expect(this.sectionText.locator('h2')).toHaveText(sectionDescription);
   }

   public async clickHomePageLink(){
    await this.homePageLink.click();
   }
 }
 