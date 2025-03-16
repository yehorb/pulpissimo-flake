{
  python,
}:

python.withPackages (
  pythonPkgs: with pythonPkgs; [
    dohq-artifactory
    twisted
    prettytable
    sqlalchemy
    pyelftools
    openpyxl
    xlsxwriter
    pyyaml
    numpy
    configparser
    pyvcd
    sphinx
    semver
    ipstools
  ]
)
