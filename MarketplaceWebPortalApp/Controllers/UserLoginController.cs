using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MarketplaceWebPortal_BLL;


namespace MarketplaceWebPortalApp.Controllers
{
    public class UserLoginController : Controller
    {
        // GET: UserLogin
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult LoginPage()
        {
            return View();
        }

        public ActionResult AuthUser()
        {
            Service service = new Service();
            string username = Request.Form["loginEmail"];
            string password = Request.Form["loginPassword"];
            var validConsumer = service.GetValidatedConsumer(username, password);
            if ((validConsumer.Email == username || validConsumer.UserName == username) && validConsumer.Password == password)
            {
                Session["sessionUser"] = username;
                return RedirectToAction("SearchPage", "Search");
            }
            else
            {
                TempData["wrongUsername"] = "Wrong Username or Password";
                return RedirectToAction("LoginPage", "UserLogin");
            }
        }
        public ActionResult Register()
        {
            Service service = new Service();
            string image = Request.Form["yourImage"];
            string username = Request.Form["userNameReg"];
            string email = Request.Form["emailReg"];
            string password = Request.Form["passwordReg"];
            string confirmPassword = Request.Form["confirmPasswordReg"];
            if (password == confirmPassword)
            {
                service.InsertNewConsumer(username, email, password, image);
                TempData["success"] = "success";
                return RedirectToAction("LoginPage", "UserLogin");
            }
            else
            {
                TempData["error"] = "error";
                return RedirectToAction("LoginPage", "UserLogin");
            }
            
            
        }
    }
}