kicad-exports aims to auto generate several files (gerbers, schematic, board plots, ...) for [kicad](https://kicad-pcb.org/) projects. You could run it locally or on every `git push` with [Github Actions](https://github.com/actions/).

# usage of kicad-exports with Github Actions
run kicad-exports as individual step, select config file from the list of [files](/config) or define your own file.
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
      - uses: nerdyscout/kicad-exports@v2.0
        with:
        # Required - plotting config file
          config: docs.kiplot.yaml
        # optional - output directory
          dir: docs
        # optional - schematic file
          schema: *.sch
        # optional - PCB design file
          board: *.kicad_pcb
      - name: upload results
        uses: actions/upload-artifact@v2.0
        with:
          name: docs
          path: docs
```
You could choose to run one [predefined example config](/config) or [write your own config](https://github.com/nerdyscout/kiplot#the-configuration-file) file. 


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

### run with predefined example config
```
kicad-exports -c docs.kiplot.yaml 
```
### run with personal config
place config file in directory of your kicad project and use relative path
```
kicad-exports -c myconfig.kiplot.yaml 
```

# Credits
- [Kiplot](https://github.com/INTI-CMNB/kiplot)
- [KiBoM](https://github.com/SchrodingersGat/KiBoM)
- [IBoM](https://github.com/openscopeproject/InteractiveHtmlBom/wiki/Usage)
- [kicad-automation-scripts](https://github.com/INTI-CMNB/kicad-automation-scripts)
- [PcbDraw](https://github.com/yaqwsx/PcbDraw)
- [kicad-git-filters](https://github.com/INTI-CMNB/kicad-git-filters)
