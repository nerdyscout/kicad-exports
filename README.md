This project aims to auto generates several files (gerbers, documentation, pictures, ...) for kicad projects. You could run it locally or on every git push with Github actions. 

# run kicad-exports with github actions

Basic example to generate ERC and DRC report:

```
name: report
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
  ERC:
    runs-on: ubuntu-latest
    container:
      image: docker://nerdyscout/kicad-exports:stable
    steps:
    - uses: actions/checkout@v2
    - name: run kicad-exports
      run: kicad-erc
    - name: upload report
      uses: actions/upload-artifact@v1
      with:
        name: ERC
        path: report

  DRC:
    runs-on: ubuntu-latest
    container:
      image: docker://nerdyscout/kicad-exports:stable
    needs: ERC
    steps:
    - uses: actions/checkout@v2
    - name: run kicad-exports
      run: kicad-drc
    - name: upload report
      uses: actions/upload-artifact@v1
      with:
        name: DRC
        path: report
```

For more examples see [kicad-exports-test](https://github.com/nerdyscout/kicad-exports-test/tree/master/.github/workflows).

# use kicad-exports local 

## Installation

```
git clone github.com/nerdyscout/kicad-exports /some/where/kicad-exports
cd /some/where/kicad-exports
make build
```

## run

go to your KiCad project folder and run kicad-exports.sh
```
cd /my/kicad/project
./some/where/kicad-exports/kicad-exports.sh *$COMMAND*
```
*$COMMAND* can be anything running within the container, e.g.
```
./some/where/kicad-exports/kicad-exports.sh "eeschema_do export -f pdf $SCHEMATIC $DIR"
./some/where/kicad-exports/kicad-exports.sh kicad-schematic-pdf
```
both lines do the same as there are several aliases defined, checkout the [functions.sh](functions.sh)

**Note** running native commands require " but calling several aliases just list them. 

Within the container global variables are automatically defined, so you could just use these. 
```
$VERBOSE
$DIR # your kicad project dir
$SCHEMATIC # *.sch kicad file
$BOARD # *.kicad_pcbnew
$PROJECT # * project name
```

# Credits
- [Kiplot](https://github.com/INTI-CMNB/kiplot)
- [KiKit](https://github.com/yaqwsx/KiKit/blob/master/doc/cli.md)
- [KiCost](https://xesscorp.github.io/KiCost/docs/_build/singlehtml/index.html)
- [KiBoM](https://github.com/SchrodingersGat/KiBoM)
- [PCBDraw](https://github.com/yaqwsx/PcbDraw)
- [Tracespace](https://github.com/tracespace/tracespace/tree/master/packages/cli)
- [IBoM](https://github.com/openscopeproject/InteractiveHtmlBom/wiki/Usage)
- https://github.com/obra/
- https://github.com/INTI-CMNB/