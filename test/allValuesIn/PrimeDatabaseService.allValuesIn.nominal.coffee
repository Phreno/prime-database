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
path=__dirname.replace '/test/allValuesIn', '/src/service'
PrimeDatabaseService=require "#{path}/PrimeDatabaseService"
describe 'PrimeDatabaseService',->
  primeDB=new PrimeDatabaseService()
  describe 'allValuesIn(min,max,callback)',->
    describe 'nominal case',->
      it 'should work with an array when min and max',->
        primeDB.allValuesIn(
          1, 42
          , (rows)-> expect({}.toString.call rows).to.equal '[object Array]')
      it 'should work with an array when min=max=0 (no results)',->
        primeDB.allValuesIn(
          0, 0
          , (rows)-> expect({}.toString.call rows).to.equal '[object Array]')
      it 'should revert min and max if min > max', ->
        primeDB.allValuesIn(
          2,1, (rows)-> expect(rows.length).to.equal 1)
