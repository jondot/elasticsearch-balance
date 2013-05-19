# Balance

Elastic Search Balance provides an intuitive view of your data distribution acrosss indices, shards, replicas
and nodes.


## Usage

You can use Balance as a tool to quickly analyze your data distribution. Just drop your cluster URL into the address box. 

Under the hood, two endpoints are accessed read-only:

* GET `/_cluster/nodes` - fetching node names
* GET `/_status` - fetching data and distribution

You can also set polling for 5, 15, and 60 minutes if you're
setting this on a dashboard. 

Obviously, while auto-polling, updates are to be as slow as the rate of data accumulating in your indices so there might be
no point if you have slow data growth :)


## Development

If you'd like to hack on Balance, by all means, feel free. As a guideline, Balance
uses:

* Foundation for UI styling and composition.
* D3 for Treemap and general future visualizations.
* Ember for smart binding and overall app framework.


### Setting up

Make sure you have `npm` and `bower`. Install with:


```
$ npm install bower npm -g
```


Install npm dependencies:

```
$ npm install
```

Install bower dependencies (components):

```
$ bower install
```

Run `grunt server` for development: 

```
$ grunt server
```

You should now have an auto-compiling, auto-refreshing development
environment and your browser will open pointing to Balance.

Any update will be reflected automatically in your browser.



# Contributing

Fork, implement, add tests, pull request, get my everlasting thanks and a respectable place here :).


# Copyright

Copyright (c) 2013 [Dotan Nahum](http://gplus.to/dotan) [@jondot](http://twitter.com/jondot). See MIT-LICENSE for further details.



