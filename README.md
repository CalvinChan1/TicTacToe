## Guide to Tracking Events using the JS tracker (FiveStars specific tips included!)
Docs on tracking events: https://github.com/snowplow/snowplow/wiki/trackers


1. Instantiate the tracker.

It looks something like this: (see: `/loyalty/jinja/default/merchant_base.jinja`)
```
<script type="text/javascript">
  ;(function(p,l,o,w,i,n,g){if(!p[i]){p.GlobalSnowplowNamespace=p.GlobalSnowplowNamespace||[];p.GlobalSnowplowNamespace.push(i);p[i]=function(){(p[i].q=p[i].q||[]).push(arguments)};p[i].q=p[i].q||[];n=l.createElement(o);g=l.getElementsByTagName(o)[0];n.async=1;n.src=w;g.parentNode.insertBefore(n,g)}}(window,document,"script","{{ ASSET_URL }}","snowplow"));

    window.snowplow("newTracker", "cf", "{{ SNOWPLOW_COLLECTOR_ENDPOINT }}", {
      appId: "merchant_web",
      platform: "web",
      discoverRootDomain: true,
    });
</script>
```

The starting tag loads snowplow.js. We have a local copy of sp.js within `loyalty/assets/js/lib` that you should reference (`{{ ASSET_URL }}` in the tag), rather than the `"//d1fc8wv8zag5ca.cloudfront.net/2.7.0/sp.js"` version hosted by Snowplow.

`window.snowplow()` is the core function you'll be calling to track events and to start a new tracker.

Arguments to `window.snowplow()` for starting a tracker:
	1. "newTracker" tells snowplow you'll be creating a new tracker
	2. "cf" is the name of the tracker
	3. `{{ SNOWPLOW_COLLECTOR_ENDPOINT }}` is an environment variable specified in `stack.sh`, so if you'd can point the tracker to a different collector based on that. 
		* Endpoint URIs: 
			* Dev: "collector.sp.awesomestartup.com"
			* Staging: "collector.sp.nerfstars.com"
	4. Lastly, this json block is the argmap. This is what the enricher looks at to determine how to enrich your data. 
		* In our case, we set appId as "merchant_web", platform to "web", and discoverRootDomain to "true" which automatically discovers and sets the configCookieDomain value to the root domain. 
		* There are tons of parameters you can configure, but be wary that turning on some parameters can cause your data to have tons of fields and thus, tons of columns. Especially `performanceTiming`.
		* Check out: https://github.com/snowplow/snowplow/wiki/1-General-parameters-for-the-Javascript-tracker#initialisation for more configuration parameters and info about each one.


2. Tracking events:
Docs on event tracking: https://github.com/snowplow/snowplow/wiki/2-Specific-event-tracking-with-the-Javascript-tracker

Built-In Events:
```
window.snowplow('trackPageView', eventName, [this.schema(eventName), this.uids_context()]);
```
Arguments (check docs for more):
1. Event kind ("page_view")
2. Event name
3. Custom contexts, where you attach one or more self-describing jsons to add in extra context to the data (validated by iglu as well)

Self-Describing Events:
```
window.snowplow('trackSelfDescribingEvent', this.schema(eventName), [
	this.uids_context(),
	this.page_title_context()
]);
```
Arguments (check docs for more):
1. Kind of event ("unstruct_event"/self-describing event)
2. Self-describing json, where you store the data pertaining to this event
3. Custom contexts, where you attach one or more self-describing jsons to add in extra context to the data (validated by iglu as well)

Tracking is fairly simple, and very similar to how Mixpanel tracking works. Wherever you'd like to track an event is where you'd add this line of code.

For the most part, you'll likely be using self-describing events.


3. Self-describing JSONs
Docs on Json Schemas: http://json-schema.org/

```
pageAnalyticsService.prototype.schema = function(eventName) {
  var event_base_json = {
    schema: 'iglu:com.fivestars.iglu/event_base/jsonschema/1-0-0',
    data: {
      event_type: 'merchant_client',
      event_name: eventName.replace(/\s+/g, '_')
                           .replace(/\+/g, 'and')
                           .replace(/\=/g, '_equals_').toLowerCase(),
      additionalProps: this.eventProperties
    }
  };
  return event_base_json;
}
```

This is what `this.schema(eventName)` returns.

The main components to this are:
* Schema
	* The schema is where the self-describing json gets validated in iglu.
	* Eg: this particular schema lives in `/analytics-pipeline/iglu/com.fivestars.iglu/event_base/jsonschema/1-0-0`
* Data
	* This is where you specify what data you'd like to pass, this is what gets enforced/validated within the schema.


4. Iglu schemas:
Docs on Iglu: https://github.com/snowplow/iglu/wiki/Iglu-technical-documentation

```
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

Every time you create a new custom context/schema, you'll need a new Iglu schema that matches and enforces the data.

This is where we enforce what ends up in the "enriched"/good vs "bad" kinesis stream, everything must be followed or it ends up in the bad stream.

Eg: "event_type" has its type enforced, and what regex it follows (alphanumeric and underscores only, no uppercase or cap).

Within the data above, we saw there were two fields, "event_type" and "event_name", which are required and must be included in the data. Anything else is optional (like "event_timestamp").

"self" is what determines what your schema url within your data will be, eg: "iglu:com.fivestars.iglu/event_base/jsonschema/1-0-0".

This covers the majority of what how you'd use Iglu schemas. Check the docs for more details.


5. Cloudwatch

How do I check whether or not my data is enriched or bad? And where does all this data end up?

Check out the Cloudwatch Logs. Depending on where you point the collector endpoint you'll need to check different logs. (fivestarsdev vs. nerfstars vs. fivestarsprod)

Using nerfstars as an example, the collector + enricher live in "snowplow-nerfstars", whereas the enriched + bad streams live in "/aws/lambda/nerfstars-sp-(enriched/bad)".

You'll be able to see the events streaming in, and what stream they end up in if you're looking at the collector/enricher.

For debugging purposes, see `/analytics-pipeline/lambda-td/lambda_td.py`. Very helpful to print out the payload to the logs.

When you've got a bunch of enriched events, you can view them in Treasure Data, where each field is a column and each event is a new row!


6. Ping Calvin when this isn't sufficient
	* Or check out the PR: https://github.com/fivestars/server/pull/360

Other clients (Android, Python, etc.) do not include as many events as JS. 

The setup is also different from the JS tracker, you'll need to the docs.

