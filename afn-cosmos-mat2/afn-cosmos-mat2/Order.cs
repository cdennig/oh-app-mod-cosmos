using System;
using System.Collections.Generic;
using System.Text;

namespace afn_cosmos_mat2
{

    public class Order
    {
        public string Region { get; set; }
        public DateTime OrderDate { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string Country { get; set; }
        public string Phone { get; set; }
        public bool SMSOptIn { get; set; }
        public string SMSStatus { get; set; }
        public string Email { get; set; }
        public string ReceiptUrl { get; set; }
        public float Total { get; set; }
        public string PaymentTransactionId { get; set; }
        public bool HasBeenShipped { get; set; }
        public Detail[] Details { get; set; }
        public string id { get; set; }
        public string _rid { get; set; }
        public string _self { get; set; }
        public string _etag { get; set; }
        public string _attachments { get; set; }
        public int _ts { get; set; }
    }

    public class Detail
    {
        public string Email { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public float UnitPrice { get; set; }
    }


}
