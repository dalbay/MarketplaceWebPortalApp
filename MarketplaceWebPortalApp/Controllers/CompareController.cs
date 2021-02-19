using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MarketplaceWebPortal_BLL;

namespace MarketplaceWebPortalApp.Controllers
{
    public class CompareController : Controller
    {
        // GET: Compare
        [HttpPost]
        public ActionResult Index()
        {
            if (Session["sessionUser"] == "")
            {
                return RedirectToAction("LoginPage", "UserLogin");
            }
        }


        public ActionResult Index(params int[] list)
        {
            if (Session["sessionUser"] == "")
            {
                return RedirectToAction("LoginPage", "UserLogin");
            }
            if (Request.IsAjaxRequest())
            {
                try
                {
                    ProductsById products = new ProductsById(list);
                    List<Product> returning_List = products.ByID();
                    return Json(returning_List, JsonRequestBehavior.AllowGet);
                }
                catch
                {
                    return RedirectToAction("Index", "Home");
                }


            } 
            if (list != null)
            {
                ViewData["length"] = list.Length;
                for (int i= 0; i < list.Length ; i++)
                {
                    ViewData["id" + i.ToString()] = list[i].ToString();
                }
                
            }
            else
            {
                ViewData["length"] = 0;
            }
            return View();




        }
    }
}