chai=require 'chai'
chaiAsPromised = require 'chai-as-promised'

expect=chai.expect
assert=chai.assert
path=__dirname.replace '/test', '/src/service'

PrimeDatabaseService=require "#{path}/PrimeDatabaseServîce"

CONSTANT=
  DATABASE:'../database/data/primeDB.db'

#TODO:split test files
describe 'PrimeDatabaseService',->
  primeDB=new PrimeDatabaseService CONSTANT.DATABASE

  # -----------
  # allValuesIn
  # -----------
  describe 'allValuesIn(min,max,callback)',->

    describe 'check errors',->

      it 'should throw ReferenceError when no args',->
        expect(primeDB.allValuesIn.bind primeDB)
          .to.throw ReferenceError

      it 'should throw ReferenceError when no max',->
        expect(primeDB.allValuesIn.bind primeDB, 42)
          .to.throw ReferenceError

      it 'should throw ReferenceError when no callback',->
        expect(primeDB.allValuesIn.bind primeDB, 42,42)
          .to.throw ReferenceError

      it 'should not throw ReferenceError when all args',->
        expect(primeDB.allValuesIn.bind primeDB, 42, 42, 'dummy')
          .to.not.throw ReferenceError

      it 'should throw TypeError when min != number',->
        expect(primeDB.allValuesIn.bind(
          primeDB
          , 'I\'m a String'
          , 42
          , (()->)
        )).to.throw TypeError

      it 'should throw TypeError when max != number',->
        expect(primeDB.allValuesIn.bind(
          primeDB
          , 42
          , 'I\'m a String'
          , (()->)
        )).to.throw TypeError

      it 'should throw TypeError when callback != function',->
        expect(primeDB.allValuesIn.bind(
          primeDB
          , 42
          , 42
          , 'I\'m a String'
        )).to.throw TypeError

      it 'should not throw TypeError when Type respect number, number, function',->
        expect(primeDB.allValuesIn.bind(
          primeDB
          , 42
          , 42
          , (()->)
        )).to.not.throw TypeError

    describe 'nominal case',->
#
# FIXME: TEST FOIREUX, ils passent alors qu'ils devraient échouer !!!! Probleme de callback ?
      it 'should work with an array when min and max',->
        testCallback=(arr)->
          expect({}.toString.call arr).to.equal '[object Array]'
        primeDB.allValuesIn 1, 42, testCallback

      it 'should work with an array when min=max=0 (no results)',->
        testCallback=(arr)->
          expect({}.toString.call arr).to.equal '[object Array]'
        primeDB.allValuesIn 0, 0, testCallback

      it 'should revert min and max if min > max', ->
        testiCallback=(arr)->
          expect(arr.length).to.equal(1)
          expect(true).to.be false
        primeDB.allValuesIn 0, 0, testiCallback

      it 'should be implemented',->
        expect(true).to.equal false

  # ------------
  # eachValuesIn
  # ------------
  describe 'eachValuesIn(min,max,callback)',->
    it 'should be implemented',->
      expect(true).to.equal false

  describe 'allIndexIn',->
    describe 'allIndexIn(min,max,callback)', ->
      it 'should be implemented',->
        expect(true).to.equal false

    describe 'allIndexIn(array,callback)',->
      it 'should be implemented',->
        expect(true).to.equal false

  describe 'eachIndexIn',->
    describe 'eachIndexIn(min,max,array)',->
      it 'should be implemented',->
        expect(true).to.equal false

    describe 'eachIndexIn',->
      it 'should be implemented',->
        expect(true).to.equal false

  describe 'next', ->
    it 'should be implemented',->
      expect(true).to.equal false

  describe 'previous',->
    it 'should be implemented',->
      expect(true).to.equal false
