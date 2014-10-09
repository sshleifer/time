_ = require 'underscore'
assert = require 'assert'

h = require '../lib/helpers'

describe 'generate_userid', ->
  it 'generates an id of the correct length', ->
    _.each [0..200], ->
      id = h.generate_userid()
      assert.equal 10, id.length

