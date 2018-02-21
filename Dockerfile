FROM centos

RUN yum -y install gcc git curl make zlib-devel bzip2 bzip2-devel \
                   readline-devel sqlite sqlite-devel openssl \
                   openssl-devel patch libjpeg libpng12 libX11 \
                   which libXpm libXext curlftpfs wget libgfortran file \
                   ruby-devel fpm rpm-build \
                   ncurses-devel \
                   libXt-devel \
                   gcc gcc-c++ gcc-gfortran \
                   perl-ExtUtils-MakeMaker \
                   net-tools strace sshfs sudo iptables

RUN yum install -y git cmake gcc-c++ gcc binutils libX11-devel libXpm-devel libXft-devel libXext-devel gcc-gfortran openssl-devel pcre-devel mesa-libGL-devel mesa-libGLU-devel glew-devel ftgl-devel mysql-devel fftw-devel cfitsio-devel graphviz-devel avahi-compat-libdns_sd-devel libldap-dev python-devel libxml2-devel gsl-static
RUN yum install -y  compat-gcc-44 compat-gcc-44-c++ compat-gcc-44-c++.gfortran

RUN cp -fv /usr/bin/gfortran /usr/bin/g95
RUN ln -s /usr/lib64/libpcre.so.1 /usr/lib64/libpcre.so.0

RUN groupadd -r integral && useradd -r -g integral integral && \
    mkdir /home/integral /data && \
    chown -R integral:integral /home/integral /data

RUN mkdir -pv /host_var; chown integral:integral /host_var &&  \
    mkdir -pv /data/rep_base_prod; chown integral:integral /data/rep_base_prod

RUN mkdir -pv /data/rep_base_prod/aux /data/ic_tree_current/ic /data/ic_tree_current/idx /data/resources /data/rep_base_prod/cat /data/rep_base_prod/ic /data/rep_base_prod/idx && \
    chown -R integral:integral /data/rep_base_prod/aux /data/ic_tree_current/ic /data/ic_tree_current/idx /data/resources /data/rep_base_prod/cat /data/rep_base_prod/ic /data/rep_base_prod/idx

USER integral

## pyenv

WORKDIR /home/integral

RUN git clone git://github.com/yyuu/pyenv.git .pyenv

ENV HOME  /home/integral
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

ARG python_version=2.7.13
RUN export PYTHON_CONFIGURE_OPTS="--enable-shared" && pyenv install $python_version
RUN pyenv global $python_version
RUN pyenv rehash


# basic

RUN pip install pip --upgrade
RUN pip install numpy scipy astropy matplotlib pyyaml pandas

## build heasoft

ENV LD_LIBRARY_PATH /home/integral/.pyenv/versions/$python_version/lib/
ENV LDFLAGS "-L/home/integral/.pyenv/versions/$python_version/lib/"

ARG heasoft_version=6.22.1
ENV HEASOFT_VERSION $heasoft_version

ADD heasoft_build.sh .
RUN sh heasoft_build.sh

ADD heasoft_init.sh .


# prep OSA

RUN rm -rf /home/integral/pfiles

## root

RUN wget https://root.cern.ch/download/root_v5.34.26.Linux-slc6_amd64-gcc4.4.tar.gz && \
    tar xvzf root_v5.34.26.Linux-slc6_amd64-gcc4.4.tar.gz && \
    rm -f root_v5.34.26.Linux-slc6_amd64-gcc4.4.tar.gz 

# osa10.2

ADD install_osa102.sh install_osa102.sh
RUN sh install_osa102.sh
ADD osa10.2_init.sh osa10.2_init.sh


ADD init.sh init.sh

