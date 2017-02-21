## Guide to Tracking Events using the JS tracker
Docs on tracking events: https://github.com/snowplow/snowplow/wiki/trackers


### Instantiate the tracker

There are trackers for Javascript, Python, Android, and many others. Check docs for specific tracker setup.

* Collector Endpoint URI: 
  * Dev: `collector.sp.awesomestartup.com`
  * Staging: `collector.sp.nerfstars.com`

If you're using the Javascript tracker, use version 2.7.0 or higher. For Python, use version 0.8.0 or higher. Self-describing events are not supported in earlier versions.


### Tracking events

#### Built-in Events:

Every tracker for each platform has different support for built-in events, check docs for more.

#### Self-Describing Events:

Like built-in events, each platform has a different way of implementing these events, check the docs.

##### Arguments:

* (Required) Self-describing event JSON, where you specify the data pertaining to this event. You'll need to add a new schema onto Iglu every time you create a new self-describing event type.
* (Optional) Custom contexts, where you can attach one or more self-describing JSONs to a list. As the name suggests, you'll be adding context to the data. This is validated by Iglu as well, you'll need a new Iglu schema any time you create a new type of context.

Tracking is fairly simple, and very similar to how Mixpanel tracking works. 

For the most part, you'll likely be using self-describing events.


### Self-describing JSONs

Self-describing JSONs are where you'd add in data pertaining to a self-describing event, or a custom context.

##### The main components to this are:
* Schema
  * The schema is the URI where the self-describing JSON/custom context gets validated with Iglu.
  * E.g.: `/analytics-pipeline/iglu/com.fivestars.iglu/event_base/jsonschema/1-0-0`
* Data
  * This is where you specify what data you'd like to pass. This is what gets enforced/validated within the Iglu schema (which is what you specify).


### Iglu schemas

Docs on Iglu: https://github.com/snowplow/iglu/wiki/Iglu-technical-documentation

Docs on JSON-schemas: http://json-schema.org/

You can find and create new schemas within the `analytics-pipeline` repo. Every time you create a new schema, you'll need to rebuild via command: `./scripts/build.py --aws_profile=production --environment=staging`

Every time you create a new custom context/schema for a self-describing JSON, you'll need a new Iglu schema that matches and enforces the data. This is where we enforce what ends up in the `enriched` vs `bad` kinesis stream, everything must be followed or it ends up in the bad stream.

Take a look at this example schema:

```javascript
{
    "$schema" : "http://iglucentral.com/schemas/com.snowplowanalytics.self-desc/schema/jsonschema/1-0-0#",
    "self" : {
        "vendor": "com.fivestars.iglu",
        "name": "event_base",
        "format": "jsonschema",
        "version": "1-0-0"
    },
    "description": "FS Event Base",
    "type": "object",
    "properties": {
        "event_type": {
            "type": "string",
            "pattern": "^[a-z0-9_]+$"
        },
        "event_name": {
            "type": "string",
            "pattern": "^[a-z0-9_]+$"
        },
        "event_timestamp": {
            "type": "number"
        }
    },
    "required": ["event_type", "event_name"]
}
```

Example above: `properties` are all the fields in your self-describing JSON. `event_type` and `event_name` has its types enforced, and what regex it follows (alphanumeric and underscores only, no uppercase or cap). `event_type` and `event_name`, are also required and must be included in the data. Anything else is optional (like `event_timestamp`).

`self` is what determines what your schema url within your data will be. E.g.: `iglu:com.fivestars.iglu/event_base/jsonschema/1-0-0`. `$schema` is the base schema in which all schemas inherit from. Use the same URI as the one above.

This covers the majority of what you'd need for Iglu schemas. Check the docs for more details.


### Cloudwatch

How do I check whether or not my data is enriched or bad? And where does all this data end up? Check out [Cloudwatch](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logs:).

Using nerfstars as an example, the collector and enricher logs to `snowplow-nerfstars`, whereas the enriched and bad streams log to `/aws/lambda/nerfstars-sp-(enriched/bad)`.

You'll be able to see the events streaming in, and what stream they end up in if you're looking at the collector/enricher.

For debugging purposes, see `/analytics-pipeline/lambda-td/lambda_td.py`. Very helpful to print out the payload to the logs.

When you've got a bunch of enriched events, you can view them in Treasure Data, where each field is a column and each event is a new row.


### Other Notes

Feel free to ping Calvin when this isn't sufficient.

Check out PR: https://github.com/fivestars/server/pull/360

