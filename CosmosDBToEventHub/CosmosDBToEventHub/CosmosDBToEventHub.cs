using System;
using System.Collections.Generic;
using Microsoft.Azure.Documents;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.EventHubs;
using System.Threading.Tasks;
using System.Text;
using Microsoft.Azure.WebJobs.Description;
using Newtonsoft;

namespace CosmosDBToEventHub
{
    public static class CosmosDBToEventHub
    {
        [FunctionName("CosmosDBToEventHub")]
        public static async Task Run([CosmosDBTrigger(
            databaseName: "team2",
            collectionName: "eventSourcing",
            ConnectionStringSetting = "team2cosmosdb",
            LeaseCollectionName = "leases")]
        IReadOnlyList<Document> input,
        [EventHub("dest", Connection = "EventHubConnectionAppSetting")] IAsyncCollector<string> outputEvents,
        ILogger log)
        {
            if (input != null && input.Count > 0)
            {
                log.LogInformation("Documents modified " + input.Count);
                log.LogInformation("First document Id " + input[0].Id);
            }
            // then send the message
            await outputEvents.AddAsync(Newtonsoft.Json.JsonConvert.SerializeObject(input));
        }
    }
}
