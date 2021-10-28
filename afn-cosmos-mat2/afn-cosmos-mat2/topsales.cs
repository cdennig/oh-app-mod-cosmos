using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace afn_cosmos_mat2
{
    class TopSales
    {
        [JsonProperty("id")]
        public string Id { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }

        public TopSales()
        {
            Id = Guid.NewGuid().ToString();
        }

    }
}
