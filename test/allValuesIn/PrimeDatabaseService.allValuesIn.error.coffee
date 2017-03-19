#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: PrimeDatabaseService.nth.error - 1.0
# ................. Sun Mar 19 09:30:32 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Test les erreurs:wde PrimeDatabaseService.nth
# Intention ......: Passer à q-sqlite3
# Remarque .......:

chai=require 'chai'
expect=chai.expect
path=__dirname.replace '/test/allValuesIn', '/src/service'
PrimeDatabaseService=require "#{path}/PrimeDatabaseService"
describe 'PrimeDatabaseService',->
  primeDB = new PrimeDatabaseService()
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
      it 'should not throw TypeError when respect number, number, function',->
        expect(primeDB.allValuesIn.bind(
          primeDB
          , 42
          , 42
          , (()->)
        )).to.not.throw TypeError
      it 'should throw ReferenceError when max>maxValue',->
        expect(primeDB.allValuesIn.bind(
          primeDB
          , primeDB.context.database.maxValue
          , primeDB.context.database.maxValue + 1
          , (()->)
        )).to.throw ReferenceError
