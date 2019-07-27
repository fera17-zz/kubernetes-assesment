#!/bin/bash

# set -eu

echo "Run non priveledged commands"
# alias python=python3
echo "run as > $(whoami)"

BASH_PROFILE=~/.profile
BREW_LINKED_DIR="/home/linuxbrew/.linuxbrew/var/homebrew/linked"

if ! grep -qF "#step1" $BASH_PROFILE;
then {
  yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh)"
  sudo mkdir -p $BREW_LINKED_DIR
  sudo chown -R $(whoami) $BREW_LINKED_DIR
  echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>$BASH_PROFILE;
  echo 'PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH' >>$BASH_PROFILE;
  echo 'PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH' >>$BASH_PROFILE;
  cat << EOF |

cdtfswitch(){
  builtin cd "$@";
  if [ -f ".tfswitchrc" ]; then
    tfswitch
  fi
}

reminder_cd() {
    builtin cd "$@" && { cdtfswitch }
}

#step1 $(date +%F)

EOF
  awk '{print}' >> $BASH_PROFILE
} fi

source $BASH_PROFILE

brew doctor
brew bundle --file=/vagrant/Brewfile -v --describe
brew bundle cleanup --file=/vagrant/Brewfile --force
brew list

if ! grep -qF "#step2" $BASH_PROFILE;
then {
  echo 'eval "$(direnv hook bash)"' >> $BASH_PROFILE
  cat << EOF |

source <(kubectl completion bash)
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

#step2 $(date +%F)
EOF
  awk '{print}' >> $BASH_PROFILE
} fi

source $BASH_PROFILE

# set aliases
FILE_ALIASES=~/.bash_aliases
[ ! -f $FILE_ALIASES ] && \
{
cat >"$FILE_ALIASES" <<EOF
alias python="python3"
alias home="cd ~"
alias pip="pip3"
alias k=kubectl
alias s="source ~/.profile"
alias cdtf='cdtfswitch'
alias tf='terraform'
alias work='cd /vagrant && direnv allow && cdtf'
EOF
} || echo 'aliases set'

source $FILE_ALIASES
source .bashrc
source $BASH_PROFILE

echo "software installed"
set +e
{
  pip3 --version
  python3 --version
  gcloud --version
  jq --version
  yq --version
  ansible --version
  jinja2 --version
  # kubectl version
}

# Test Kitchen: https://medium.com/@Joachim8675309/virtualbox-and-friends-on-macos-fd0b78c71a32
# PHP https://stephenradford.me/setup-a-new-mac-in-5-minutes/