{
  fetchFromGitHub,
}:

{
  "tools/runner" = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "runner";
    rev = "5d5303c3a6cc90d814b7da55ce682f20b9773e76";
    hash = "sha256-J2W98wAzlWwrvQLhQsmJmd+lA/P2wWdPGQWFq7UZxWw=";
  };
}
