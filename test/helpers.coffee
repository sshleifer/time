_ = require 'underscore'
assert = require 'assert'

h = require '../lib/helpers'

describe 'generate_userid', ->
  it 'generates an id of the correct length if none is provided', ->
    _.each _.range(200), (i) ->
      id = h.generate_userid('')
      assert.equal 10, id.length
  it 'accepts a valid user provided id', ->
    _.each ['10charlong', 'longerthan10chars', '_1234098*&^!#$'], (input) ->
      id = h.generate_userid input
      assert.equal id, input
  it 'rejects an id with spaces', ->
    assert not h.generate_userid '12 char long'
  it 'rejects an id shorter than 10 chars', ->
    assert not h.generate_userid 'short'
  it 'rejects an id longer than 255 chars', ->
    id = ('12345678' for i in _.range(32)).join('')
    assert.equal id.length, 256
    assert not h.generate_userid id
  it 'rejects an id with unicode chars', ->
    assert not h.generate_userid '\u03A9therestisgood!'
