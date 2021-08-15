#!/bin/bash
set -e

test "$(expr substr $(uname -s) 1 5)" = "Linux" || exit 0

echo "installing..."

echo "prepare environment..."
sudo apt install -y build-essential autoconf automake pkg-config libevent-dev libncurses5-dev bison byacc
echo "git clone tmux..."
#git clone https://github.com/tmux/tmux.git
pushd tmux

bash ./autogen.sh
./configure --prefix=$(pwd)/out && make -j$(nproc)
make install
popd

# tmux plug manager
if [ ! -d ~/.tmux/plugins/ ];then
	mkdir -p ~/.tmux/plugins/
fi

if [ ! -d ~/.tmux/plugins/tpm ];then
	pushd ~/.tmux/plugins/
	git clone https://github.com/tmux-plugins/tpm
	popd
fi

sudo update-alternatives --install /usr/bin/tmux tmux $(pwd)/tmux/out/bin/tmux 0

pushd ~
git clone https://github.com/gpakosz/.tmux.git ~/.tmux/myconf
ln -s -f .tmux/myconf/.tmux.conf
cp .tmux/myconf/.tmux.conf.local .
popd
