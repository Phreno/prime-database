chai=require 'chai'
chaiAsPromised = require 'chai-as-promised'

expect=chai.expect
assert=chai.assert
path=__dirname.replace '/test', '/src/service'

PrimeDatabaseService=require "#{path}/PrimeDatabaseService"

constant=
  DATABASE:'../database/data/primeDB.db'

describe 'PrimeDatabaseService',->
  primeDB=new PrimeDatabaseService constant.DATABASE

  # ---
  # nth
  # ---
  describe 'nth(index, callback)',->

    describe 'check errors',->

      it 'should throw ReferenceError if no index', ->
        expect(primeDB.nth.bind(primeDB)).to.throw(ReferenceError)

      it 'should not throw ReferenceError if index',->
        expect(primeDB.nth.bind(primeDB, 'I\'m a String'))
          .to.not.throw(ReferenceError)

      it 'should throw TypeError if index != number', ->
        expect(primeDB.nth.bind(primeDB, 'I\'m a string'))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof index is number',->
        expect(primeDB.nth.bind(primeDB, 1))
          .to.not.throw(TypeError)

      it 'should throw ReferenceError if no callback',->
        expect(primeDB.nth.bind(primeDB,42)).to.throw(ReferenceError)

      it 'should not throw ReferenceError when callback',->
        expect(primeDB.nth.bind(primeDB,42,'dummy'))
          .to.not.throw ReferenceError

      it 'should throw TypeError if callback != func',->
        expect(primeDB.nth.bind(primeDB,42,'I\'m a string'))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof callback is func',->
        expect(primeDB.nth.bind(primeDB,42,(()->)))
          .to.not.throw(TypeError)

      it 'when indice > max(rowid), then thow Error',->
        expect(true).to.equal false


    describe 'nominal case',->

      it 'should work with an object when indice is provided',->
        testCallback=(row)->
          expect(row).to.be.an('object')
          expect(row).to.have.property('rowid')
          expect(row).to.have.property('value')
        primeDB.nth 1, testCallback

      it 'should have rowid=indice',->
        indice=23
        testCallback=(row)->
          expect(row.rowid).to.equal indice
        primeDB.nth indice, testCallback

      it 'when indice=1, then value=2',->
        testCallback=(row)->
          expect(row.value).to.equal 2
        primeDB.nth 1, testCallback

      it 'when indice=2, then value=3',->
        testCallback=(row)->
          expect(row.value).to.equal 3
        primeDB.nth 2, testCallback

      it 'when indice=-1, then value=null',->
        testCallback=(row)->
          expect(row.value).to.equal null
        primeDB.nth -1, testCallback
