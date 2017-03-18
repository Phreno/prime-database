#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: PrimeDatabaseService.nth.error - 1.0
# ................. Sat Mar 18 16:33:21 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Test les erreurs:wde PrimeDatabaseService.nth
# Intention ......: Passer à q-sqlite3
# Remarque .......:

chai=require 'chai'
expect=chai.expect
path=__dirname.replace '/test/position', '/src/service'
PrimeDatabaseService=require "#{path}/PrimeDatabaseService"
describe 'PrimeDatabaseService',->
  primeDB = new PrimeDatabaseService()
  describe 'position(number, callback)',->
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

