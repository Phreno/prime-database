chai=require 'chai'
expect=chai.expect

PrimeDatabaseService=require __filename.replace '/test', '/src/service'
constant=
  DATABASE:'../database/data/primeDB.db'

#TODO:split test files
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
      it 'should work with an array when min and max',->
        testCallback=(arr)->
          expect({}.toString.call arr).to.equal '[object Array]'
          console.log typeof({}.toString.call arr)
        primeDB.allValuesIn 1, 42, testCallback

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
