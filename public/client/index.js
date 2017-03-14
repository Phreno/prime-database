var CONSTANT, LIB, VENDOR, bundle, exit, ext, extra, print, service;

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

exit = function() {
  return process.exit(0);
};

LIB = {
  primeDB: require(service),
  exit: exit
};

VENDOR.program.version(CONSTANT.version).option('-n, --nth [number]', 'Donne la valeur du nombre premier à l\'indice n').option('-p, --isPrime [number]', 'Détermine si le p est un nombre premier').option('-i, --index [number]', 'Renvoie la position de P dans le set des nombres premiers').parse(process.argv);

if (VENDOR.program.nth) {
  print = function(row) {
    console.log(row.value);
    return LIB.exit();
  };
  new LIB.primeDB().getNth(parseInt(VENDOR.program.nth), print);
}

if (VENDOR.program.isPrime) {
  print = function(row) {
    if (row.rowid !== null) {
      console.log('true');
    } else {
      console.log('false');
    }
    return LIB.exit();
  };
  new LIB.primeDB().isPrime(parseInt(VENDOR.program.isPrime), print);
}

if (VENDOR.program.index) {
  print = function(row) {
    if (row.rowid !== null) {
      console.log(row.rowid);
    } else {
      console.log('false');
    }
    return LIB.exit();
  };
  new LIB.primeDB().isPrime(parseInt(VENDOR.program.index), print);
}
