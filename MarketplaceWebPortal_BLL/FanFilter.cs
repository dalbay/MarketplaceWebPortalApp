using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortal_BLL
{
    public class FanFilter
    {
        public Nullable<double> minVoltage { get; set; }
        public Nullable<double> maxVoltage { get; set; }
        public Nullable<double> minPower { get; set; }
        public Nullable<double> maxPower { get; set; }
        public Nullable<double> minSpeed { get; set; }
        public Nullable<double> maxSpeed { get; set; }
        public Nullable<double> minHeight { get; set; }
        public Nullable<double> maxHeight { get; set; }
    }
}
