chai=require 'chai'
expect=chai.expect

PrimeDatabaseService=require __filename.replace '/test', '/src/service'
constant=
  DATABASE:'../database/data/primeDB.db'

#TODO:split test files
describe 'PrimeDatabaseService',->
  primeDB=new PrimeDatabaseService constant.DATABASE

# -------
# GET_NTH
# -------

  describe 'getNth(index, callback)',->

    describe 'check errors',->

      it 'should throw ReferenceError if no index', ->
        expect(primeDB.getNth.bind(primeDB)).to.throw(ReferenceError)

      it 'should not throw ReferenceError if index',->
        expect(primeDB.getNth.bind(primeDB, 'I\'m a String'))
          .to.not.throw(ReferenceError)

      it 'should throw TypeError if index != number', ->
        expect(primeDB.getNth.bind(primeDB, 'I\'m a string'))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof index is number',->
        expect(primeDB.getNth.bind(primeDB, 1))
          .to.not.throw(TypeError)

      it 'should throw ReferenceError if no callback',->
        expect(primeDB.getNth.bind(primeDB,42)).to.throw(ReferenceError)

      it 'should not throw ReferenceError when callback',->
        expect(primeDB.getNth.bind(primeDB,42,'dummy'))
          .to.not.throw ReferenceError

      it 'should throw TypeError if callback != func',->
        expect(primeDB.getNth.bind(primeDB,42,'I\'m a string'))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof callback is func',->
        expect(primeDB.getNth.bind(primeDB,42,(()->)))
          .to.not.throw(TypeError)

      it 'when indice > max(rowid), then thow Error',->
        expect(true).to.equal false


    describe 'nominal case',->

      it 'should work with an object when indice is provided',->
        testCallback=(row)->
          expect(row).to.be.an('object')
          expect(row).to.have.property('rowid')
          expect(row).to.have.property('value')
        primeDB.getNth 1, testCallback

      it 'should have rowid=indice',->
        indice=23
        testCallback=(row)->
          expect(row.rowid).to.equal indice
        primeDB.getNth indice, testCallback

      it 'when indice=1, then value=2',->
        testCallback=(row)->
          expect(row.value).to.equal 2
        primeDB.getNth 1, testCallback

      it 'when indice=2, then value=3',->
        testCallback=(row)->
          expect(row.value).to.equal 3
        primeDB.getNth 2, testCallback

      it 'when indice=-1, then value=null',->
        testCallback=(row)->
          expect(row.value).to.equal null
        primeDB.getNth -1, testCallback
# --------
# IS_PRIME
# --------

  describe 'isPrime(number, callback)',->

    describe 'check errors',->

      it 'should throw ReferenceError if no number', ->
        expect(primeDB.isPrime.bind(primeDB)).to.throw(ReferenceError)

      it 'should not throw ReferenceError if number',->
        expect(primeDB.isPrime.bind(primeDB, "dummy"))
          .to.not.throw(ReferenceError)

      it 'should throw TypeError if typeof number != number', ->
        expect(primeDB.isPrime.bind(primeDB, "I'm a string"))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof number=number',->
        expect(primeDB.isPrime.bind(primeDB, 1))
          .to.not.throw(TypeError)

      it 'should throw ReferenceError if no callback',->
        expect(primeDB.isPrime.bind(primeDB,42)).to.throw(ReferenceError)

      it 'should not throw ReferenceError if callback',->
        expect(primeDB.isPrime.bind(primeDB,42,'dummy'))
          .to.not.throw ReferenceError

      it 'should throw TypeError if callback != func',->
        expect(primeDB.isPrime.bind(primeDB,42,'I\'m a string'))
          .to.throw(TypeError)

      it 'should not throw TypeError if typeof callback function',->
        expect(primeDB.isPrime.bind(primeDB,42,(()->)))
          .to.not.throw(TypeError)

      it 'when value > max(value), then thow Error',->
        expect(true).to.equal false

    describe 'nominal case',->

      it 'should work with an object when indice is provided',->
        testCallback=(row)->
          expect(row).to.be.an('object')
          expect(row).to.have.property('rowid')
          expect(row).to.have.property('value')
        primeDB.isPrime 1, testCallback

      it 'should have input=value',->
        value=23
        testCallback=(row)->
          expect(row.value).to.equal value
        primeDB.isPrime value, testCallback

      it 'when input=1, then rowid=null',->
        testCallback=(row)->
          expect(row.rowid).to.equal null
        primeDB.isPrime 1, testCallback

      it 'when input=2, then rowid=1',->
        testCallback=(row)->
          expect(row.rowid).to.equal 1
        primeDB.isPrime 2, testCallback

      it 'when input=-1, then rowid=null',->
        testCallback=(row)->
          expect(row.rowid).to.equal null
        primeDB.isPrime -1, testCallback

# -------------------------
# GET_PRIMES_BETWEEN_VALUES
# -------------------------

  describe 'getPrimesBetweenValues(min,max,callback)',->

    describe 'check errors',->

      it 'should throw ReferenceError when no args',->
        expect(primeDB.getPrimesBetweenValues.bind primeDB)
          .to.throw ReferenceError

      it 'should throw ReferenceError when no max',->
        expect(primeDB.getPrimesBetweenValues.bind primeDB, 42)
          .to.throw ReferenceError

      it 'should throw ReferenceError when no callback',->
        expect(primeDB.getPrimesBetweenValues.bind primeDB, 42,42)
          .to.throw ReferenceError

      it 'should not throw ReferenceError when all args',->
        expect(primeDB.getPrimesBetweenValues.bind primeDB, 42, 42, 'dummy')
          .to.not.throw ReferenceError

      it 'should throw TypeError when min != number',->
        expect(primeDB.getPrimesBetweenValues.bind(
          primeDB
          , 'I\'m a String'
          , 42
          , (()->)
        )).to.throw TypeError

      it 'should throw TypeError when max != number',->
        expect(primeDB.getPrimesBetweenValues.bind(
          primeDB
          , 42
          , 'I\'m a String'
          , (()->)
        )).to.throw TypeError

      it 'should throw TypeError when callback != function',->
        expect(primeDB.getPrimesBetweenValues.bind(
          primeDB
          , 42
          , 42
          , 'I\'m a String'
        )).to.throw TypeError

      it 'should not throw TypeError when Type respect number, number, function',->
        expect(primeDB.getPrimesBetweenValues.bind(
          primeDB
          , 42
          , 42
          , (()->)
        )).to.not.throw TypeError



