# Time

## A web app to help manage my (your?) time

### Current status

Not very good

### Where are we going?

#### MVP
An app that lets me track how I spend my time

#### Extensions
* A todo list
* Tie in with my gcal (and other services - http://surfkoll.se/ maybe?
* option to ask it how to spend the next period of time usefully
* Nice graphs and analysis of how time is spent
* Open it up to other people!

### Running locally

* Running `npm run dev-server` will start the server listening on port 8080.
* Any changes to important files should result in the server restarting.

### Requirements

* A number of node dependencies: `npm install`
* A running mongo daemon: `mongod`

### Technical details?

See the [plan](plan.md)

## TODO
### High level
* Think about how I am currently storing things in db. Decide whether there is a better way

### Prod
* deal with hitting non existant user
* allow user to chose a user_id. what rules should there be for this? (should we require len == 10, >= 10 for example?)
* Current way of dealing with dates/times only works on chrome

### Infra
* Work out why backbone is not working
* Add hint and lint code

### Design
* Everything is very very basic/ugly. Prettyify

### Tests
* Write test for generate_userid and correct_timezone in helpers
* Work out how to mock database to test code in mongo
* Work out how to write tests for funcs in front end js. See [this](http://blog.codeship.io/2014/01/22/testing-frontend-javascript-code-using-mocha-chai-and-sinon.html) and [this](https://shanetomlinson.com/2013/testing-javascript-frontend-part-1-anti-patterns-and-fixes/) and [this is pretty comprehensive](http://staal.io/blog/2013/08/17/incredibly-convenient-testing-of-frontend-javascript-with-node-dot-js/) we should use [grunt-mocha](https://github.com/kmiyashiro/grunt-mocha)
  * Maybe have a grunt test command that creates a test_build folder with all things set up and compiled to test? It seems we need test_html files so we could just have test.jade. Then we can have a test dir (inside scripts or not - I think not so that dev compiles everythin while prod only does scripts in scripts (not test)) with the source code for the tests. test.jade includes scripts/main and test/test as well as mocha code and the tests can be run? 
  * Have a directory (maybe in public) where we have mocha code. Set this up with app.use '/vendor', 'public/vendor' or something.
  * Not sure how to check if tests are passing - do we have to open html files manually? Not end of world but not sure how that could be integrated into a CI system.
### Documentation

## Recently done
### 4/10
* Design a somewhat useful homepage
* Have a link from the homepage to a page where you can create a user.
* Fix bugs with restarting server on file change (still minor oddity on first restart, but no problems with functinoality)
* Auto compile new pages' less and js
* plan is horrible - think about and write out how things are going to work and link to it
* Implement user pages, and link to the new user's page after a user is created
* Allow user to enter how they spent time on their user page

### 4/11
* allow you to specify start time, end time = now
