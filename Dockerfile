FROM setsoft/kicad_auto:10.4-5.1.6
LABEL MAINTAINER nerdyscout <nerdyscout@posteo.de>
LABEL DESCRIPTION="export various files from KiCad projects"
LABEL VERSION="v2.2"

RUN apt-get update 
RUN apt-get install -y --no-install-recommends git python3-tk
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY submodules/kicad-git-filters/kicad-git-filters.py /opt/git-filters/
COPY submodules/KiCad-Diff/ /opt/kicad-diff/

COPY config/* /opt/kibot/config/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
