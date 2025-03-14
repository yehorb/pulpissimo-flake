{
  fetchFromGitHub,
}:

rec {
  pname = "pulpissimo";
  version = "7.0.0";
  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "pulpissimo";
    tag = "v${version}";
    hash = "sha256-UxbTg+bXmySZ4yOZDJWPvb7oTCm9v/Zdvh/3T8QFJfs=";
  };
}
