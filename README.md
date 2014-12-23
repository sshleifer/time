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
* Work out why scripts and styles path is different for homepage
* option to lookup user_id by name + email
* Things in lib/mongo can use other async not just waterfall
* run init (setup) script on startup (on DO server)
* also look into iptables properly
* export your data
* option to start event (not log whole thing)

### Infra
* Browserfy is not general. May also be overkill?
* Errors in re-starting again. Had to remove clean

### Design
* Everything is very very basic/ugly. Prettyify
 * Find a color scheme

### **Tests**
* Work out how to mock database to test code in mongo (at the moment just hitting a test db, that is fine?)
