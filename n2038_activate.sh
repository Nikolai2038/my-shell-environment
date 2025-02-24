#!/bin/sh

# Activates the shell environment.
#
# Usage: n2038_activate [--no-check] [--install] [--update]
# Where:
# - "--no-check" - Do not check requirements (they are checked by default);
# - "--install" - Install stable version of the scripts in the system;
# - "--install-dev" - Install dev version of the scripts in the system;
# - "--update" - Update the repository from remote.
n2038_activate() {
  # If need to check requirements
  __n2038_is_check_requested=1

  # If need to update the repository
  __n2038_is_update_requested=0

  # If need to install the scripts in the system
  __n2038_is_install_requested=0

  # (If installing) If need to install dev version (otherwise stable version will be installed)
  __n2038_is_install_dev=0

  for __n2038_argument in "${@}"; do
    if [ "${__n2038_argument}" = "--no-check" ]; then
      __n2038_is_check_requested=0
    fi
    if [ "${__n2038_argument}" = "--install" ]; then
      __n2038_is_install_requested=1
    fi
    if [ "${__n2038_argument}" = "--install-dev" ]; then
      __n2038_is_install_requested=1
      __n2038_is_install_dev=1
    fi
    if [ "${__n2038_argument}" = "--update" ]; then
      __n2038_is_update_requested=1
    fi
  done
  unset __n2038_argument

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

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\"..." >&2
  fi

  # Path to folder, where the directory with scripts will be located
  __n2038_libs_path="/usr/local/lib"

  # Is "sudo" faked (not needed) for this OS
  __n2038_is_sudo_faked=0

  # ========================================
  # Termux support
  # ========================================
  if [ -n "${TERMUX_VERSION}" ]; then
    # Termux does not have "/usr/local/lib" directory - so we use app storage instead
    __n2038_libs_path="${PREFIX}/lib"

    # Termux does not need "sudo" to write to the lib directory
    sudo() { "${@}"; }
    __n2038_is_sudo_faked=1
  fi
  # ========================================

  if [ ! -d "${__n2038_libs_path}" ]; then
    echo "Libs path \"${__n2038_libs_path}\" not found - probably, \"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not implemented for your OS." >&2
    return 1
  fi
  # Path to the directory with scripts
  export _N2038_SHELL_ENVIRONMENT_PATH="${__n2038_libs_path}/${_N2038_SHELL_ENVIRONMENT_NAME}"
  unset __n2038_libs_path

  # ========================================
  # Check requirements
  # ========================================
  if [ "${__n2038_is_check_requested}" = "1" ]; then
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Checking requirements..." >&2
    fi

    if ! which --version > /dev/null 2>&1; then
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

  # ========================================
  # Installing the repository
  # ========================================
  if [ "${__n2038_is_install_requested}" = "1" ]; then
    if [ -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
      sudo rm -rf "${_N2038_SHELL_ENVIRONMENT_PATH}" || return "$?"
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
  fi

  if [ ! -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    if [ "${__n2038_is_update_requested}" = "1" ]; then
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed to be updated! Pass \"--install\" argument instead of \"--update\" to install it." >&2
      return 1
    else
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed! Pass \"--install\" argument to install it." >&2
      return 1
    fi
  fi
  # ========================================

  # ========================================
  # Updating the repository
  # ========================================
  if [ "${__n2038_is_update_requested}" = "1" ]; then
    echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2
    git -C "${_N2038_SHELL_ENVIRONMENT_PATH}" pull || return "$?"
    echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\": success!" >&2
  fi
  unset __n2038_is_update_requested
  # ========================================

  # ========================================
  # Installation
  # ========================================
  if [ "${__n2038_is_install_requested}" = "1" ]; then
    # ----------------------------------------
    # Installing for Bash
    # ----------------------------------------
    if which bash > /dev/null 2>&1; then
      echo "Installing for Bash..." >&2
      __n2038_bashrc_path="${HOME}/.bashrc"
      if ! [ -f "${__n2038_bashrc_path}" ] || ! grep --quiet --extended-regexp "^source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_activate.sh && n2038_activate\$" "${__n2038_bashrc_path}"; then
        # shellcheck disable=SC2320
        echo "# \"${_N2038_SHELL_ENVIRONMENT_NAME}\" - see \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" for more details
source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_activate.sh && n2038_activate" >> "${__n2038_bashrc_path}" || return "$?"
      fi
      unset __n2038_bashrc_path
      echo "Installing for Bash: success!" >&2
    fi
    # ----------------------------------------
  fi
  unset __n2038_is_update_requested
  # ========================================

  # ========================================
  # We use external script "_n2038_activate_inner.sh" here to be able to apply new changes right now.
  # However, if this "n2038_activate.sh" script is changed, we still need to reload the shell (in some cases).
  # ========================================
  __N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="n2038_activate.sh"

  # Required before imports
  # shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
  . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" || {
    __n2038_return_code="$?"
    if [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ]; then
      _n2038_return "0" && return 0
    fi
    [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"
  }

  # Imports
  . "./scripts/_n2038_activate_inner.sh" || return "$?"

  # Required after imports
  # shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
  . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" || return "$?"

  _n2038_activate_inner || return "$?"

  # Required after function
  # shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_function.sh
  . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
  # ========================================

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\": success!" >&2
  fi
}

# If this file is being executed
if [ "$(basename "$0")" = "n2038_activate.sh" ]; then
  echo "This file is meant to be sourced, not executed! Source this file and then execute function itself:
. ${0} && n2038_activate" >&2
  exit 1
fi
