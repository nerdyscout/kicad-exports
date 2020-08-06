FROM setsoft/kicad_debian:10.3-5.1.5 as kicad
LABEL MAINTAINER nerdyscout <nerdyscout@posteo.de>
LABEL Description="export various files from KiCad projects"
LABEL VERSION="v2.0"

RUN apt-get update && \
    apt-get install -y python3-pip python3-yaml xvfb xclip xdotool xsltproc git libmagickwand-dev python3-cairo recordmydesktop

# InteractiveHtmlBom
COPY submodules/InteractiveHtmlBom/InteractiveHtmlBom /opt/InteractiveHtmlBom/
# KiBoM
COPY submodules/KiBoM /opt/kibom/
RUN cd /opt/kibom/ && python3 setup.py install
# pcbdraw
COPY submodules/PcbDraw /opt/pcbdraw/
COPY submodules/PcbDraw-Lib/KiCAD-base /opt/pcbdraw/lib/
COPY styles/*.json /opt/pcbdraw/styles/
RUN cd /opt/pcbdraw/ && python3 setup.py install
# kicad-git-filters
COPY submodules/kicad-git-filters /opt/git-filters/
# kiplot
COPY submodules/kiplot /opt/kiplot/
COPY config/*.kiplot.yaml /opt/kiplot/docs/samples/
RUN pip3 install -e /opt/kiplot/
# kicad-automation-scripts
COPY submodules/kicad-automation-scripts /opt/kicad-automation/
RUN pip3 install -r opt/kicad-automation/src/requirements.txt
RUN cd /opt/kicad-automation/ && python3 setup.py install

RUN apt-get autoremove -y && apt-get clean

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
