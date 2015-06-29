{ mkDerivation, aeson, base, data-default, flexible, mtl
, persistent, stdenv, text
}:
mkDerivation {
  pname = "flexible-instances";
  version = "0.2.0";
  src = ./.;
  buildDepends = [
    aeson base data-default flexible mtl persistent text
  ];
  description = "Helpful instances for Data.Flexible";
  license = stdenv.lib.licenses.mit;
}
