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
        expect(primeDB.getNth.bind(primeDB, "dummy")).to.not.throw(ReferenceError)
      it 'should throw TypeError if input != number', ->
        expect(primeDB.getNth.bind(primeDB, "I'm a string")).to.throw(TypeError)
        expect(primeDB.getNth.bind(primeDB, 1)).to.not.throw(TypeError)
    describe 'nominal case',->
      it 'should return an object when indice is provided',->
        result=primeDB.getNth 1
        expect(result).to.be.an('object')
      it 'should return 2 when 1 is provided',->
        result=primeDB.getNth 1
        expect(result.value).to.equal(2)
      it 'should return 3 when 2 is provided',->
        result=primeDB.getNth 2
        expect(result.value).to.equal(3)


