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
    public interface ISubCategory : IRepository<sp_FanSetFilter_Result>
    {
        sp_FanSetFilter_Result Sp_SetFanFilterTechSpec(Int16 minDate, Int16 maxDate);
    }

    public class SubCategory : Repository<sp_FanSetFilter_Result>, ISubCategory
    {
        public SubCategory(DbContext context) : base(context) { }

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

        sp_FanSetFilter_Result IRepository<sp_FanSetFilter_Result>.GetByID(int id)
        {
            throw new NotImplementedException();
        }


    }
}
