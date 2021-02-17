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
            
            if (Request.IsAjaxRequest())
            {
                var param = Request.QueryString["id"] ?? "2" ;
                TempData["sub_id"] = id;
                int num = 2;
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
            return View();
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