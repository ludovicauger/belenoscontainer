#!/bin/bash

#base=ubuntu:26.04
base=ubuntu:24.04
image=$base-hpc

cat -> singularity.$image.def << EOF
Bootstrap: docker

From: $base

%files
  /usr/local/share/ca-certificates/meteo-fr.crt /usr/local/share/ca-certificates/meteo-fr.crt
  /usr/local/share/ca-certificates/proxy1.crt   /usr/local/share/ca-certificates/proxy1.crt
  singularity.$image.def /singularity.def


%post
  DEBIAN_FRONTEND=noninteractive TZ=Europe/Paris \
  ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
  echo "Europe/Paris" > /etc/timezone && \
  apt update && \
  apt full-upgrade -y && \
  apt install -y command-not-found liblocal-lib-perl cmake make gcc gfortran git tzdata wget libwww-perl locales vim-nox \
                 man man-db manpages manpages-dev libxml-libxml-perl g++ python3-pip perl-doc build-essential \
                 libperl-dev libjson-perl libyaml-perl libdbi-perl cpanminus sqlite3 libsqlite3-dev environment-modules \
        curl \
        bzip2 \
        ca-certificates \
        libglib2.0-0 \
        libnss3 \
        libgomp1 \
        libssl3 \
        libcurl4 \
        locales \
        libstdc++6 \
        libsqlite3-0 \
                 libdbd-sqlite3-perl libopenmpi-dev openmpi-bin apt-file pciutils gdb && \
  update-ca-certificates && \
  sed -i 's/^# *fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen && \
  mandb && \
  apt update && \
  apt-file update && \
  echo 'source /usr/share/modules/init/bash' >> /etc/bash.bashrc && \
  rm -rf /home/ubuntu
      # -------------------------------------------------
    # 2️⃣ Créer le répertoire qui accueillera conda
    # -------------------------------------------------
    mkdir -p /opt/
    chmod a+rwX /opt/

    # -------------------------------------------------
    # 3️⃣ Télécharger et installer Miniforge (choisis la version qui correspond à ton architecture)
    # -------------------------------------------------
    export MINIFORGE_VERSION="23.11.0-0"   # à mettre à jour si besoin
    export MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/download/\${MINIFORGE_VERSION}/Miniforge3-\${MINIFORGE_VERSION}-Linux-x86_64.sh"

    wget -O /tmp/miniforge.sh "\${MINIFORGE_URL}" && \
        bash /tmp/miniforge.sh -b -p /opt/conda && \
        rm -f /tmp/miniforge.sh
 #  mkdir -p /opt/tactus
 #  cd /opt/tactus
 #  git clone https://github.com/ACCORD-NWP/tactus
 #  cd tactus
 #  curl -k https://install.python-poetry.org | python3 -
    #

%environment
  export GIT_SSL_NO_VERIFY=true
  export LANG=fr_FR.UTF-8
  export LANGUAGE=fr_FR:fr
  export LC_ALL=fr_FR.UTF-8

EOF
export TMPDIR=$HOME/tmp
export SINGULARITY_TMPDIR=$HOME/tmp

singularity build --fakeroot $image.sif singularity.$image.def


exit 0
singularity build --fakeroot --sandbox $image singularity.$image.def  # image dans un repertoire
singularity shell --fakeroot --writable $image                        # root
singularity shell $image                                              # marguina
singularity build --fakeroot $image.sif $image                        # creer un .sif a partir du repertoire

