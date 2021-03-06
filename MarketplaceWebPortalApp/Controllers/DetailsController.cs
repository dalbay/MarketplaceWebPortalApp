﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MarketplaceWebPortal_BLL;

namespace MarketplaceWebPortalApp.Controllers
{
    public class DetailsController : Controller
    {

        public ActionResult Index(string pid)
        {

            Service service = new Service();
            List<Category> categories = service.GetCategory();
            ViewBag.Categories = categories;

            if(Session["sessionUser"] == "")
            {
                return RedirectToAction("LoginPage", "UserLogin");
            }

            int num;
            string id = pid ?? "16";
            try
            {
                num = Int32.Parse(id);
            }
            catch (FormatException)
            {
                num = 16;
            }

            if (Request.IsAjaxRequest())
            {
                try
                {
                    ProductsById product = new ProductsById(num);
                    List<Product> returning_List = product.ByID();
                    Product returning_Product = returning_List[0];
                    return Json(returning_Product, JsonRequestBehavior.AllowGet);
                }
                catch
                {
                    return RedirectToAction("Index", "Home");
                }
                
            }

            TempData["pid"] = num;
            return View();
        }
    }
}