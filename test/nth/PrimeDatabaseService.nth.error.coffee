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
path=__dirname.replace '/test/nth', '/src/service'
PrimeDatabaseService=require "#{path}/PrimeDatabaseService"
describe 'PrimeDatabaseService',->
  primeDB = new PrimeDatabaseService()
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
