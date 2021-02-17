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
    public interface ISofaSubCategory : IRepository<sp_SofaSubCategorySetFilter_Result>
    {
        sp_SofaSubCategorySetFilter_Result Sp_SetSofaTechSpec(Int16 minDate, Int16 maxDate);
    }

    public class SofaSubCategory: Repository<sp_SofaSubCategorySetFilter_Result>, ISofaSubCategory
    {
        public SofaSubCategory(DbContext context) : base(context) { }

        public sp_SofaSubCategorySetFilter_Result Sp_SetSofaTechSpec(short minDate, short maxDate)
        {
            return Context.Database.SqlQuery<sp_SofaSubCategorySetFilter_Result>("sp_SofaSubCategorySetFilter @param1, @param2",
                new SqlParameter("@param1", minDate),
                new SqlParameter("@param2", maxDate)).FirstOrDefault();
        }
    }

}
