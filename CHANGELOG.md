V1.0

V1.1
- removed [PcbDraw](https://github.com/yaqwsx/PcbDraw) as I never was able to make it work properly. 
- set timestamp of gerber files and schematic.pdf according time of last commit
- add LICENSE
- update submodules
- added [KiCad-Diff](https://github.com/Gasman2014/KiCad-Diff)

V2.0
- `-c` does not anymore select the command, it specifies a config file. This is much more flexible!
- added pcbdraw again but dumped tracespace
- all parameters are now interchangeable in their order
- add kicad-git-filters
- removed kicad-diff
- currently no kikit support anymore, would like to get it somehow back
- much better entrypoint.sh - big thx to @joaoantoniocardoso

V2.1
- update kiplot to latest kibot
- using docker image setsoft/kicad_auto instead of including all packages by myself
- enable verbose in CI runs
- removed tests