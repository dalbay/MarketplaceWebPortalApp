using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortalRepository
{
    public interface IRepository<TEntity> where TEntity : class
    {
        TEntity GetByID(int id);
        void Insert(TEntity entity);

    }
    public class Repository<TEntity> : IRepository<TEntity> where TEntity : class
    {
        protected readonly DbContext Context;
        public Repository(DbContext dbContext)
       {
            Context = dbContext;
       }

        public TEntity GetByID(int id)
        {
            return Context.Set<TEntity>().Find(id);
        }

        public void Insert(TEntity entity)
        {
            Context.Set<TEntity>().Add(entity);
        }

        public IEnumerable<TEntity> entities(string input, string password)
        {
            return Context.Database.SqlQuery<TEntity>(input, password);
        }
    }
}
