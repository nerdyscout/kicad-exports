FROM setsoft/kicad_auto:latest
ARG BUILD_DATE
ARG BUILD_COMMIT
ARG VERSION
ENV VERSION=$VERSION
ENV BUILD="$BUILD_DATE ($BUILD_COMMIT)"

LABEL MAINTAINER nerdyscout <nerdyscout@posteo.de>
LABEL DESCRIPTION="export various files from KiCad projects"
LABEL VERSION=$VERSION
LABEL DATE=$BUILD_DATE

RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get install -y --no-install-recommends git python3-tk
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY submodules/kicad-git-filters/kicad-git-filters.py /opt/git-filters/
COPY submodules/KiCad-Diff/ /opt/kicad-diff/

COPY config/ /opt/kibot/config/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
