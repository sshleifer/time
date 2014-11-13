###
Tests still required:
  Create user works when random user_id generator creates already existing id...
  Removing non existant todo/event?
###

_ = require 'underscore'
assert = require 'assert'
async = require 'async'
sinon = require 'sinon'

m = require '../lib/mongo'
h = require '../lib/helpers'

USERS = [
  {
    name: 'test'
    email: 'test@example.com'
    user_id: 'sampletestid'
  }
  {
    name: 'test2'
    email: 'test@example.com'
  }
  {
    name: 'test'
    email: 'test@example.com'
    user_id: 'event_todo'
  }
]

EVENT = [
  {
    activity: 'something'
    start_time: 'now'
    end_time: 'later'
  }
  {
    activity: 'something1'
    start_time: 'now1'
    end_time: 'later1'
  }
]

TODO= [
  {
    activity: 'something'
    estimated_time: 60
    units: 'minutes'
  }
  {
    activity: 'something1'
    estimated_time: 1
    units: 'hours'
  }
]

TESTDB = 'somesillysb'

before ->
  m.connect 'TESTDB', (err, db) ->
    db.collection('users').drop()
    db.collection('events').drop()
    db.collection('todos').drop()


describe 'MISC', ->
  it 'connects to a database', (done) ->
    m.connect 'TESTDB', (err, db) ->
      assert.equal db.databaseName, 'TESTDB'
      done()

# All other tests assume we are connected to this db
m.connect 'TESTDB', (err, db) ->

  describe 'USER', ->
    describe 'create_user', ->
      it 'creates a user when passed correct information', (done) ->
        async.waterfall [
          (cb_wf) -> m.create_user db, USERS[0], cb_wf
          (user, cb_wf) -> db.collection('users').find({user_id: USERS[0].user_id}).toArray cb_wf
        ], (err, res) ->
          assert _.isNull(err)
          assert.equal USERS[0].name, res[0].name
          assert.equal USERS[0].email, res[0].email
          assert.equal USERS[0].user_id, res[0].user_id
          assert.deepEqual [ '_id', 'name', 'email', 'user_id', 'events', 'todos' ], _.keys(res[0])
          done()

      it 'fails to create a user when passed an already used userid', (done) ->
        m.create_user db, USERS[0], (err, res) ->
          assert.equal err, 'id already taken'
          done()

      it 'creates a user, generating a user_id when not passed user_id', (done) ->
        gen_user_id = 'abcdefghij'
        stub = sinon.stub(h, 'generate_userid').returns(gen_user_id)
        async.waterfall [
          (cb_wf) -> m.create_user db, USERS[1], cb_wf
          (user, cb_wf) -> db.collection('users').find({user_id: gen_user_id}).toArray cb_wf
        ], (err, res) ->
          assert _.isNull(err)
          assert.equal USERS[1].name, res[0].name
          assert.equal USERS[1].email, res[0].email
          assert.equal gen_user_id, res[0].user_id
          assert.deepEqual [ '_id', 'name', 'email', 'events', 'user_id', 'todos' ], _.keys(res[0])
          stub.restore()
          done()

      _.each ['events', 'todos'], (i) ->
        it "correctly creates the #{i} item when creating a user", (done) ->
          gen_user_id = "qwerty#{i}"
          stub = sinon.stub(h, 'generate_userid').returns(gen_user_id)

          async.waterfall [
            (cb_wf) -> m.create_user db, USERS[1], cb_wf
            (user, cb_wf) -> db.collection('users').find({user_id: gen_user_id}).toArray cb_wf
            (user, cb_wf) -> db.collection(i).find({_id:user[0][i]}).toArray cb_wf
          ], (err, res) ->
            assert.equal -1, res[0].last_id
            assert.deepEqual [ '_id', 'last_id' ], _.keys(res[0])
            stub.restore()
            done()

    describe 'user_by_id', ->
      it 'returns the user if id exists', (done) ->
        m.create_user db, USERS[0], (err, res) ->
          m.user_by_id db, USERS[0].user_id, (err, res) ->
            assert.equal USERS[0].name, res.name
            assert.equal USERS[0].email, res.email
            assert.equal USERS[0].user_id, res.user_id
            assert.deepEqual [ '_id', 'name', 'email', 'user_id', 'events', 'todos' ], _.keys(res)
            done()

      it "returns an empty object if the user doesn't exist", (done) ->
        m.user_by_id db, 'idthatdoesnotexist', (err, res) ->
          assert.deepEqual res, null
          done()


  describe 'EVENTS', (done) ->
    before (done) ->
      m.create_user db, USERS[2], (err, res) ->
        done()

    _.each [0, 1], (i) ->
      it "correctly adds the #{i+1}th event", (done) ->
        async.waterfall [
          (cb_wf) -> m.add_event db, USERS[2].user_id, EVENT[i], cb_wf
          (res, cb_wf) -> m.events_by_id db, USERS[2].user_id, cb_wf
        ], (err, res) ->
          assert.deepEqual EVENT[i], res.events[i]
          assert.equal res.activities.length, i+1
          assert EVENT[i].activity in res.activities
          done()

    it "correctly removes an event", (done) ->
      async.waterfall [
        (cb_wf) -> m.remove_event db, USERS[2].user_id, {id: 0}, cb_wf
        (a, b, cb_wf) -> m.events_by_id db, USERS[2].user_id, cb_wf
      ], (err, res) ->
        assert.deepEqual [EVENT[1]], res.events
        done()


  describe 'TODOS', (done) ->
    before (done) ->
      m.create_user db, USERS[2], (err, res) ->
        done()

    _.each [0, 1], (i) ->
      it "correctly adds the #{i+1}th todo", (done) ->
        async.waterfall [
          (cb_wf) -> m.add_todo db, USERS[2].user_id, TODO[i], cb_wf
          (res, cb_wf) -> m.todos_by_id db, USERS[2].user_id, cb_wf
        ], (err, res) ->
          assert.equal TODO[i].activity, res.todos[i].activity
          assert.equal TODO[i].estimated_time, 60
          assert.equal res.activities.length, i+1
          assert TODO[i].activity in res.activities
          done()

    it "correctly removes an todo", (done) ->
      async.waterfall [
        (cb_wf) -> m.remove_todo db, USERS[2].user_id, {id: 1}, cb_wf
        (a, b, cb_wf) -> m.todos_by_id db, USERS[2].user_id, cb_wf
      ], (err, res) ->
        assert.equal res.todos.length, 1
        assert.equal TODO[0].activity, res.todos[0].activity
        assert.equal TODO[0].estimated_time, res.todos[0].estimated_time
        done()
