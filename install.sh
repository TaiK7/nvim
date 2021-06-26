#!/bin/sh

# Install pip functions
install_pip_on_ubuntu() {
  sudo apt update
  sudo apt install python3-pip
}

install_pip_on_arch() {
  sudo pacman -Sy python-pip
}

install_pip_on_fedora() {
  sudo dnf check-update
  sudo dnf install -y pip
}

install_pip_on_gentoo() {
  sudo emerge --sync
  sudo emerge -avn dev-python/pip
}

install_pip() {
  echo "Installing pip..."
	[ -n "$(cat /etc/os-release | grep Ubuntu)" ] && install_pip_on_ubuntu
	[ -f "/etc/arch-release" ] && install_pip_on_arch
	[ -f "/etc/fedora-release" ] && install_pip_on_fedora
	[ -f "/etc/gentoo-release" ] && install_pip_on_gentoo
  python3 -m pip install --user --upgrade pynvim
}

ask_install_pip() {
  echo "Pip not found..."
  read -p "Do you like to install pip now?(Y/N): " answer
  [[ "$answer" != "${answer#[Yy]}" ]] && install_pip
}


# Install nodejs functions
install_node_on_ubuntu() {
  sudp apt update
  sudo apt install nodejs npm
}

install_node_on_arch() {
  sudo pacman -Sy nodejs npm
}

install_node_on_fedora() {
  sudo dnf check-update
  sudo dnf install -y nodejs
  sudo dnf install -y npm
}

install_node_on_gentoo() {
  echo "Printing current node status..."
	emerge -pqv net-libs/nodejs
	echo "Make sure the npm USE flag is enabled for net-libs/nodejs"
	echo
	read -p "If it isn't enabled, would you like to enable it with flaggie(Y/N)?: " answer
  [ "$answer" != "${answer#[Yy]}" ] && sudo flaggie net-libs/nodejs +npm
	sudo emerge -avnN net-libs/nodejs
}

install_node() {
  echo "Installing nodejs, npm, yarn..."
  [ -n "$(cat /etc/os-release | grep Ubuntu)" ] && install_node_on_ubuntu
  [ -f "/etc/arch-release" ] && install_node_on_arch
  [ -f "/etc/fedora-release" ] && install_node_on_fedora
  [ -f "/etc/gentoo-release" ] && install_node_on_gentoo

}

ask_install_node() {
  echo "Nodejs not found..."
  read -p "Do you like to install nodejs now?(Y/N): " answer
  [[ "$answer" != "${answer#[Yy]}" ]] && install_node
}


# Other functions
remove_old_config() {
  echo "Moving old neovim config folder to ~/.config/nvim.old"
  mv ~/.config/nvim ~/.config/nvim.old
}

clone_config() {
  git clone https://github.com/Tai-Github/nvim ~/.config/nvim
}


# Installer function
installer() {
  # Wellcome
  echo "Wellcome"

  # Check and remove old neovim config
  if [ -d "$HOME/.config/nvim" ]; then
    echo "-------------------------------------------------------------------------------------------"
    remove_old_config
  fi

  # Check and ask to install pip
  echo "-------------------------------------------------------------------------------------------"
  if ! [ -x "$(command -v pip3)" ]; then
    ask_install_pip
  else
    echo "Pip already installed..."
  fi
  # Check and ask to install nodejs
  echo "-------------------------------------------------------------------------------------------"
  if ! [ -x "$(command -v node)" ]; then
    ask_install_node
  else
    echo "Nodejs already installed..."
  fi

  # Check and install packer.nvim(neovim plugins manager)
  echo "-------------------------------------------------------------------------------------------"
  if [ -e "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo "Packer.nvim(neovim plugins manager) already installed..."
  else
    installpacker
  fi

  clone_config

  echo "-------------------------------------------------------------------------------------------"
  echo "Install success."
  echo "Before start neovim, I recommend you also install and activate a font from here: https://github.com/ryanoasis/nerd-fonts."
  echo "If you don't have nerd font, some UI will be broken."
  echo "Enjoy!"
}

# Call installer function
installer