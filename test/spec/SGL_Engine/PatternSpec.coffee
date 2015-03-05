define (require) ->
  Pattern = require 'Pattern'
  pattern = new Pattern((a) -> a)
  describe "Pattern", ->
    it "Pattern is defined", ->
      expect(Pattern).toBeDefined()
    it "exec is defined", ->
      expect(pattern.exec).toBeDefined()
    it "exec is transmitted and unchanged", ->
      expect(pattern.exec(1)).toEqual(1)
    it "then is defined", ->
      expect(pattern.then).toBeDefined()
    it "then is transforms result", ->
      expect(pattern.then((a) -> 5).exec(8).res).toEqual(5)