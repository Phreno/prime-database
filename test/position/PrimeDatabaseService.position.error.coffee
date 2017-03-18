#!/usr/bin/env coffee

# Développeur ....: K3rn€l_P4n1K
# Description ....: PrimeDatabaseService.nth.error - 1.0
# ................. Sat Mar 18 16:33:21 CET 2017
# Plateformes ....: Ubuntu

# Fonctionnalité .: Test les erreurs de PrimeDatabaseService.position
# Intention ......: Passer à q-sqlite3
# Remarque .......:

chai=require 'chai'
expect=chai.expect
path=__dirname.replace '/test/position', '/src/service'
PrimeDatabaseService=require "#{path}/PrimeDatabaseService"
describe 'PrimeDatabaseService',->
  primeDB = new PrimeDatabaseService()
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
