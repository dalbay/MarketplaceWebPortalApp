using MarketplaceWebPortal_DAL;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortalRepository
{
    public interface IConsumerRepo : IRepository<tblConsumer>
    {
        tblConsumer GetConsumerByID(int id);
        void InsertConsumer(tblConsumer entity);

        tblConsumer sp_UserValidation(string input, string password);
    }
    public class ConsumerRepo : Repository<tblConsumer>, IConsumerRepo
    {
        public ConsumerRepo(DbContext context) : base(context) { }

        public tblConsumer GetConsumerByID(int id)
        {
            throw new NotImplementedException();
        }

        public void InsertConsumer(tblConsumer entity)
        {
            throw new NotImplementedException();
        }

        public tblConsumer sp_UserValidation(string input, string password)
        {
            return Context.Database.SqlQuery<tblConsumer>(

    "sp_UserValidation @param1, @param2",
    new SqlParameter("param1", input),
    new SqlParameter("param2", password)).FirstOrDefault();

        }
    }
}
