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
### Prod
* deal with hitting non existant user
* Current way of dealing with dates/times only works on chrome

### Infra
* Work out why backbone is not working
* Add jslint/lint

### Design
* Everything is very very basic/ugly. Prettyify

### Tests
* Write test for mongo and helpers library functions

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
