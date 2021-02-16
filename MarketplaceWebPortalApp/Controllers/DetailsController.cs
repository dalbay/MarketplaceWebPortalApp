using System;
using MarketplaceWebPortal_BLL;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MarketplaceWebPortalApp.Controllers
{
    public class DetailsController : Controller
    {
        // GET: Details
        public ActionResult Index(string pid)
        {
            int num;
            try
            {
                num = Int32.Parse(pid);
            }
            catch (FormatException)
            {
                num = 16;
            }

            if (Request.IsAjaxRequest())
            {
      
                ProductsById product = new ProductsById(num);
                List<Product> returning_List = product.ByID();
                Product returning_Product = returning_List[0];
                return Json(returning_Product, JsonRequestBehavior.AllowGet);
            }

            TempData["pid"] = num;
            return View();
        }
    }
}