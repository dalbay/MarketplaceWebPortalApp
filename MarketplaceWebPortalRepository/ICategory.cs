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
    
    public interface ICategory : IRepository<sp_GetAllCategories_Result>
    {
        List<sp_GetAllCategories_Result> Sp_GetAllCategories();

    }
    public class Category : Repository<sp_GetAllCategories_Result>, ICategory
    {
        public Category(DbContext context) : base(context) { }

        public void Insert(sp_GetAllCategories_Result entity)
        {
            throw new NotImplementedException();
        }
        public List<sp_GetAllCategories_Result> Sp_GetAllCategories()
        {
          
            return Context.Database.SqlQuery<sp_GetAllCategories_Result>("sp_GetAllCategories").ToList();
            
        }
    }
}
