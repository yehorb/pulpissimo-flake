{
  fetchurl,
}:

{
  gmp = fetchurl rec {
    pname = "gmp";
    version = "6.1.0";
    url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.bz2";
    hash = "sha256-SYRJqZTv66UniFwQQFmTQnmV0/hrh2jYzfjZ3Xxrc+g=";
  };
  mpfr = fetchurl rec {
    pname = "mpfr";
    version = "3.1.4";
    url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.bz2";
    hash = "sha256-0xA6gM2tJAftWB82GMS+0E4MktHPdxpl6tZizDl/d3U=";
  };
  mpc = fetchurl rec {
    pname = "mpc";
    version = "1.0.3";
    url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.gz";
    hash = "sha256-YX3sxuoJiJ+wjt4zCRegCxaAm424jCnDG/u0nL+I7MM=";
  };
  isl = fetchurl rec {
    pname = "isl";
    version = "0.16.1";
    url = "ftp://gcc.gnu.org/pub/gcc/infrastructure/${pname}-${version}.tar.bz2";
    hash = "sha256-QSU4u2XHmayY4X6M/NrLslelc2Ks+q/yVLD8rpcBJtI=";
  };
}
