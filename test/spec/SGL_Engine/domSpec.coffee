###
define (require) ->
  sqlParser = require 'SQL_Engine/sqlParser'
  sinon = require 'sinon'
  app = require 'app'
  describe "dom", ->
    describe "input", ->
      $button = ''
      $query = ''
      beforeEach ->
        $button = affix('button.select')
        $query = affix('input.query')
        app.init()
        spyOn(sqlParser, 'query')
        $query.val('SELECT table.column FROM table JOIN table')
        $button.trigger(fakeEvent('click'))
      it "send a request", ->
        expect(sqlParser.query).toHaveBeenCalledWith('SELECT table.column FROM table JOIN table')
###