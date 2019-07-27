# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
# CPU and RAM can be adjusted depending on your system
CPUCOUNT = "2"
RAM = "6096"
UBUNTUVERSION = "18.04"

$script_sudo = <<SCRIPT
# Get the ARCH
echo "run as > $(whoami)"
ARCH="$(uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|')"
# Install Prereq Packages
export DEBIAN_PRIORITY=critical
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
APT_OPTS="--assume-yes --no-install-suggests --no-install-recommends -o Dpkg::Options::=\"--force-confdef\" \
  -o Dpkg::Options::=\"--force-confold\""
echo "Upgrading packages ..."
apt-get update ${APT_OPTS}
apt-get dist-upgrade ${APT_OPTS}
# apt-get upgrade ${APT_OPTS}
echo "Installing prerequisites ..."
apt-get install ${APT_OPTS} \
  apt-utils gcc openssh-client bash-completion \
  build-essential curl git-core \
  libpcre3-dev mercurial pkg-config zip \
  file vim ruby wget \
  python-setuptools python-dev python3 python3-pip
export CLOUD_SDK_VERSION=232.0.0
export CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-get update ${APT_OPTS}
apt-get install -y google-cloud-sdk=${CLOUD_SDK_VERSION}-0 \
  google-cloud-sdk-app-engine-python=${CLOUD_SDK_VERSION}-0 && \
  gcloud config set core/disable_usage_reporting true &&
  gcloud config set component_manager/disable_update_check true && \
  gcloud --version
echo "Updated"
# echo 'export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"' >> ~/.bash_profile
sudo chown -R vagrant /usr/local/bin
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/ubuntu-#{UBUNTUVERSION}"
  config.vm.hostname = "assesment"

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.provision "prepare-shell", type: "shell", inline: "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile", privileged: false
  # config.vm.provision "system-setup", type: "shell", inline: $script_sudo, privileged: true
  config.vm.provision "user-setup", type: "shell", path: "bin/initial-setup.sh" , privileged: false

  %w(.vmrc .gitconfig $GCLOUD_TF_CREDS).each do |f|
    local = File.expand_path "#{f}"
    if File.exist? local
      config.vm.provision "file", source: local, destination: f
    end
  end

  # config.vm.provider "docker" do |v, override|
  #   override.vm.box = "tknerr/baseimage-ubuntu-#{UBUNTUVERSION}"
  #   config.vm.box_version = "1.0.0"
  # end

  config.vm.provider "virtualbox" do |v|
    v.memory = "#{RAM}"
    v.cpus = "#{CPUCOUNT}"
  end

end