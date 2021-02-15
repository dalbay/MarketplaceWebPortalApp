﻿using System;
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

        public UnitOfWork(DbContext dbContext)
        {
            Context = dbContext;
            consumer = new ConsumerRepo(dbContext);
        }
    }
}