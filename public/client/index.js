var CONSTANT, LIB, VENDOR, bundle, ext, extra, print, service;

bundle = "/package.json";

extra = /\/[a-zA-Z]+\/client$/;

CONSTANT = {
  version: require(__dirname.replace(extra, bundle)).version
};

VENDOR = {
  program: require('commander')
};

ext = __filename.match(/\.[a-zA-Z]+$/);

service = __dirname.replace(/client.*$/, "service/PrimeDatabaseService" + ext);

LIB = {
  primeDB: require(service)
};

VENDOR.program.version(CONSTANT.version).option('-n, --nth [number]', 'Donne la valeur du nombre premier à l\'indice n').option('-p, --isPrime [number]', 'Détermine si le p est un nombre premier').option('-P, --position', 'Renvoie la position de P dans le set des nombres premiers').parse(process.argv);

if (VENDOR.program.nth) {
  print = function(row) {
    return console.log(row.value);
  };
  new LIB.primeDB().getNth(parseInt(VENDOR.program.nth), print);
  process.exit(1);
}

if (VENDOR.program.isPrime) {
  print = function(row) {
    if (row.rowId != null) {
      return console.log('true');
    } else {
      return console.log('false');
    }
  };
  new LIB.primeDB().isPrime(parseInt(VENDOR.program.isPrime), print);
  process.exit(1);
}

if (VENDOR.program.position) {
  print = function(row) {
    return console.log(row.rowid);
  };
  new LIB.primeDB().isPrime(parseInt(VENDOR.program), print);
  process.exit(1);
}
