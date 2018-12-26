#! /bin/bash

# Download latest Golang release for AMD64
# https://dl.google.com/go/go1.11.4.darwin-amd64.pkg

set -euf -o pipefail
# Install pre-reqs
#sudo apt-get install python3 -y
o=$(python3 -c $'import os\nprint(os.get_blocking(0))\nos.set_blocking(0, True)')

#Download Latest Go
GOURLREGEX='https://dl.google.com/go/go[0-9\.]+\.linux-amd64.tar.gz'
echo "Finding latest version of Go for AMD64..."
url="$(wget -qO- https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 )"
latest="$(echo $url | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2 )"
echo "Downloading latest Go for AMD64: ${latest}"
wget --quiet --continue --show-progress "${url}"
unset url
unset GOURLREGEX

# Remove Old Go
if [ -d '/usr/local/go' ]; then
    sudo rm -rf /usr/local/go
fi
if [ -d "$HOME/go" ]; then
    sudo rm -rf ~/go
fi

#export GOROOT=$HOME/go
#export GOPATH=$HOME/work
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Install new Go
sudo tar -C ~ -xzf go"${latest}".linux-amd64.tar.gz
echo "Create the skeleton for your local users go directory"
mkdir -p ~/go/{bin,pkg,src}
echo "Setting up GOROOT"
echo "export GOROOT=~/go" >> ~/.profile && source ~/.profile
echo "Setting up GOPATH"
if [ ! -d "$HOME/projects/go" ]; then
    if [ ! -d "$HOME/projects/" ]; then
        mkdir ~/projects
    fi
    mkdir ~/projects/go
fi
echo "export GOPATH=~/projects/go" >> ~/.profile && source ~/.profile
echo "Setting PATH to include golang binaries"
echo "export PATH='$PATH':$GOROOT/bin:$GOPATH/bin" >> ~/.profile && source ~/.profile
echo "Installing dep for dependency management"
go get -u github.com/golang/dep/cmd/dep

# Remove Download
rm go"${latest}".linux-amd64.tar.gz

# Print Go Version
go version
python3 -c $'import os\nos.set_blocking(0, '$o')'
