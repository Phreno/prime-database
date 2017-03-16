var CONSTANT, LIB, VENDOR, bundle, ext, extra, service;

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
  primeDB: require(service),
  printer: new (require('./Printer'))()
};

VENDOR.program.version(CONSTANT.version).option('-n, --nth [number]', 'Donne la valeur du nombre premier à l\'indice n').option('-p, --isPrime [number]', 'Détermine si le p est un nombre premier').option('-i, --index [number]', 'Renvoie la position de P dans le set des nombres premiers').parse(process.argv);

if (VENDOR.program.nth) {
  new LIB.primeDB().nth(parseInt(VENDOR.program.nth), LIB.printer.nth);
}

if (VENDOR.program.isPrime) {
  new LIB.primeDB().position(parseInt(VENDOR.program.isPrime), LIB.printer.isPrime);
}

if (VENDOR.program.index) {
  new LIB.primeDB().position(parseInt(VENDOR.program.index), LIB.printer.index);
}
