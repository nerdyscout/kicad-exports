:warning: This project is still in a beta state, please use with care!

kicad-exports aims to auto generate several files (gerbers, documentation, pictures, ...) for [kicad](kicad-pcb.org/) projects. You could run it locally or on every `git push` with Github Actions. 

# tl;dr

```
cd /my/kicad/project
./kicad-exports $COMMAND $DIR_OUT $SCHMATIC_FILE $BOARD_FILE $PROJECT_FILE $MANUFACTURER $PARAMETERS 
```

# usage of kicad-exports with Github Actions

run kicad-exports as individual step, select `cmd` from list of [functions](functions.sh) according whatever you want to run.

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
      - uses: nerdyscout/kicad-exports@v0.3
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

For examples of more full workflows see [kicad-exports-test](https://github.com/nerdyscout/kicad-exports-test/blob/v0.2/.github/workflows).

# use kicad-exports local 

## Installation

You need to have [Docker](https://www.docker.com/) installed.

```
git clone --recursive https://github.com/nerdyscout/kicad-exports /some/where/kicad-exports
cd /some/where/kicad-exports
make build
```

## run

go to your KiCad project folder and run kicad-exports.sh
```
cd /my/kicad/project
./some/where/kicad-exports/kicad-exports.sh $COMMAND
```
$COMMAND can be anything running within the container, e.g.
```
./some/where/kicad-exports/kicad-exports.sh "eeschema_do export -f pdf $SCHEMATIC $DIR"
./some/where/kicad-exports/kicad-exports.sh kicad-schematic-pdf
```
Both lines produce the same output as there are several aliases defined, checkout the [functions.sh](functions.sh). kicad-exports tries to guess your schematic file, board file etc. but if they are in a subfolder you have to set it manually. 

# Credits
- [Kiplot](https://github.com/INTI-CMNB/kiplot)
- [KiKit](https://github.com/yaqwsx/KiKit/blob/master/doc/cli.md)
- [KiCost](https://xesscorp.github.io/KiCost/docs/_build/singlehtml/index.html)
- [KiBoM](https://github.com/SchrodingersGat/KiBoM)
- [PCBDraw](https://github.com/yaqwsx/PcbDraw)
- [Tracespace](https://github.com/tracespace/tracespace/tree/master/packages/cli)
- [IBoM](https://github.com/openscopeproject/InteractiveHtmlBom/wiki/Usage)
- [kicad-tools](https://github.com/obra/kicad-tools)
- [kicad-automation-scripts](https://github.com/INTI-CMNB/kicad-automation-scripts)
