
# create usr folder in case these folders don't exist
mkdir -p /usr/local/lib
mkdir -p /usr/local/bin


# install homebrew
if test ! (which brew); then
  echo "Installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# update homebrew recipes
brew update

# install git
brew install git

# some git defaults
git config --global color.ui true
git config --global push.default simple

# Install nvm
echo "Installing nvm"
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install stable
nvm alias default stable

# Centralize global npm packages for different node versions
echo "prefix = /usr/local" > ~/.npmrc

# Install Node modules
modules=(
  pnpm
)

echo "installing node modules..."
npm install -g ${modules[@]}

# Install Brew Cask
echo "Installing brew cask..."
brew install caskroom/cask/brew-cask

# Apps
apps=(
  google-chrome
  firefox
  iterm2
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

# clone this repo
git clone https://github.com/mkmah/dotfiles ~/.dotfiles

# Make some commonly used folders
mkdir ~/personal
mkdir ~/work

