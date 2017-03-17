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

  # --------
  # position
  # --------
  describe 'position(number, callback)',->

    describe 'check errors',->

      it 'should throw ReferenceError if no number', ->
        expect(primeDB.position.bind(primeDB)).to.throw(ReferenceError)

      it 'should not throw ReferenceError if number',->
        expect(primeDB.position.bind(primeDB, "dummy"))
          .to.not.throw(ReferenceError)

      it 'should throw TypeError if typeof number != number', ->
        expect(primeDB.position.bind(primeDB, "I'm a string"))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof number=number',->
        expect(primeDB.position.bind(primeDB, 1))
          .to.not.throw(TypeError)

      it 'should throw ReferenceError if no callback',->
        expect(primeDB.position.bind(primeDB,42)).to.throw(ReferenceError)

      it 'should not throw ReferenceError if callback',->
        expect(primeDB.position.bind(primeDB,42,'dummy'))
          .to.not.throw ReferenceError

      it 'should throw TypeError if callback != func',->
        expect(primeDB.position.bind(primeDB,42,'I\'m a string'))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof callback function',->
        expect(primeDB.position.bind(primeDB,42,(()->)))
          .to.not.throw(TypeError)

      it 'when value > max(value), then thow Error',->
        expect(true).to.equal false

    describe 'nominal case',->

      it 'should work with an object when indice is provided',->
        testCallback=(row)->
          expect(row).to.be.an('object')
          expect(row).to.have.property('rowid')
          expect(row).to.have.property('value')
        primeDB.position 1, testCallback

      it 'should have input=value',->
        value=23
        testCallback=(row)->
          expect(row.value).to.equal value
        primeDB.position value, testCallback

      it 'when input=1, then rowid=null',->
        testCallback=(row)->
          expect(row.rowid).to.equal null
        primeDB.position 1, testCallback

      it 'when input=2, then rowid=1',->
        testCallback=(row)->
          expect(row.rowid).to.equal 1
        primeDB.position 2, testCallback

      it 'when input=-1, then rowid=null',->
        testCallback=(row)->
          expect(row.rowid).to.equal null
        primeDB.position -1, testCallback

