//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MarketplaceWebPortal_DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblTechSpec
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public tblTechSpec()
        {
            this.tblTechSpecFilters = new HashSet<tblTechSpecFilter>();
            this.tblSubCategories = new HashSet<tblSubCategory>();
            this.tblTechnicalSpecifiactionNonValues = new HashSet<tblTechnicalSpecifiactionNonValue>();
        }
    
        public int TechSpec_ID { get; set; }
        public string TechSpec_Name { get; set; }
        public string TechSpec_Description { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tblTechSpecFilter> tblTechSpecFilters { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tblSubCategory> tblSubCategories { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<tblTechnicalSpecifiactionNonValue> tblTechnicalSpecifiactionNonValues { get; set; }
    }
}
