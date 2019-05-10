{ _, expect, loadConfig } = require './test_helper'

describe 'Configure File', ->
  it 'should eq 1', ->
    expect(1).to.eq 1

describe 'Functions', ->
  before ->
    console.log '-- list functions --'
    { getConfig } = loadConfig('config.yml')
    { functions } = getConfig('staging')
    console.log '-- functions --', functions

  it 'should eq 1', ->
    expect(1).to.eq 1
