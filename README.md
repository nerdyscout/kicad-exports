kicad-exports aims to auto generate several files (gerbers, documentation, pictures, ...) for [kicad](https://kicad-pcb.org/) projects. You could run it locally or on every `git push` with [Github Actions](https://github.com/actions/).

# usage of kicad-exports with Github Actions

run kicad-exports as individual step, select `cmd` from the list of [commands](commands.sh) according whatever you want to run.

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
      - uses: nerdyscout/kicad-exports@v1.0
        with:
        # Required - command to run
          cmd: command to run on kicad files
        # optional - output directory
          dir: example
        # optional* - schematic file
          schematic: test-project.sch
        # optional* - PCB design file
          board: test-project.kicad_pcb
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

**Note**

*1: kicad-exports tries to set schematic and board file automatically. For most commands atleast one of both parameters are requiered, so they are not completly optional.  

For examples of more full workflows see [kicad-exports-test](https://github.com/nerdyscout/kicad-exports/blob/master/.github/workflows/test.yml).

# use kicad-exports local 

## Installation

You need to have [Docker](https://www.docker.com/) installed.

```
git clone --recursive https://github.com/nerdyscout/kicad-exports /some/where/kicad-exports
cd /some/where/kicad-exports
chmod +x kicad-exports.sh
make build
```

## run

go to your KiCad project folder and run kicad-exports.sh
```
cd /my/kicad/example-project
./some/where/kicad-exports/kicad-exports.sh $CMD $DIR_OUT $SCHMATIC_FILE $BOARD_FILE $MANUFACTURER $PARAMETERS 
```

`$CMD` can be anything running within the container, e.g.

```
./some/where/kicad-exports/kicad-exports.sh "eeschema_do export -f pdf $DIR $SCHEMATIC"
./some/where/kicad-exports/kicad-exports.sh "eeschema_do export -f pdf example-project.sch"
./some/where/kicad-exports/kicad-exports.sh kicad-schematic-pdf
```
All three lines produce similair output as there are several functions defined, please check out the [commands.sh](commands.sh). kicad-exports tries to guess your schematic file, board file etc, but if they are in a subfolder you have to set it manually. Parameters not needed have to be set if later on follows a needed parameter.

```
./some/where/kicad-exports/kicad-exports.sh "fabrication" "gerbers" "subfolder/example-project.sch" "subfolder/example-project.kicad_pcb"
```
This generates all fabrication data, of the project in `subfolder`, and puts it into `subfolder/gerbers`. The schematic has to be set altough not needed because `$BOARD` has to be set.

# Credits
- [Kiplot](https://github.com/INTI-CMNB/kiplot)
- [KiKit](https://github.com/yaqwsx/KiKit/blob/master/doc/cli.md)
- [KiCost](https://xesscorp.github.io/KiCost/docs/_build/singlehtml/index.html)
- [KiBoM](https://github.com/SchrodingersGat/KiBoM)
- [Tracespace](https://github.com/tracespace/tracespace/tree/master/packages/cli)
- [IBoM](https://github.com/openscopeproject/InteractiveHtmlBom/wiki/Usage)
- [kicad-tools](https://github.com/obra/kicad-tools)
- [kicad-automation-scripts](https://github.com/INTI-CMNB/kicad-automation-scripts)
