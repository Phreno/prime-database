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

VENDOR.program.version(CONSTANT.version).option('-n, --nth [number]', 'Donne la valeur du nombre premier à l\'indice n', 1).parse(process.argv);

if (VENDOR.program.nth) {
  print = function(row) {
    return console.log(row.value);
  };
  new LIB.primeDB().getNth(parseInt(VENDOR.program.nth), print);
}
