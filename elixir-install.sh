#!/usr/bin/env bash

######### Header #################################
#
#  Author:
#    Bráulio F. Lima
#
#  Date:
#    22/02/2021
#  
#  Description:
#    install script of elixir using asdf
#
#################################################

####### Tests ###################################

# Verify if have wget

type wget >/dev/null 2>&1 || { \
	echo >&2 'required to test connection'; \
	exit 1; \
}


# Internet connection
wget -q --spider http://google.com || { \
	echo 'Need internet connection'; \
	exit 1; \
}

# verify if have git
type git >/dev/null 2>&1 || { \
	echo >&2 'required git installed.'; \
	exit 1; \
}

########## Main ##############################

# Verify asdf
type asdf >/dev/null 2>&1 || { \
	echo 'Instaling' >&2; \
       	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0; \
       echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc; \
       echo ". $HOME/.asdf/compleations/asdf.bash" >> ~/.bashrc; \
}

type node >/dev/null 2>&1 || { \
	asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git; \
	bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/import/release-team-keyring'; \
}

asdf install nodejs lts; \
asdf global nodejs lts; \

echo 'Installing erlang plugin'
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git; \

# Install earlang dependencies
echo 'Installing erlang dependencies'; \
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk; \
asdf install erlang $(asdf list all erlang | tail -1); \
ERLANG_VERSION=$(asdf list erlang); \
echo 'Installing elixir plugin'; \
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git;\

echo 'Installing elixir and phonix framework'; \
asdf install elixir 1.11.3-otp-23; \
asdf global elixir 1.11.3-otp-23; \
mix local.hex --if-missing --force; \
mix local.rebar --if-missing --force; \
mix archive.install hex phx_new 1.5.7; \
