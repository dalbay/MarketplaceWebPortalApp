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
        //Authorizing a consumer
        //--------------------------------------------------------------
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
        //--------------------------------------------------------------


        //Inserting a new Consumer to the Database
        //---------------------------------------------------------------
        public ActionResult RegisterUser(string name, string email, string password,string image)
        {
            Service service = new Service();
            service.InsertNewConsumer(name, email, password, image);
            return View();
        }
        //---------------------------------------------------------------

        public ActionResult Index()
        {
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