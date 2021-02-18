using MarketplaceWebPortal_DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortalRepository
{
    public interface ISubCategoryByCategory : IRepository<sp_GetAllSubCategories_Result>
    {
        List<sp_GetAllSubCategories_Result> Sp_GetAllSubCategories(string categoryName);
    }
    public class SubCategoryByCategory : Repository<sp_GetAllSubCategories_Result>, ISubCategoryByCategory
    {
        public SubCategoryByCategory(DbContext context) : base(context) { }

        public List<sp_GetAllSubCategories_Result> Sp_GetAllSubCategories (string categoryName)
        {
            return Context.Database.SqlQuery<sp_GetAllSubCategories_Result>(
                "sp_GetAllSubCategories @param1",
                new SqlParameter("@param1", categoryName)).ToList();
        }
    }
}