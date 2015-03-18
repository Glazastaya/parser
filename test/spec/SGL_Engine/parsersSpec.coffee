define (require) ->
    Pattern = require 'SQL_Engine/Pattern'
    parsers = require 'SQL_Engine/parsers'

    describe "parsers", ->
      describe "txt", ->
        it "'txt' is defined", ->
          expect(parsers.txt).toBeDefined()
        it "should find predefined string", ->
          expect(parsers.txt('abc').exec('abc', 0)).toEqual({
            res: 'abc',
            end: 3
          })
          expect(parsers.txt('abc').exec('def', 0)).toEqual( undefined )

      describe "rgx", ->
        it "'rgx' is defined", ->
          expect(parsers.rgx).toBeDefined()
        it "should match regular expression", ->
          expect(parsers.rgx(/\d+/).exec("123", 0)).toEqual({
            res: "123",
            end: 3
          })
          expect(parsers.rgx(/\d+/).exec("abc", 0)).toEqual( undefined )

      describe "opt", ->
        it "'opt' is defined", ->
          expect(parsers.opt).toBeDefined()
        it "makes pattern optional", ->
          expect(parsers.opt(parsers.txt("abc")).exec("abc", 0)).toEqual({
            res: "abc",
            end: 3
          })
          expect(parsers.opt(parsers.txt("abc")).exec("123", 0)).toEqual({
            res: undefined,
            end: 0
          })

      describe "exc", ->
        p = parsers.exc(parsers.rgx(/[A-Z]/), parsers.txt("H"))

        it "'exc' is defined", ->
          expect(parsers.exc).toBeDefined()
        it "excluded from result that parching second pattern", ->
          expect(p.exec("R", 0)).toEqual({
            res: "R",
            end: 1
          })
          expect(p.exec("H", 0)).toEqual( false )

      describe "any", ->
        p = parsers.any(parsers.txt("abc"), parsers.txt("def"));

        it "'any' is defined", ->
          expect(parsers.any).toBeDefined()
        it "'any' try parsing received patterns and produce result first successful attempts ", ->
          expect(p.exec("abc", 0)).toEqual({
            res: "abc",
            end: 3
          })
          expect(p.exec("def", 0)).toEqual({
            res: "def",
            end: 3
          })
          expect(p.exec("ABC", 0)).toEqual( undefined )

      describe "seq", ->
        p = parsers.seq(parsers.txt("abc"), parsers.txt("def"))

        it "'seq' is defined", ->
          expect(parsers.seq).toBeDefined()
        it "'seq' sequentially parsing string all received patterns and collects matches in 'res'", ->
          expect(p.exec("abcdef", 0)).toEqual({
            res: ["abc", "def"],
            end: 6
          })
        it "don't parsing, if have not suitable pattern", ->
          expect(p.exec("abcde7")).toEqual( undefined )

      describe "rep", ->
        p = parsers.rep(parsers.rgx(/\d+/), parsers.txt(","))
        
        it "'rep' is defined", ->
          expect(parsers.rep).toBeDefined()
        it "parsing what can be the first pattern except result parsing the second", ->
          expect(p.exec("1,23,456", 0)).toEqual({
            res: ["1", "23", "456"],
            end: 8
          })
        it "if parameter which parsing contains don't suitable characters, they do not fall within
            the result, ", ->
          expect(p.exec("123ABC", 0)).toEqual({
            res: ["123"],
            end: 3
          })
        it "when parameter which parsing contains don't suitable characters, then process stops", ->
          expect(p.exec("ABC,123", 0)).toEqual({
            res: [  ],
            end: 0
          })