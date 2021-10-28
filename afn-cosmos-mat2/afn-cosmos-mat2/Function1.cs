using System;
using System.Collections.Generic;
using Microsoft.Azure.Documents;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using System.Linq;
using Newtonsoft.Json;
using Microsoft.Azure.Cosmos;
//using Shared;

namespace afn_cosmos_mat2
{

    public static class FuncMaterlizedview
    {
        private static readonly string _endpointUrl = "https://team2.documents.azure.com:443/";
        private static readonly string _primaryKey = "";
        private static readonly string _databaseId = "team2";
        private static readonly string _containerId = "topsales";
        private static CosmosClient cosmosClient = new CosmosClient(_endpointUrl, _primaryKey);

        [FunctionName("func-materlizedview")]
        public static async Task Run([CosmosDBTrigger(
            databaseName: "team2",
            collectionName: "eventSourcing",
            ConnectionStringSetting = "DBConnection",
            CreateLeaseCollectionIfNotExists = true,
            LeaseCollectionName = "materializedViewLeases1")]IReadOnlyList<Document> input, ILogger log)
        {
            if (input != null && input.Count > 0)
            {
                var ProductDict = new Dictionary<int, int>();
                foreach (var doc in input)
                {
                    var action = JsonConvert.DeserializeObject<Order>(doc.ToString());
                    foreach (Detail d in action.Details)
                    {
                        if (ProductDict.ContainsKey(d.ProductId))
                        {
                            ProductDict[d.ProductId] += d.Quantity;
                        }
                        else
                        {
                            ProductDict.Add(d.ProductId, d.Quantity);
                        }
                    }

                }

                var db = cosmosClient.GetDatabase(_databaseId);
                var container = db.GetContainer(_containerId);
                var tasks = new List<Task>();
                foreach (var key in ProductDict.Keys)
                {
                    var query = new QueryDefinition("select * from topsales s where s.ProductId = @productid").WithParameter("@productid", key);
                    var resultSet = container.GetItemQueryIterator<TopSales>(query, requestOptions: new QueryRequestOptions() { PartitionKey = new Microsoft.Azure.Cosmos.PartitionKey(key), MaxItemCount = 1 });
                    while (resultSet.HasMoreResults)
                    {
                        var topsalseCount = (await resultSet.ReadNextAsync()).FirstOrDefault();
                        if (topsalseCount == null)
                        {
                            topsalseCount = new TopSales();
                            topsalseCount.ProductId = key;
                            topsalseCount.Quantity = ProductDict[key];

                        }
                        else
                        {
                            topsalseCount.Quantity = ProductDict[key];
                        }
                        log.LogInformation("Upserting materialized view document");
                        tasks.Add(container.UpsertItemAsync(topsalseCount, new Microsoft.Azure.Cosmos.PartitionKey(topsalseCount.ProductId)));

                    }
                }

            }

        }
    }
}
