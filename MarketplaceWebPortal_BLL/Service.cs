using MarketplaceWebPortal_DAL;
using MarketplaceWebPortalRepository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortal_BLL
{

    public class Service
    {    
        public static readonly MarketplaceWebPortalDataEntities context = new MarketplaceWebPortalDataEntities();
        UnitOfWork ufw = new UnitOfWork(context);
        public Service() { }

        public MarketplaceWebPortal_BLL.Consumer GetValidatedConsumer(string input, string password)
        {
            MarketplaceWebPortal_BLL.Consumer consumer = new MarketplaceWebPortal_BLL.Consumer();
            var validatedConsumer = ufw.consumer.sp_UserValidation(input, password);
            consumer.UserName = validatedConsumer.UserName;
            consumer.User_ID = validatedConsumer.User_ID;
            consumer.Password = validatedConsumer.Password;
            consumer.Image = validatedConsumer.Image;
            consumer.Email = validatedConsumer.Email;
            return consumer;
        }        
    }
}
