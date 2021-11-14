**ℹ️ kicad-exports will not be updated anymore! As KiBot itself runs now in CI/CD, and there is this great [template](https://github.com/nerdyscout/KiBot-CICD-Template), even better automation can be done.**

---

[![CodeFactor](https://www.codefactor.io/repository/github/nerdyscout/kicad-exports/badge)](https://www.codefactor.io/repository/github/nerdyscout/kicad-exports)
[![default](https://github.com/nerdyscout/kicad-exports/workflows/default/badge.svg)](https://github.com/nerdyscout/kicad-exports/actions?query=workflow%3Atest)

Auto generate exports (schematics, gerbers, plots) for any KiCAD5 project.
You could run it locally or on every `git push` with Github Actions.

# usage of kicad-exports with Github Actions
```yaml
name: example

on:
  push:
    paths:
    - '**.sch'
    - '**.kicad_pcb'
  pull_request:
    paths:
      - '**.sch'
      - '**.kicad_pcb'

jobs:
  example:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: nerdyscout/kicad-exports@v2.3.1
      with:
      # Required - kibot config file
        config: any.kibot.yaml
      # optional - prefix to output defined in config
        dir: docs
      # optional - schematic file
        schema: '*.sch'
      # optional - PCB design file
        board: '*.kicad_pcb'
      # optional - verbose output info
        verbose: 0
    - name: upload results
      uses: actions/upload-artifact@v2
      with:
        name: docs
        path: docs
```
The [predefined configs](/config) do run a ERC and DRC in advance, if these checks fail no exports will be generated. You could [write your own config](https://github.com/INTI-CMNB/kibot/tree/v0.8.0#the-configuration-file) file and define [filters](https://github.com/INTI-CMNB/kibot#filtering-drcerc-errors) to ignore these errors therefore forcing to export the data. In this case be careful not to end up with some faulty PCB.

> :warning: Pushing auto generated files back to the same branch you are working on manualy is a bad idea!

# use kicad-exports local 
## Installation
You need to have [Docker](https://www.docker.com/) installed.
```
git clone --recursive https://github.com/nerdyscout/kicad-exports /some/where/kicad-exports
cd /some/where/kicad-exports
make && make install
```

## run
go to your KiCad project folder and run kicad-exports
```
cd /my/kicad/example-project
kicad-exports -d $DIR_OUT -e $SCHEMA -b $BOARD -c $CONFIG 
```

> :warning: running any command your git repository will be modified using [kicad-git-filters](https://github.com/INTI-CMNB/kicad-git-filters/tree/v1.0.1)

### run with predefined example config
```
kicad-exports -c any.kibot.yaml 
```

### run with own config
place config file in directory of your kicad project and use relative path.
```
kicad-exports -c myconfig.kibot.yaml -v -s all
```
or run multiple config files
```
kicad-exports -c config/*.kibot.yaml -b myproject.kicad_pcb -e myproject.sch
```

### run bundle
[bundles](config/bundle) are a choice of configs run sequentially
```
kicad-exports -c config/bundle/documentation.default.kibot.lst
```

### generates a diff of the PCB between the given and the latest commit
```
kicad-exports -x $COMMIT_HASH -b myproject.kicad_pcb
```

## running localy enables additional paramaters
- `-v, --verbose` is useful while developing own config files
- `-o, --overwrite key=value` overwrite variables in config file
- `-s, --skip $arg` skips preflight from given config file 
- `-x, --diff $commit_hash` output differential files between $commit_hash and latest commit

# Credits
kicad-exports is just a wrapper for kibot and all it dependencies. For further details of all the tools used please see below.

- [KiBot](https://github.com/INTI-CMNB/kibot)
- [KiBoM](https://github.com/SchrodingersGat/KiBoM)
- [IBoM](https://github.com/openscopeproject/InteractiveHtmlBom/wiki/Usage)
- [kicad-automation-scripts](https://github.com/INTI-CMNB/kicad-automation-scripts)
- [PcbDraw](https://github.com/yaqwsx/PcbDraw)
- [kicad-git-filters](https://github.com/INTI-CMNB/kicad-git-filters)
- [KiCad-Diff](https://github.com/Gasman2014/KiCad-Diff)
- [kicad-boardview](https://github.com/whitequark/kicad-boardview)
