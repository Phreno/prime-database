#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: PrimeDatabaseService.position.nominal - 1.0
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
      it 'should be an object',->
        primeDB.position 42, (row)-> expect(row).to.be.an('object')
      it 'should have property rowid',->
        primeDB.position 42, (row)-> expect(row).to.have.property('rowid')
      it 'should have property value',->
        primeDB.position 42, (row)-> expect(row).to.have.property('value')
      it 'should have value=-1 when input=-1',->
        primeDB.position -1, (row)-> expect(row.value).to.equal -1
      it 'should have value=0 when input=0',->
        primeDB.position 0, (row)-> expect(row.value).to.equal 0
      it 'should have value=1 when input=1',->
        primeDB.position 1, (row)-> expect(row.value).to.equal 1
      it 'should have rowid=null when value=-1',->
        primeDB.position -1, (row)-> expect(row.rowid).to.equal null
      it 'should have rowid=1 when value=2',->
        primeDB.position 2, (row)-> expect(row.rowid).to.equal 1
