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

    }
    public class Category : Repository<sp_GetAllCategories_Result>
    {
        public Category(DbContext context) : base(context) { }

        public void Insert(sp_GetAllCategories_Result entity)
        {
            throw new NotImplementedException();
        }
        public sp_GetAllCategories_Result Sp_GetAllCategories()
        {
            Context.Database.SqlQuery<sp_GetAllCategories_Result>("sp_GetAllCategories");
        }
        sp_GetAllCategories_Result IRepository<sp_GetAllCategories>.GetByID(int id)
        {
            throw new NotImplementedException();
        }
    }
}
