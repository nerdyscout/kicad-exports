FROM setsoft/kicad_auto:latest
LABEL MAINTAINER nerdyscout <nerdyscout@posteo.de>
LABEL Description="export various files from KiCad projects"
LABEL VERSION="v2.2"

RUN apt-get update 

RUN apt-get -y install git
COPY submodules/kicad-git-filters/kicad-git-filters.py /opt/git-filters/

COPY config/*.kibot.yaml /opt/kibot/config/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ARG USER=user
RUN useradd -ms /bin/bash $USER
USER $USER
WORKDIR /home/$USER

ENTRYPOINT [ "/entrypoint.sh" ]
