# Technical details

## Url structure

### /
A homepage for the app. Maybe a short intro to what it is and links to other things

### blog/
Where I can talk about things relevant to the app

### signup/
Signup to use Time - will give you a userid

### user/#{userid}
Where a user can go to modify his/her timesheets


## Directory structure
### Before build
* server.coffee: Define basic things about the server
* pages/{blog, signup, user}
    * routes.coffee: define the routes needed by that page
    * index.jade: Jadefile
    * scripts/main.coffee: frontend js
    * styles/main.less: css
* lib/.coffee: Backend libraries to interact with db, do analysis and helpers

### After build
* server -> build/server.js
* each page -> build/pages/page_name:
    * coffee compiled to js, less to css. Jade still jade.
* lib -> build/lib-js

## Database objects

### user
* name (required for signup)
* email (required for signup)
* user_id (generated on signup - option for user to choose this?)
* Events: [
    * start_time
    * end_time
    * name
* ]
