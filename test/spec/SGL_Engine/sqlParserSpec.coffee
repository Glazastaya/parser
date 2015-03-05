define (require) ->
  Pattern = require 'Pattern'
  parsers = require 'parsers'
  sqlParser = require 'sqlParser'

  select = sqlParser.select

  describe "sqlParser", ->
    operatop = ['<>', '>=', '<=', '>', '<', '=', 'like']
    it "'sqlParser' is defined", ->
      expect(sqlParser).toBeDefined()
    it "select *", ->
      expect(sqlParser('select *')).toEqual(
        select:
          table: '*'
          column: undefined
        from:
          table: undefined
        join:
          table: undefined
          column: undefined
        where:
          column: undefined
          operator: undefined
          value: undefined
      )
    it "SELECT table.column", ->
      expect(sqlParser('SELECT table.column')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: undefined
        join:
          table: undefined
          column: undefined
        where:
          column: undefined
          operator: undefined
          value: undefined
      )
    it "SELECT table.column FROM *", ->
      expect(sqlParser('SELECT table.column FROM *')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: '*'
        join:
          table: undefined
          column: undefined
        where:
          column: undefined
          operator: undefined
          value: undefined
      )
    it "SELECT table.column FROM table", ->
      expect(sqlParser('SELECT table.column FROM table')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: 'table'
        join:
          table: undefined
          column: undefined
        where:
          column: undefined
          operator: undefined
          value: undefined
      )
    it "SELECT table.column FROM table JOIN *", ->
      expect(sqlParser('SELECT table.column FROM table JOIN *')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: 'table'
        join:
          table: '*'
          column: undefined
        where:
          column: undefined
          operator: undefined
          value: undefined
      )
    it "SELECT table.column FROM table JOIN table", ->
      expect(sqlParser('SELECT table.column FROM table JOIN table')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: 'table'
        join:
          table: 'table'
          column: undefined
        where:
          column: undefined
          operator: undefined
          value: undefined
      )
    it "SELECT table.column FROM table JOIN table.column", ->
      expect(sqlParser('SELECT table.column FROM table JOIN table.column')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: 'table'
        join:
          table: 'table'
          column: 'column'
        where:
          column: undefined
          operator: undefined
          value: undefined
      )
    it "SELECT table.column FROM table JOIN table.column WHERE column <= 5", ->
      expect(sqlParser('SELECT table.column FROM table JOIN table.column WHERE column <= 5')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: 'table'
        join:
          table: 'table'
          column: 'column'
        where:
          column: 'column'
          operator: '<='
          value: 5
      )
    describe "test operatop", ->
      operatop.forEach((arg) ->
        srt = 'SELECT table.column FROM table JOIN table.column WHERE column ' + arg + 'a'
        it srt, ->
          expect(sqlParser(srt)).toEqual(
            select:
              table: 'table'
              column: 'column'
            from:
              table: 'table'
            join:
              table: 'table'
              column: 'column'
            where:
              column: 'column'
              operator: arg
              value: 'a'
          )
      )
    it "SELECT table.column FROM table JOIN table.column WHERE column = true", ->
      expect(sqlParser('SELECT table.column FROM table JOIN table.column WHERE column = true')).toEqual(
        select:
          table: 'table'
          column: 'column'
        from:
          table: 'table'
        join:
          table: 'table'
          column: 'column'
        where:
          column: 'column'
          operator: '='
          value: true
      )

