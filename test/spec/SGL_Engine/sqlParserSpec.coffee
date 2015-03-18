define (require) ->
  sqlParser = require 'SQL_Engine/sqlParser'
  select = sqlParser.select

  describe "sqlParser", ->
    operator = ['<>', '>=', '<=', '>', '<', '=', 'like']
    it "'sqlParser' is defined", ->
      expect(sqlParser).toBeDefined()
    it "select *", ->
      expect(sqlParser.query('select *')).toEqual(
        select: [{
          table: undefined
          column: '*'
        }]
        from: undefined
        join: undefined
        where: undefined

      )
    it "SELECT table.column", ->
      expect(sqlParser.query('SELECT table.column')).toEqual(
        select: [{
          table: 'table'
          column: 'column'
        }]
        from: undefined
        join: undefined
        where: undefined
      )
    it "SELECT column", ->
      expect(sqlParser.query('SELECT column')).toEqual(
        select: [{
          table: undefined
          column: 'column'
        }]
        from: undefined
        join: undefined
        where: undefined
      )
    it "SELECT table1.column, table2.column", ->
      expect(sqlParser.query('SELECT table1.column, table2.column')).toEqual(
        select: [{
          table: 'table1'
          column: 'column'
        }, {
          table: 'table2'
          column: 'column'
        }]
        from: undefined
        join: undefined
        where: undefined
      )
    it "SELECT column1, column2", ->
      expect(sqlParser.query('SELECT column1, column2')).toEqual(
        select: [{
          table: undefined
          column: 'column1'
        }, {
          table: undefined
          column: 'column2'
        }]
        from: undefined
        join: undefined
        where: undefined
      )
    it "SELECT table.column FROM *", ->
      expect(sqlParser.query('SELECT table.column FROM *')).toEqual(
        select:[{
          table: 'table'
          column: 'column'
        }]
        from: '*'
        join: undefined
        where: undefined
      )
    it "SELECT table.column FROM table", ->
      expect(sqlParser.query('SELECT table.column FROM table')).toEqual(
        select: [{
          table: 'table'
          column: 'column'
        }]
        from: ['table']
        join: undefined
        where: undefined
      )
    it "SELECT table.column FROM table1, table2", ->
      expect(sqlParser.query('SELECT table.column FROM table1, table2')).toEqual(
        select: [{
          table: 'table'
          column: 'column'
        }]
        from: ['table1', 'table2']
        join: undefined
        where: undefined
      )
    it "SELECT table.column FROM table JOIN table1", ->
      expect(sqlParser.query('SELECT table.column FROM table JOIN table1')).toEqual(
        select: [{
          table: 'table'
          column: 'column'
        }]
        from: ['table']
        join: 'table1'
        where: undefined
      )
    it "SELECT table.column FROM table JOIN table ON table.column = 5", ->
      expect(sqlParser.query('SELECT table.column FROM table JOIN table ON table.column = 5')).toEqual(
        select: [{
          table: 'table'
          column: 'column'
        }]
        from: ['table']
        join: 'table'
        where:
          comparable:
            table: 'table'
            column: 'column'
          operator: '='
          value: 5
      )
    it "SELECT column FROM table1 JOIN table2 ON table.column  = true", ->
      expect(sqlParser.query('SELECT column FROM table1 JOIN table2 ON table.column  = true')).toEqual(
        select: [{
          table: undefined
          column: 'column'
        }]
        from: ['table1']
        join: 'table2'
        where:
          comparable:
            table: 'table'
            column: 'column'
          operator: '='
          value: true
      )
      it "SELECT column FROM table1 JOIN table2 ON table.column  = table1.column1", ->
      expect(sqlParser.query('SELECT column FROM table1 JOIN table2 ON table.column  = table1.column1')).toEqual(
        select: [{
          table: undefined
          column: 'column'
        }]
        from: ['table1']
        join: 'table2'
        where:
          comparable:
            table: 'table'
            column: 'column'
          operator: '='
          value:
            table: 'table1'
            column: 'column1'
      )
    it "SELECT column FROM table1 JOIN table2 ON table.column  = 'aaaa'", ->
      expect(sqlParser.query('SELECT column FROM table1 JOIN table2 ON table.column  = "aaaa"')).toEqual(
        select: [{
          table: undefined
          column: 'column'
        }]
        from: ['table1']
        join: 'table2'
        where:
          comparable:
            table: 'table'
            column: 'column'
          operator: '='
          value: 'aaaa'
      )
    it "SELECT column FROM table1 JOIN table2 WHERE table.column  = 'aaaa'", ->
      expect(sqlParser.query('SELECT column FROM table1 JOIN table2 WHERE table.column  = "aaaa"')).toEqual(
        select: [{
          table: undefined
          column: 'column'
        }]
        from: ['table1']
        join: 'table2'
        where:
          comparable:
            table: 'table'
            column: 'column'
          operator: '='
          value: 'aaaa'
      )
    it "SELECT column FROM table1 WHERE table.column  = 'aaaa'", ->
      expect(sqlParser.query('SELECT column FROM table1 WHERE table.column  = "aaaa"')).toEqual(
        select: [{
          table: undefined
          column: 'column'
        }]
        from: ['table1']
        join: undefined
        where:
          comparable:
            table: 'table'
            column: 'column'
          operator: '='
          value: 'aaaa'
      )
    describe "test operatop", ->
      operator.forEach((arg) ->
        srt = 'SELECT column FROM table1 WHERE table.column ' + arg + ' ' +'a'
        it srt, ->
          expect(sqlParser.query(srt)).toEqual(
            select: [{
              table: undefined
              column: 'column'
            }]
            from: ['table1']
            join: undefined
            where:
              comparable:
                table: 'table'
                column: 'column'
              operator: arg
              value: 'a'
          )
      )


