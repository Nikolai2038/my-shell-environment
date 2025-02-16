#!/bin/sh

# Activates the shell environment.
#
# Usage: n2038_activate [--no-check] [--install] [--update]
# Where:
# - "--no-check" - Do not check requirements (they are checked by default);
# - "--install" - Install the scripts in the system (implies "--update");
# - "--update" - Update the repository from remote.
n2038_activate() {
  # If need to check requirements
  __n2038_is_check_requested=1

  # If need to update the repository
  __n2038_is_update_requested=0

  # If need to install the scripts in the system
  __n2038_is_install_requested=0

  for __n2038_argument in "${@}"; do
    if [ "${__n2038_argument}" = "--no-check" ]; then
      __n2038_is_check_requested=0
    fi
    if [ "${__n2038_argument}" = "--install" ]; then
      __n2038_is_install_requested=1
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

  # Repository URL to install scripts from
  export _N2038_SHELL_ENVIRONMENT_REPOSITORY_URL="${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL:-"https://github.com/Nikolai2038/my-shell-environment"}"

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\"..." >&2
  fi

  # Path to folder, where the directory with scripts will be located
  __n2038_libs_path="/usr/local/lib"
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

    if ! which bash > /dev/null 2>&1; then
      echo "\"bash\" is not installed!" >&2
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
    if ! which sudo > /dev/null 2>&1; then
      echo "\"sudo\" is not installed!" >&2
      return 1
    fi

    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Checking requirements: success!" >&2
    fi
  fi
  # ========================================

  # ========================================
  # Cloning or updating the repository
  # ========================================
  # If the repository is not cloned - we clone it
  if [ ! -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    if [ "${__n2038_is_install_requested}" = "1" ]; then
      echo "Cloning repository \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" to \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2
      sudo git clone "${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}.git" "${_N2038_SHELL_ENVIRONMENT_PATH}" || return "$?"
      sudo chown --recursive "${USER}:${USER}" "${_N2038_SHELL_ENVIRONMENT_PATH}" || return "$?"
      echo "Cloning repository \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" to \"${_N2038_SHELL_ENVIRONMENT_PATH}\": success!" >&2
    elif [ "${__n2038_is_update_requested}" = "1" ]; then
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed to be updated! Pass \"--install\" argument instead of \"--update\" to install it." >&2
      return 1
    else
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed! Pass \"--install\" argument to install it." >&2
      return 1
    fi
  # If the repository already is cloned - we update it
  else
    if [ "${__n2038_is_install_requested}" = "1" ] || [ "${__n2038_is_update_requested}" = "1" ]; then
      echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2
      git -C "${_N2038_SHELL_ENVIRONMENT_PATH}" pull || return "$?"
      echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\": success!" >&2
    fi
  fi
  # ========================================

  # ========================================
  # Installation
  # ========================================
  if [ "${__n2038_is_install_requested}" = "1" ]; then
    # ----------------------------------------
    # Installing for Bash
    # ----------------------------------------
    echo "Installing for Bash..." >&2
    __n2038_bashrc_path="${HOME}/.bashrc"
    if ! [ -f "${__n2038_bashrc_path}" ] || ! grep --quiet --extended-regexp "^source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_activate.sh && n2038_activate\$" "${__n2038_bashrc_path}"; then
      # shellcheck disable=SC2320
      echo "# \"${_N2038_SHELL_ENVIRONMENT_NAME}\" - see \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" for more details
source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_activate.sh && n2038_activate" >> "${__n2038_bashrc_path}" || return "$?"
    fi
    unset __n2038_bashrc_path
    echo "Installing for Bash: success!" >&2
    # ----------------------------------------
  fi
  # ========================================

  # ========================================
  # We use external script "_n2038_activate_inner.sh" here to be able to apply new changes right now.
  # However, if this "n2038_activate.sh" script is changed, we still need to reload the shell (in some cases).
  # ========================================
  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
  eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_activate.sh\""
  # shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
  { . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" && _n2038_required_before_imports; } || return "$?"

  # Imports
  . "./scripts/_n2038_activate_inner.sh" || return "$?"

  # shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
  { . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" && _n2038_required_after_imports; } || return "$?"

  _n2038_activate_inner || return "$?"
  # ========================================

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\": success!" >&2
  fi
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "n2038_activate.sh" ]; then
  n2038_activate "${@}" || exit "$?"
fi
