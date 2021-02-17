using MarketplaceWebPortal_DAL;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortalRepository
{
    public interface IFanSubCategory : IRepository<sp_FanSetFilter_Result>
    {
        sp_FanSetFilter_Result Sp_SetFanFilterTechSpec(Int16 minDate, Int16 maxDate);
    }

    public class FanSubCategory : Repository<sp_FanSetFilter_Result>, IFanSubCategory
    {
        public FanSubCategory(DbContext context) : base(context) { }

        public void Insert(sp_FanSetFilter_Result entity)
        {
            throw new NotImplementedException();
        }

        public sp_FanSetFilter_Result Sp_SetFanFilterTechSpec(short minDate, short maxDate)
        {
            return Context.Database.SqlQuery<sp_FanSetFilter_Result>("sp_FanSubCategorySetFilter @param1, @param2",
               new SqlParameter("@param1", minDate),
               new SqlParameter("@param2", maxDate)).FirstOrDefault();
        }
    }
}
