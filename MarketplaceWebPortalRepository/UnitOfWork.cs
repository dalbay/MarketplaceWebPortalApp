using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortalRepository
{
    public class UnitOfWork
    {
        DbContext Context;
        public IConsumerRepo consumer;
        public IFanSubCategory fanSubCategory;
        public ITabletSubCategory tabletSubCategory;
        public ISofaSubCategory sofaSubCategory;
        public ICategory category;

        public UnitOfWork(DbContext dbContext)
        {
            Context = dbContext;
            consumer = new ConsumerRepo(dbContext);
            fanSubCategory = new FanSubCategory(dbContext);
            tabletSubCategory = new TabletSubCategory(dbContext);
            sofaSubCategory = new SofaSubCategory(dbContext);
            category = new Category(dbContext);
        }
    }
}
