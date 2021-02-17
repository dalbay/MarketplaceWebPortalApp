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
    public interface ITabletSubCategory: IRepository<sp_TabletSubCategorySetFilter_Result>
    {
        sp_TabletSubCategorySetFilter_Result Sp_SetTabletTechSpec(Int16 minDate, Int16 maxDate);
    }

    public class TabletSubCategory : Repository<sp_TabletSubCategorySetFilter_Result>, ITabletSubCategory
    {
        public TabletSubCategory(DbContext context) : base(context) { }

        public sp_TabletSubCategorySetFilter_Result Sp_SetTabletTechSpec(short minDate, short maxDate)
        {
            return Context.Database.SqlQuery<sp_TabletSubCategorySetFilter_Result>("sp_TabletSubCategorySetFilter @param1, @param2",
                new SqlParameter("@param1", minDate),
                new SqlParameter("@param2", maxDate)).FirstOrDefault();
        }
    }

}
