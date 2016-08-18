{ mkDerivation, aeson, base, data-default, flexible, mtl
, persistent, stdenv, text, postgresql-simple, bytestring
}:
mkDerivation {
  pname = "flexible-instances";
  version = "0.2.0";
  src = ./.;
  buildDepends = [
    aeson base data-default flexible mtl persistent text postgresql-simple
    bytestring
  ];
  description = "Helpful instances for Data.Flexible";
  license = stdenv.lib.licenses.mit;
}
