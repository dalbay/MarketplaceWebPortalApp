﻿using System;
using System.Collections.Generic;
using System.IO;
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
            Session["sessionUser"] = "";
            Session["pic"] = "~/Images/default.png";
            return View();
        }
        public ActionResult LoginPage()
        {
            Session["sessionUser"] = "";
            Session["pic"] = "~/Images/default.png";
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
                Session["pic"] = validConsumer.Image;
                return RedirectToAction("SearchPage", "Search");
            }
            else
            {
                TempData["wrongUsername"] = "Wrong Username or Password";
                return RedirectToAction("LoginPage", "UserLogin");
            }
        }
        public ActionResult Register(HttpPostedFileBase file)
        {
            Service service = new Service();
            string image="";
            if (file != null)
            {
                string pic = System.IO.Path.GetFileName(file.FileName);
                string path = System.IO.Path.Combine(
                                       Server.MapPath("~/Images"), pic);
                // file is uploaded
                file.SaveAs(path);

                image = "~/Images/" + pic;

            }
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