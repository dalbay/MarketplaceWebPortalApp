using MarketplaceWebPortal_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MarketplaceWebPortalApp.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult AuthorizeUser()
        {
            return View();
        }
        [HttpPost]
        public ActionResult AuthorizeUser(Consumer consumer)
        {
            Service service = new Service();
            var valitConsumer = service.GetValidatedConsumer(consumer.Email, consumer.Password);
            ViewData["consumer"] = valitConsumer.Email + " - " + valitConsumer.Password;
            return View();
        }

        public ActionResult Index(string id)
        {
            Service service = new Service();
            //FAN subCategory filtering values.
            MarketplaceWebPortalApp.Models.FanFilter fanFilter = new Models.FanFilter();
            var initialFanFilter = service.InitializeFanFilter(2010, 2020);
            fanFilter.minHeight = initialFanFilter.minHeight;
            fanFilter.maxHeight = initialFanFilter.maxHeight;
            fanFilter.minVoltage = initialFanFilter.minVoltage;
            fanFilter.maxVoltage = initialFanFilter.maxVoltage;
            fanFilter.minPower = initialFanFilter.minPower;
            fanFilter.maxPower = initialFanFilter.maxPower;
            fanFilter.minSpeed = initialFanFilter.maxSpeed;
            fanFilter.maxSpeed = initialFanFilter.maxPower;
            ViewData["minHeight"] = "Minimum Height = " + fanFilter.minHeight;

            //TABLET subCategory filtering values.
            MarketplaceWebPortalApp.Models.TabletFilter tabletFilter = new Models.TabletFilter();
            var initialTabletFilter = service.InitializeTabletFilter(2010, 2020);
            tabletFilter.minRAM = initialTabletFilter.minRAM;
            tabletFilter.maxRAM = initialTabletFilter.maxRAM;
            tabletFilter.minScreen = initialTabletFilter.minScreen;
            tabletFilter.maxScreen = initialTabletFilter.maxScreen;
            tabletFilter.minStorage = initialTabletFilter.minStorage;
            tabletFilter.maxStorage = initialTabletFilter.maxStorage;
            ViewData["tabletFilterMinScreen"] = "Minimum Height = " + tabletFilter.minScreen;


            //SOFA subCategory filtering values.
            MarketplaceWebPortalApp.Models.SofaFilter sofaFilter = new Models.SofaFilter();
            var initialSofaFilter = service.InitializeSofaFilter(2010, 2021);
            sofaFilter.minLength = initialSofaFilter.minLength;
            sofaFilter.maxLength = initialSofaFilter.maxLength;
            if (Request.IsAjaxRequest())
            {
                var param = id ?? "2" ;
                TempData["sub_id"] = id;
                int num;
                try
                {
                    num = Int32.Parse(param);
                }
                catch (FormatException)
                {
                    num = 2;
                }

                ProductsByCategory products_category = new ProductsByCategory(num);
                List<Product> returning_List= products_category.ByCategory();
                return Json(returning_List, JsonRequestBehavior.AllowGet);
            }
            TempData["sub_id_from_search"] = id;
            return View(fanFilter);

        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";
            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }
    }
}