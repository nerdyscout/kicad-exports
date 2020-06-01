This project aims to auto generate several files (gerbers, documentation, pictures, ...) for kicad projects. You could run it locally or on every `git push` with Github actions. 

# Quick usage

```
./kicad-exports $COMMAND $DIR $SCHMATIC $BOARD $PROJECT $MANUFACTURER $PARAMETERS 
```

# usage of kicad-exports with Github Actions

run kicad-exports as individual step, as `cmd` several [functions](funtions.sh) are defined. 

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
      - uses: nerdyscout/kicad-exports@master
        with:
        # Required - command to run
          cmd: command to run on kicad files
        # optional - output directory
          dir: example
        # optional - schematic file
          schematic: test-project.sch
        # optional - PCB design file
          board: test-project.kicad_pcb
        # optional - project name
          project: test-project.pro
        # optional - choose one PCB manufacturer
          manufacturer: "jlcpcb", "oshpark"
        # optional - additional parameters
          parameters: ""
      - name: upload results
        uses: actions/upload-artifact@v2
        with:
          name: example
          path: example
```

For examples of more full workflows see [kicad-exports-test](https://github.com/nerdyscout/kicad-exports-test/tree/master/.github/workflows).

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