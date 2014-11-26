# Time

## A web app to help manage my (your?) time

### Current status

Works, but is often ugly and missing functionality that would make it easier to use

### Roadmap

* More useful todos
* Tie in with my gcal (and other services - http://surfkoll.se/ maybe?)
* option to ask it how to spend the next period of time usefully
* Nice graphs and analysis of how time is spent
* Open it up to other people!


#### Requirements

* A number of node dependencies: `npm install`
* A running mongo daemon: `mongod`
  * The correct collections in the database -> db.createCollection(x), where x is todos, events, users

### Documentation

### Deploy to DO
* Log onto server
* pull
* `npm run prod-server`

### Running locally

* Running `npm run dev-server` will start the server listening on port 8080.
* Grunt should restart when changes are made
### Technical details?

See the [plan](plan.md)

## TODO

### High level
* **Think about how I am currently storing things in db. Decide whether there is a better way**
  * Particularly events and todos

### Prod
* Current way of dealing with dates/times only works on chrome. Also funny things with timezones (fixed by not doing anything??)
* Work out why scripts and styles path is different for homepage
* Signup has issues: should tell them why id is invalid. Also, with background, button is ugly when low opacity
* option to lookup user_id by name + email
* Things in lib/mongo can use other async not just waterfall
* run init (setup) script on startup (on DO server)
* also look into iptables properly
* export your data
* option to start event (not log whole thing)

### Infra
* Browserfy is not general. May also be overkill?
* Errors in re-starting again. Had to remove clean
* jshint doesn't like $

### Design
* Everything is very very basic/ugly. Prettyify
 * Find a color scheme
 * Delete user modal is bad

### **Tests**
* Work out how to mock database to test code in mongo (at the moment just hitting a test db, that is fine?)
* Work out how to write tests for funcs in front end js. See [this](http://blog.codeship.io/2014/01/22/testing-frontend-javascript-code-using-mocha-chai-and-sinon.html) and [this](https://shanetomlinson.com/2013/testing-javascript-frontend-part-1-anti-patterns-and-fixes/) and [this is pretty comprehensive](http://staal.io/blog/2013/08/17/incredibly-convenient-testing-of-frontend-javascript-with-node-dot-js/) we should use [grunt-mocha](https://github.com/kmiyashiro/grunt-mocha)
  * Maybe have a grunt test command that creates a test_build folder with all things set up and compiled to test? It seems we need test_html files so we could just have test.jade. Then we can have a test dir (inside scripts or not - I think not so that dev compiles everythin while prod only does scripts in scripts (not test)) with the source code for the tests. test.jade includes scripts/main and test/test as well as mocha code and the tests can be run? 
  * Have a directory (maybe in public) where we have mocha code. Set this up with app.use '/vendor', 'public/vendor' or something.
  * Not sure how to check if tests are passing - do we have to open html files manually? Not end of world but not sure how that could be integrated into a CI system.

