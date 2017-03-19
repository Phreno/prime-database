#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: PrimeDatabaseService.nth.nominal - 1.0
# ................. Sat Mar 18 16:33:21 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Test le cas nominal de PrimeDatabaseService.nth
# Intention ......: Passer à q-sqlite3
# Remarque .......:

chai=require 'chai'
expect=chai.expect
path=__dirname.replace '/test/nth', '/src/service'
PrimeDatabaseService=require "#{path}/PrimeDatabaseService"
describe 'PrimeDatabaseService',->
  primeDB = new PrimeDatabaseService()
  describe 'nth(index, callback)',->
    describe 'nominal case',->
      it 'should be an object',->
        primeDB.nth 42, (row)-> expect(row).to.be.an('object')
      it 'should have property rowid',->
        primeDB.nth 42, (row)-> expect(row).to.have.property('rowid')
      it 'should have property value',->
        primeDB.nth 42, (row)-> expect(row).to.have.property('value')
      it 'should have rowid=-1 when indice=-1',->
        primeDB.nth -1, (row)-> expect(row.rowid).to.equal -1
      it 'should have rowid=0 when indice=0',->
        primeDB.nth 0, (row)-> expect(row.rowid).to.equal 0
      it 'should have rowid=1 when indice=1',->
        primeDB.nth 1, (row)-> expect(row.rowid).to.equal 1
      it 'should have value=null when indice=-1',->
        primeDB.nth -1, (row)-> expect(row.value).to.equal null
      it 'should have value=2 when indice=1',->
        primeDB.nth 1, (row)-> expect(row.value).to.equal 2
      it 'should have value=3 when indice=2',->
        primeDB.nth 2, (row)-> expect(row.value).to.equal 3
