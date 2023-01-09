source "$HOME/.cargo/env"
# Set up GraalVM
export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-lts-java11-20.3.1/Contents/Home

# Copied from the homebrew install script 2022-12-26: https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
# https://github.com/Homebrew/install/blob/3e7999a7fb0e8f38248d61d081893a628d7b6885/install.sh#L110
# First check OS.
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]
then
  HOMEBREW_ON_LINUX=1
elif [[ "${OS}" == "Darwin" ]]
then
  HOMEBREW_ON_MACOS=1
else
  abort "Homebrew is only supported on macOS and Linux."
fi

# Required installation paths. To install elsewhere (which is unsupported)
# you can untar https://github.com/Homebrew/brew/tarball/master
# anywhere you like.
if [[ -n "${HOMEBREW_ON_MACOS-}" ]]
then
  UNAME_MACHINE="$(/usr/bin/uname -m)"

  if [[ "${UNAME_MACHINE}" == "arm64" ]]
  then
    # On ARM macOS, this script installs to /opt/homebrew only
    HOMEBREW_PREFIX="/opt/homebrew"
    HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
  else
    # On Intel macOS, this script installs to /usr/local only
    HOMEBREW_PREFIX="/usr/local"
    HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  fi
  HOMEBREW_CACHE="${HOME}/Library/Caches/Homebrew"

  STAT_PRINTF=("stat" "-f")
  PERMISSION_FORMAT="%A"
  CHOWN=("/usr/sbin/chown")
  CHGRP=("/usr/bin/chgrp")
  GROUP="admin"
  TOUCH=("/usr/bin/touch")
  INSTALL=("/usr/bin/install" -d -o "root" -g "wheel" -m "0755")
else
  UNAME_MACHINE="$(uname -m)"

  # On Linux, this script installs to /home/linuxbrew/.linuxbrew only
  HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  HOMEBREW_CACHE="${HOME}/.cache/Homebrew"

  STAT_PRINTF=("stat" "--printf")
  PERMISSION_FORMAT="%a"
  CHOWN=("/bin/chown")
  CHGRP=("/bin/chgrp")
  GROUP="$(id -gn)"
  TOUCH=("/bin/touch")
  INSTALL=("/usr/bin/install" -d -o "${USER}" -g "${GROUP}" -m "0755")
fi

# All path manipulations go here for easier understanding of ordering, etc.
# Bin path ordering is important
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
PATH=/opt/local/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$GRAALVM_HOME/bin:$PATH
