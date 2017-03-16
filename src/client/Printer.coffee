class Printer
  constructor:()->

  nth:(row)->
    console.log row.value
    process.exit 0

  isPrime:(row)->
    if row.rowid isnt null
      console.log 'true'
    else console.log 'false'
    process.exit 0

  index:(row)->
    if row.rowid isnt null
      console.log row.rowid
    else console.log 'false'
    process.exit 0

module.exports=Printer
