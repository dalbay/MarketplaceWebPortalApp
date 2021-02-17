using MarketplaceWebPortal_DAL;
using MarketplaceWebPortalRepository;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MarketplaceWebPortal_BLL
{

    public class ProductsByCategory
    {
        int SubCategoryId { get; set; }
        public ProductsByCategory(int SubCategoryId)
        {
            this.SubCategoryId = SubCategoryId;
        }

        public List<Product> ByCategory()
        {
            List<Product> myProducts = new List<Product>();

            using (var context = new MarketplaceWebPortalDataEntities())
            {
                UnitOfWork ufw = new UnitOfWork(context);

                var products = (from product in context.tblProducts
                                where product.SubCategory_ID == this.SubCategoryId
                                select new Product
                                {
                                    id = product.Product_ID.ToString(),
                                    name = product.Product_Name,
                                    Category = product.tblSubCategory.tblCategory.Category_Name,
                                    SubCategory = product.tblSubCategory.SubCategory_Name,
                                    Manfacture = product.tblManufacturer.Manufacturer_Name,
                                    Series = product.Series,
                                    Model = product.Model,
                                    UseType = product.tblUseType.Type_Name,
                                    Application = product.tblApplication.Application_Name,
                                    MountingLocation = product.tblMountingLocation.Location,
                                    Accessories = product.Accessories,
                                    ModelYear = product.Model_Year.ToString(),
                                    Series_info = product.Series_Info,
                                    Image = product.Image
                                }).ToList();


                foreach (Product p in products)
                {
                    var specs = (from filters in context.tblTechSpecFilters
                                 where filters.Product_ID.ToString() == p.id
                                 select new Filters
                                 {
                                     Product_id = filters.Product_ID.ToString(),
                                     Name = filters.tblTechSpec.TechSpec_Name,
                                     Amount = filters.Amount.ToString(),
                                     Filter = filters.tblFilter.Filter_Name
                                 }
                                 ).ToList();


                    Hashtable hash = new Hashtable();
                    foreach (Filters f in specs)
                    {
                        if (hash.ContainsKey(f.Name))
                        {
                            List<string> abc = (List<string>)hash[f.Name];
                            hash[f.Name] = new List<string> { abc[0].ToString(), abc[1].ToString(), f.Filter, f.Amount };
                        }
                        else
                        {
                            hash[f.Name] = new List<string> { f.Filter, f.Amount };
                        }
                    }

                    p.Specs = hash;


                }

                return products;
            }
        }
    }



    public class ProductsById
    {
        int[] ProductId { get; set; }
        public ProductsById(params int[] list)
        {
            ProductId = list;
        }


        public List<Product> ByID()
        {
            List<Product> myProducts = new List<Product>();

            using (var context = new MarketplaceWebPortalDataEntities())
            {
                UnitOfWork ufw = new UnitOfWork(context);
                var products = (from product in context.tblProducts
                                where (this.ProductId.Contains(product.Product_ID))
                                select new Product
                                {
                                    id = product.Product_ID.ToString(),
                                    name = product.Product_Name,
                                    Category = product.tblSubCategory.tblCategory.Category_Name,
                                    SubCategory = product.tblSubCategory.SubCategory_Name,
                                    Manfacture = product.tblManufacturer.Manufacturer_Name,
                                    Series = product.Series,
                                    Model = product.Model,
                                    UseType = product.tblUseType.Type_Name,
                                    Application = product.tblApplication.Application_Name,
                                    MountingLocation = product.tblMountingLocation.Location,
                                    Accessories = product.Accessories,
                                    ModelYear = product.Model_Year.ToString(),
                                    Series_info = product.Series_Info,
                                    Image = product.Image
                                }).ToList();
                foreach (Product p in products)
                {
                    var specs = (from filters in context.tblTechSpecFilters
                                 where filters.Product_ID.ToString() == p.id
                                 select new Filters
                                 {
                                     Product_id = filters.Product_ID.ToString(),
                                     Name = filters.tblTechSpec.TechSpec_Name,
                                     Amount = filters.Amount.ToString(),
                                     Filter = filters.tblFilter.Filter_Name
                                 }
                                 ).ToList();


                    Hashtable hash = new Hashtable();
                    foreach (Filters f in specs)
                    {
                        if (hash.ContainsKey(f.Name))
                        {
                            List<string> abc = (List<string>)hash[f.Name];
                            hash[f.Name] = new List<string> { abc[0].ToString(), abc[1].ToString(), f.Filter, f.Amount };
                        }
                        else
                        {
                            hash[f.Name] = new List<string> { f.Filter, f.Amount };
                        }
                    }

                    p.Specs = hash;


                }

                return products;
            }
        }



    }


    public class Filters
    {
        public string Product_id;
        public string Name;
        public string Amount;
        public string Filter;
    }



    public class Product
    {
        public string id { get; set; }
        public string name { get; set; }
        public string Category { get; set; }
        public string SubCategory { get; set; }
        public string Manfacture { get; set; }
        public string Series { get; set; }
        public string Model { get; set; }
        public string UseType { get; set; }
        public string Application { get; set; }
        public string MountingLocation { get; set; }
        public string Accessories { get; set; }
        public string ModelYear { get; set; }
        public string Series_info { get; set; }
        public string Image { get; set; }
        public Hashtable Specs { get; set; }
    }
}
