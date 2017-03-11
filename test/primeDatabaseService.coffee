chai=require 'chai'
expect=chai.expect
PrimeDatabaseService=require '../src/PrimeDatabaseService.coffee'

constant=
  DATABASE:'../database/data/primeDB.db'

describe 'PrimeDatabaseService',->
  primeDB=new PrimeDatabaseService constant.DATABASE

  describe 'getNth(index)',->

    describe 'check errors',->

      it 'should throw ReferenceError if no input', ->
        expect(primeDB.getNth.bind(primeDB)).to.throw(ReferenceError)
        expect(primeDB.getNth.bind(primeDB, "dummy"))
          .to.not.throw(ReferenceError)

      it 'should throw TypeError if input != number', ->
        expect(primeDB.getNth.bind(primeDB, "I'm a string")).to.throw(TypeError)
        expect(primeDB.getNth.bind(primeDB, 1))
          .to.not.throw(TypeError)

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


