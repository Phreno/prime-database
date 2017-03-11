var CONSTANT, LIB, VENDOR;

CONSTANT = {
  version: require('./package.json').version
};

VENDOR = {
  program: require('commander')
};

LIB = {
  primeDB: require('./src/PrimeDatabaseService.js')
};

VENDOR.program.version(CONSTANT.version).option('-n, --nth [indice]', 'Donne la valeur du nombre premier à l\'indice n', 1).parse(process.argv);

if (VENDOR.program.nth) {
  LIB.primeDB.getNth(VENDOR.program.nth);
}
