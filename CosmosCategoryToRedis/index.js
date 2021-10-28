const redis = require("redis");
var client = redis.createClient(6380, process.env.REDIS_URL,
    {
        auth_pass: process.env.REDIS_KEY,
        tls: { servername: process.env.REDIS_URL }
    });

const { CosmosClient } = require("@azure/cosmos");

const endpoint = process.env.COSMOS_DBURL;
const key = process.env.COSMOS_DBKEY;
const cosmosClient = new CosmosClient({ endpoint, key });

module.exports = async function (context, documents) {
    if (!!documents && documents.length > 0) {
        var { resources } = await cosmosClient.database("team2")
            .container("Category").items.query("SELECT * from c").fetchAll();
        var cacheObj = JSON.stringify(resources);
        client.SET("categorylist", cacheObj);
    }
}
