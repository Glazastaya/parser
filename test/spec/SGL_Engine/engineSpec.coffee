define (require) ->
  engine = require 'SQL_Engine/engine'
  sinon = require 'sinon'
  app = require 'app'
  describe "engine", ->
    obj = []
    beforeEach ->
      spyOn(jQuery, "ajax").and.returnValue($.Deferred().resolve(
        "movie": [
         {
          "id": 1,
          "title": "The A-Team",
          "year": 2010,
          "directorID": 1
         },
         {
          "id": 2,
          "title": "Avatar",
          "year": 2009,
          "directorID": 2
         },
         {
          "id": 3,
          "title": "Titanic",
          "year": 1997,
          "directorID": 2
         }
         ],
        "director": [
         {
          "id": 1,
          "name": "Joe Carnahan"
         },
         {
          "id": 2,
          "name": "James Cameron"
         },
         {
          "id": 3,
          "name": "Joss Whedon"
         }
         ],
        "actor": [
         {
          "id": 1,
          "name": "Liam Neeson"
         },
         {
          "id": 2,
          "name": "Bradley Cooper"
         },
         {
          "id": 3,
          "name": "Jessica Biel"
         }
         ],
        "actor_to_movie": [
         {
          "actorID": 1,
          "movieID": 1
         },
         {
          "actorID": 2,
          "movieID": 1
         },
         {
          "actorID": 3,
          "movieID": 1
         }
       ]
      ))
      obj = {
        select: [{
          table: 'table'
          column: 'column'
        }]
        from: ['table']
        join: 'table1'
        where: undefined
      }
      app.init()

    it "bd", ->
      expect(engine.bd).toEqual(
        "movie": [
          {
          "id": 1,
          "title": "The A-Team",
          "year": 2010,
          "directorID": 1
          },
          {
          "id": 2,
          "title": "Avatar",
          "year": 2009,
          "directorID": 2
          },
          {
          "id": 3,
          "title": "Titanic",
          "year": 1997,
          "directorID": 2
          }
        ],
        "director": [
          {
            "id": 1,
            "name": "Joe Carnahan"
          },
          {
            "id": 2,
            "name": "James Cameron"
          },
          {
            "id": 3,
            "name": "Joss Whedon"
          }
        ],
        "actor": [
          {
            "id": 1,
            "name": "Liam Neeson"
          },
          {
            "id": 2,
            "name": "Bradley Cooper"
          },
          {
            "id": 3,
            "name": "Jessica Biel"
          }
        ],
        "actor_to_movie": [
          {
            "actorID": 1,
            "movieID": 1
          },
          {
            "actorID": 2,
            "movieID": 1
          },
          {
            "actorID": 3,
            "movieID": 1
          }
        ])


    it '_expandKey', ->
      obj = {}
      obj.tables = ['actor', 'actor_to_movie']
      expect((engine._expandKey(obj))[0][0]['actor.id']).toBeDefined()

    it '_parseQuery', ->
      expect(engine._parseQuery(obj).tables).toEqual([ 'table', 'table1' ])
    it '_parseSelect', ->
      expect(engine._parseSelect(obj)).toEqual([ 'table.column' ])
