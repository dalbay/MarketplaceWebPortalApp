using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MarketplaceWebPortalApp.Models
{
    public class TabletFilter
    {
        public Nullable<double> minScreen { get; set; }
        public Nullable<double> maxScreen { get; set; }
        public Nullable<double> minStorage { get; set; }
        public Nullable<double> maxStorage { get; set; }
        public Nullable<double> minRAM { get; set; }
        public Nullable<double> maxRAM { get; set; }
    }
}