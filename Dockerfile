FROM debian:testing
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://http.us.debian.org/debian/ testing main contrib non-free" > /etc/apt/sources.list && \
  echo "deb http://security.debian.org/ testing/updates main contrib non-free" >> /etc/apt/sources.list && \
  echo "deb http://http.us.debian.org/debian/ testing-updates main contrib non-free" >> /etc/apt/sources.list && \

  apt-get update && apt-get install -y \
  locales \
  curl \
  xterm \
  console-setup \
  wget \
  unzip \
  apt-transport-https \
  dirmngr \
  fontconfig \
  man \
  sudo \
  xauth \
  x11-xserver-utils \
  rxvt-unicode-256color \
  perl \
  libfilesys-df-perl \
  libparams-validate-perl \
  libxft-dev \
  libperl-dev \
  checkinstall \
  git && \
  apt-get remove -y rxvt-unicode-256color && \
  apt-get clean && \ 
  rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

ADD http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 /tmp/

RUN mkdir -p /tmp/rxvt_src && \
    wget -O - http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2 | tar -xjf - -C /tmp/rxvt_src

WORKDIR /tmp/rxvt_src/rxvt-unicode-9.22

RUN git clone https://github.com/Jeansen/cdmn.git && \
  patch src/rxvtperl.xs cdmn/resources/rxvtperl.xs.patch && \
  ./configure --enable-everything --enable-256-color && \
  make && checkinstall -y

WORKDIR /

CMD xrdb -load /Xresources && urxvt -pe cdmn
