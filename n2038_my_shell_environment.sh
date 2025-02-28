#!/bin/sh

# Activates the shell environment.
#
# Usage: n2038_my_shell_environment [--no-check] [--dev] [command=activate]
# Where:
# - "--no-check": Do not check requirements (they are checked by default);
# - "--dev": (when using "install" command): Install dev version of the scripts (otherwise stable version will be installed);
# - "command":
#   - "install": Install the scripts in the system;
#   - "update": Update the repository from remote;
#   - "activate": Just activate the shell environment.
n2038_my_shell_environment() {
  # If need to check requirements
  __n2038_is_check_requested=1

  # (If installing) If need to install dev version (otherwise stable version will be installed)
  __n2038_is_install_dev=0

  for __n2038_argument in "${@}"; do
    if [ "${__n2038_argument}" = "--no-check" ]; then
      __n2038_is_check_requested=0 && { shift || return "$?"; }
    fi
    if [ "${__n2038_argument}" = "--dev" ]; then
      __n2038_is_install_dev=1 && { shift || return "$?"; }
    fi
  done
  unset __n2038_argument

  __N2038_COMMAND_INSTALL="install"
  __N2038_COMMAND_UPDATE="update"
  __N2038_COMMAND_ACTIVATE="activate"

  [ "$#" -gt 0 ] && { __n2038_command="${1}" && shift || return "$?"; } || __n2038_command="${__N2038_COMMAND_ACTIVATE}"

  # ========================================
  # Preparations
  # ========================================
  # If debug mode is enabled (more logs will be shown)
  export N2038_IS_DEBUG="${N2038_IS_DEBUG:-"0"}"

  # Name for the scripts folder and name to be shown in logs
  export _N2038_SHELL_ENVIRONMENT_NAME="${_N2038_SHELL_ENVIRONMENT_NAME:-"my-shell-environment"}"
  if [ -z "${_N2038_SHELL_ENVIRONMENT_NAME}" ]; then
    echo "_N2038_SHELL_ENVIRONMENT_NAME cannot be empty!" >&2
    return 1
  fi

  # Repository URL to install scripts from
  export _N2038_SHELL_ENVIRONMENT_REPOSITORY_URL="${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL:-"https://github.com/Nikolai2038/my-shell-environment"}"

  # Path to folder, where the directory with scripts will be located
  __n2038_libs_path="/usr/local/lib"

  # Is "sudo" faked (not needed) for this OS
  __n2038_is_sudo_faked=0

  # ----------------------------------------
  # Termux support
  # ----------------------------------------
  if [ -n "${TERMUX_VERSION}" ]; then
    # Termux does not have "/usr/local/lib" directory - so we use app storage instead
    __n2038_libs_path="${PREFIX}/lib"

    # Termux does not need "sudo" to write to the lib directory
    sudo() { "${@}"; }
    __n2038_is_sudo_faked=1
  fi
  # ----------------------------------------

  if [ ! -d "${__n2038_libs_path}" ]; then
    echo "Libs path \"${__n2038_libs_path}\" not found - probably, \"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not implemented for your OS." >&2
    return 1
  fi
  # Path to the directory with scripts
  export _N2038_SHELL_ENVIRONMENT_PATH="${__n2038_libs_path}/${_N2038_SHELL_ENVIRONMENT_NAME}"
  unset __n2038_libs_path

  # Path to the directory with requirements scripts
  export _N2038_REQUIREMENTS_PATH="${_N2038_SHELL_ENVIRONMENT_PATH}/requirements"
  # ========================================

  # ========================================
  # Check requirements
  # ========================================
  if [ "${__n2038_is_check_requested}" = "1" ]; then
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Checking requirements..." >&2
    fi

    if ! which which > /dev/null 2>&1; then
      echo "\"which\" is not installed!" >&2
      return 1
    fi
    if ! which git > /dev/null 2>&1; then
      echo "\"git\" is not installed!" >&2
      return 1
    fi
    if ! which grep > /dev/null 2>&1; then
      echo "\"grep\" is not installed!" >&2
      return 1
    fi
    if ! which sudo > /dev/null 2>&1 && [ "${__n2038_is_sudo_faked}" = "0" ]; then
      echo "\"sudo\" is not installed!" >&2
      return 1
    fi

    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Checking requirements: success!" >&2
    fi
  fi
  unset __n2038_is_check_requested __n2038_is_sudo_faked
  # ========================================

  if [ "${__n2038_command}" = "${__N2038_COMMAND_INSTALL}" ]; then
    # ========================================
    # Installing the repository
    # ========================================
    if [ -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is already installed! Pass \"update\" argument instead of \"install\" to update it." >&2
      return 1
    fi

    echo "Cloning repository \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" to \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2

    __n2038_branch_name="main"
    if [ "${__n2038_is_install_dev}" = "1" ]; then
      __n2038_branch_name="dev"
    fi
    unset __n2038_is_install_dev
    sudo git clone --branch "${__n2038_branch_name}" "${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}.git" "${_N2038_SHELL_ENVIRONMENT_PATH}" || return "$?"
    unset __n2038_branch_name

    sudo chown --recursive "${USER}:${USER}" "${_N2038_SHELL_ENVIRONMENT_PATH}" || return "$?"

    echo "Cloning repository \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" to \"${_N2038_SHELL_ENVIRONMENT_PATH}\": success!" >&2
    # ========================================

    # ========================================
    # Installation
    # ========================================
    # ----------------------------------------
    # Installing for Bash
    # ----------------------------------------
    if which bash > /dev/null 2>&1; then
      echo "Installing for Bash..." >&2
      __n2038_bashrc_path="${HOME}/.bashrc"
      if ! [ -f "${__n2038_bashrc_path}" ] || ! grep --quiet --extended-regexp "^source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh && n2038_my_shell_environment\$" "${__n2038_bashrc_path}"; then
        # shellcheck disable=SC2320
        echo "# \"${_N2038_SHELL_ENVIRONMENT_NAME}\" - see \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" for more details
source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh && n2038_my_shell_environment activate" >> "${__n2038_bashrc_path}" || return "$?"
      fi
      unset __n2038_bashrc_path
      echo "Installing for Bash: success!" >&2
    fi
    # ----------------------------------------
    # ========================================
  elif [ "${__n2038_command}" = "${__N2038_COMMAND_UPDATE}" ]; then
    if [ ! -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed to be updated! Pass \"install\" argument instead of \"update\" to install it." >&2
      return 1
    fi

    # ========================================
    # Updating the repository
    # ========================================
    echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2
    git -C "${_N2038_SHELL_ENVIRONMENT_PATH}" pull || return "$?"
    echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\": success!" >&2
    # ========================================
  elif [ "${__n2038_command}" = "${__N2038_COMMAND_ACTIVATE}" ]; then
    if [ ! -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed! Pass \"--install\" argument to install it." >&2
      return 1
    fi

    # ========================================
    # Activating the shell environment.
    # ========================================
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\"..." >&2
    fi

    # We use external script "_n2038_activate_inner.sh" here to be able to apply new changes right now.
    # However, if this "n2038_my_shell_environment.sh" script is changed, we still need to reload the shell (in some cases).
    . "${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/_n2038_activate_inner.sh" && _n2038_activate_inner || return "$?"

    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\": success!" >&2
    fi
    # ========================================
  else
    echo "Unknown command \"${__n2038_command}\"! Available commands: \"${__N2038_COMMAND_INSTALL}\", \"${__N2038_COMMAND_UPDATE}\", \"${__N2038_COMMAND_ACTIVATE}\"." >&2
    return 1
  fi
  unset __N2038_COMMAND_ACTIVATE __N2038_COMMAND_INSTALL __N2038_COMMAND_UPDATE
}

# If this file is being executed
if [ "$(basename "$0")" = "n2038_my_shell_environment.sh" ]; then
  echo "This file is meant to be sourced, not executed! Source this file and then execute function itself:
. ${0} && n2038_my_shell_environment" >&2
  exit 1
fi
