{
  fetchFromGitHub,
}:

rec {
  pname = "pulp-sdk";
  version = "2019.12.06";
  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "pulp-sdk";
    tag = "${version}";
    hash = "sha256-VGwIejkBovTfvl4L75l9b+ao7Wjb+Mq9XxGRd1tggho=";
    fetchSubmodules = true;
  };
}
