using MarketplaceWebPortal_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MarketplaceWebPortalApp.Controllers
{
    public class SearchController : Controller
    {
        // GET: Search
        public ActionResult Index()
        {
            Service service = new Service();
            MarketplaceWebPortalApp.Models.FanFilter fanFilter = new Models.FanFilter();
            var initialFanFilter =  service.InitializeFanFilter(2010, 2020);
            fanFilter.minHeight = initialFanFilter.minHeight;
            fanFilter.maxHeight = initialFanFilter.maxHeight;
            fanFilter.minVoltage = initialFanFilter.minVoltage;
            fanFilter.maxVoltage = initialFanFilter.maxVoltage;
            fanFilter.minPower = initialFanFilter.minPower;
            fanFilter.maxPower = initialFanFilter.maxPower;
            fanFilter.minSpeed = initialFanFilter.maxSpeed;
            fanFilter.maxSpeed = initialFanFilter.maxPower;
            ViewData["minHeight"] = "Minimum Height = "+ fanFilter.minHeight;
            return View();
        }

        public ActionResult SearchPage()
        {
            Service service = new Service();
            List<Category> categories = service.GetCategory();
            ViewBag.Categories = categories;
            return View();
        }
        public ActionResult GetSubCategory(string categoryName)
        {
            Service service = new Service();
            string s = "Electrical";
            Console.WriteLine(categoryName);
            List<SubCategory> subCategories = service.GetSubCategories(categoryName);
            return Json(subCategories, JsonRequestBehavior.AllowGet);
        }
        public ActionResult Search()
        {
            return View();
        }
    }
}