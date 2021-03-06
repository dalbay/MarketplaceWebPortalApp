﻿using MarketplaceWebPortal_DAL;
using MarketplaceWebPortalRepository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortal_BLL
{

    public class Service
    {    
        public static readonly MarketplaceWebPortalDataEntities context = new MarketplaceWebPortalDataEntities();
        UnitOfWork ufw = new UnitOfWork(context);
        
        public Service() { }


        //Get all the technical Specifications and values for the SOFA SubCategory
        public MarketplaceWebPortal_BLL.SofaFilter InitializeSofaFilter(Int16 minimumDate, Int16 maximumDate)
        {
            SofaFilter sofaFilter = new SofaFilter();
            var filter = ufw.sofaSubCategory.Sp_SetSofaTechSpec(minimumDate, maximumDate);
            sofaFilter.minLength = filter.minLength;
            sofaFilter.maxLength = filter.maxLength;

            return sofaFilter;
        }

        //Get all the technical Specifications and values for the TABLET SubCategory
        public MarketplaceWebPortal_BLL.TabletFilter InitializeTabletFilter(Int16 minimumDate, Int16 maximumDate)
        {
            TabletFilter tabletFilter = new TabletFilter();
            var filter = ufw.tabletSubCategory.Sp_SetTabletTechSpec(minimumDate, maximumDate);
            tabletFilter.minRAM = filter.minRAM;
            tabletFilter.maxRAM = filter.maxRAM;
            tabletFilter.minScreen = filter.minScreen;
            tabletFilter.maxScreen = filter.maxScreen;
            tabletFilter.minStorage = filter.minStorage;
            tabletFilter.maxStorage = filter.maxStorage;
            return tabletFilter;
        }

        //Get all the technical Specifications and values for the FAN SubCategory
        public MarketplaceWebPortal_BLL.FanFilter InitializeFanFilter(Int16 minimumDate, Int16 maximumDate)
        {
            MarketplaceWebPortal_BLL.FanFilter fanFilter = new MarketplaceWebPortal_BLL.FanFilter();
            var filter = ufw.fanSubCategory.Sp_SetFanFilterTechSpec(minimumDate, maximumDate);
            fanFilter.minHeight = filter.minHeight;
            fanFilter.maxHeight = filter.maxHeight;
            fanFilter.minVoltage = filter.minVoltage;
            fanFilter.maxVoltage = filter.maxVoltage;
            fanFilter.minPower = filter.minPower;
            fanFilter.maxPower = filter.maxPower;
            fanFilter.minSpeed = filter.minSpeed;
            fanFilter.maxSpeed = filter.maxSpeed;
            return fanFilter;            
        }

        //Get All the category
        public List<MarketplaceWebPortal_BLL.Category> GetCategory()
        {
            List<Category> category = new List<Category>();
            var getAllCategories = ufw.category.Sp_GetAllCategories();
            foreach (var i in getAllCategories)
            {
                category.Add(new Category { Category_ID = i.Category_ID, Category_Name = i.Category_Name });
            }
            return category;
        }
        //Get All SubCategories
        public List<MarketplaceWebPortal_BLL.SubCategory> GetSubCategories(string categoryName)
        {
            List<SubCategory> subCategoryByCategory = new List<SubCategory>();
            var getAllSubCategories = ufw.subCategoryByCategory.Sp_GetAllSubCategories(categoryName);
            foreach (var i in getAllSubCategories)
            {
                subCategoryByCategory.Add(new SubCategory { SubCategory_ID = i.SubCategory_ID, SubCategory_Name = i.SubCategory_Name });
            }
            return subCategoryByCategory;
        }

        public MarketplaceWebPortal_BLL.Consumer GetValidatedConsumer(string input, string password)
        {
            MarketplaceWebPortal_BLL.Consumer consumer = new MarketplaceWebPortal_BLL.Consumer();
            var validatedConsumer = ufw.consumer.Sp_UserValidation(input, password);
            consumer.UserName = validatedConsumer.UserName;
            consumer.User_ID = validatedConsumer.User_ID;
            consumer.Password = validatedConsumer.Password;
            consumer.Image = validatedConsumer.Image;
            consumer.Email = validatedConsumer.Email;
            return consumer;
        } 
        
        public void InsertNewConsumer(string newUsername, string newEmail, string newPassword, string newImage)
        {
            ufw.consumer.Sp_RegisterUser(newUsername, newEmail, newPassword, newImage);
        }
    }
}
