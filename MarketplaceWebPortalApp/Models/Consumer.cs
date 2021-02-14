using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MarketplaceWebPortalApp.Models
{
    public class Consumer
    {
        public int User_ID { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Image { get; set; }
    }
}