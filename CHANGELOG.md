V1.0
sorry - this is not documented

V1.1
- removed [PcbDraw](https://github.com/yaqwsx/PcbDraw) as I never was able to make it work properly. 
- set timestamp of gerber files and schematic.pdf according time of last commit
- add LICENSE
- update submodules
- added [KiCad-Diff](https://github.com/Gasman2014/KiCad-Diff)

**Version prior 2.0 do not work anymore (if they ever have) do NOT use them!**

V2.0
- `-c` does not anymore select the command, it specifies a config file. This is much more flexible!
- added pcbdraw again but dumped tracespace
- all parameters are now interchangeable in their order
- add kicad-git-filters
- removed kicad-diff
- currently no kikit support anymore, would like to get it somehow back
- much better entrypoint.sh - big thx to @joaoantoniocardoso

V2.1
- update kiplot to kibot [v0.7.0](https://github.com/INTI-CMNB/KiBot/releases/tag/v0.7.0)
  - *.kiplot.yaml files now have to be called *.kibot.yaml!
  - path of pcbdraw changed, please use:
      - `style: '/usr/share/pcbdraw/styles/jlcpcb-green-hasl.json'`
      - `libs: ['/usr/share/pcbdraw/footprints/KiCAD-base']`
- using docker image `setsoft/kicad_auto:10.4-5.1.6` instead of including all packages by myself
- enable verbose output in CI runs
- add codefactor.io
- fix file permissions
- running localy you cold overwrite parameters with `--overwrite key=value`

V2.1b
- disabled verbose again

V2.2
- update [kicad_auto](https://github.com/INTI-CMNB/kicad_auto) which includes kibot [v0.8.0](https://github.com/INTI-CMNB/KiBot/releases/tag/v0.8.0)
- make verbose only avialable in local mode again
- refactor all config files, see [here](config) which file generates which output
- passing multiple config files will trigger a run of all of them. so you could now something like  `kicad-exports -c config/*.kibot.yaml -b myproject.kicad_pcb -e myproject.sch`
- running locally enables the use of [kicad-diff](https://github.com/Gasman2014/KiCad-Diff) to get a diff between two commits of a PCBs.

V2.3
- update [kicad_auto](https://github.com/INTI-CMNB/kicad_auto) which includes kibot [v0.11.0](https://github.com/INTI-CMNB/KiBot/releases/tag/v0.11.0)
- update [kicad-diff](https://github.com/Gasman2014/KiCad-Diff) to latest version
- running multiple *.kibot.yaml files is possible by executing a bundle eg `kicad-exports -c config/bundle/documentation.default.kibot.lst`. The file ending `.kibot.lst` is a used for textfiles listing all kibot.yaml files.
- refactored all config files
- refactored tests

V2.3.1
- extension of config files does allow `*.kibot.yaml` as well as `*.kibot.yml`
- added manufacterer suffix to bom files
