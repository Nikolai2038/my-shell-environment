#!/bin/sh

export _N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED=238
export _N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE=239
export _N2038_RETURN_CODE_NOT_PASSED_TO_UNSET=240

# Value for this variable must not be in the variable name itself - otherwise it can unset itself in "_n2038_unset_imports" (right now it won't but just to be sure)
export _N2038_FILE_IS_SOURCED_PREFIX="_N2038_FILE_IS_SOURCED_WITH_HASH_"

export _N2038_TRUE='true'
export _N2038_FALSE='false'

# Unset local variables (starts with "__n2038") and local constants (starts with "__N2038") and then return passed return code.
#
# Usage:
# - instead of: some_function || return "$?"
#   use:        some_function || { _n2038_unset "$?" && return "$?" || return "$?"; }
# - instead of: return 0
#   use:        _n2038_unset 0 && return "$?" || return "$?"
# - instead of: return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
#   use:        _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
_n2038_unset() {
  if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments passed to \"_n2038_unset\"! Expected 1, but got $#. Passed arguments: $*" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  if [ -z "${1}" ]; then
    echo "Empty return code passed to \"_n2038_unset\"!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  __n2038_variables_to_unset="$(set | sed -En "s/^(__n2038_[a-zA-Z0-9_]+)=.*\$/\1/p")" || {
    echo "Failed to get local variables in \"_n2038_unset\"! Return code: \"$?\"." >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  }

  # "ksh" requires variable names, so we check for that to avoid error message
  if [ -n "${__n2038_variables_to_unset}" ]; then
    # shellcheck disable=SC2086
    unset ${__n2038_variables_to_unset} || {
      echo "Failed to unset local variables in \"_n2038_unset\"! Return code: \"$?\"." >&2
      return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
    }
  fi

  if [ "${1}" != "0" ] && [ "${1}" != "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" ]; then
    echo "Error with return code \"${1}\" occurred!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  return "${1}"
}

# Special function to return from script.
# If script is being executed - it will exit with the given code.
# If script is being sourced - it will return with the given code.
#
# Usage: _n2038_return [return_code]
_n2038_return() {
  [ "$#" -gt 0 ] && { { __n2038_return_code="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || {
    echo "Return code is not provided to \"_n2038_return\"! Result code will become 1." >&2
    __n2038_return_code=1
  }

  if [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ]; then
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Ignoring return code from $(basename "$0")!" >&2
    fi
    __n2038_return_code=0
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  # If file is being executed
  if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ]; then
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Exiting from $(basename "$0") with code \"${__n2038_return_code}\"!" >&2
    fi

    _n2038_unset "${__n2038_return_code}" && exit "$?" || exit "$?"
  # If file is being sourced
  else
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Returning from $(basename "$0") with code \"${__n2038_return_code}\"!" >&2
    fi

    _n2038_unset "${__n2038_return_code}" && return "$?" || return "$?"
  fi

  _n2038_unset 0 && return "$?" || return "$?"
}

_n2038_unset_imports() {
  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Unsetting all imports..." >&2
  fi

  # "xxhsum" will generate only "[a-z0-9]" for hash, so we check only for them
  # shellcheck disable=SC2046
  unset $(set | sed -En "s/^(${_N2038_FILE_IS_SOURCED_PREFIX}[a-z0-9]+)=.*\$/\\1/p") || return "$?"

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Unsetting all imports: success!" >&2
  fi

  return 0
}

_n2038_required_before_imports() {
  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
  eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}\""

  # Full path to the script
  __n2038_script_file_path="$(eval "echo \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ ! -f "${__n2038_script_file_path}" ]; then
    echo "File \"${__n2038_script_file_path}\" not found! Check if \"__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT\" was set correctly." >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Starting to source \"${__n2038_script_file_path}\"..." >&2
  fi
  # ========================================
  # Check about file being sourced
  # ========================================
  # "_n2038_activate_inner" is executing from "n2038_my_shell_environment" where we source it every time - so we skip it here
  if [ "${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}" != "scripts/_n2038_activate_inner.sh" ] \
    && [ "${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}" != "scripts/_n2038_activate_inner_bash.sh" ]; then
    # We check both script path and it's contents
    __n2038_script_file_hash="$(xxhsum -H0 "${__n2038_script_file_path}" | cut -d ' ' -f 1)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    __n2038_script_file_is_sourced_variable_name="${_N2038_FILE_IS_SOURCED_PREFIX}${__n2038_script_file_hash}"
    __n2038_current_file_is_sourced="$(eval "echo \"\${${__n2038_script_file_is_sourced_variable_name}}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # If file is already sourced - we won't source it.
    if [ "${__n2038_current_file_is_sourced}" = "${_N2038_TRUE}" ]; then
      if [ "${N2038_IS_DEBUG}" = "1" ]; then
        echo "Skipping already sourced \"${__n2038_script_file_path}\": ${__n2038_script_file_is_sourced_variable_name}..." >&2
      fi

      : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))" || { _n2038_unset "$?" && return "$?" || return "$?"; }

      # NOTE: We use return here to not exit terminal, when sourcing script.
      # NOTE: Also, we use special code to track it later and then turn it down to just 0.
      return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}"
    else
      if [ "${N2038_IS_DEBUG}" = "1" ]; then
        echo "Sourcing \"${__n2038_script_file_path}\"..." >&2
      fi
    fi

    # NOTE: Do not use export here - because it will break executing scripts - declared functions will not be available in them
    eval "${__n2038_script_file_is_sourced_variable_name}=${_N2038_TRUE}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi
  # ========================================

  # Save current working directory
  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${PWD}\"" >&2
  fi
  eval "_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${PWD}\"" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Change current directory to the script directory to be able to easily import other scripts
  cd "$(dirname "${__n2038_script_file_path}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required steps after imports.
#
# Usage: _n2038_required_after_imports
_n2038_required_after_imports() {
  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Required after imports..." >&2
    echo "cd \"\${_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" >&2
  fi

  eval "cd \"\${_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  eval "unset _N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Required after imports: success!" >&2
  fi

  return 0
}

# Required steps after function declaration.
# Checks if this file is being executed or sourced.
# If this file is being executed - it will execute the function itself.
# If this file is being sourced - it will do nothing.
#
# Usage: _n2038_required_after_function
_n2038_required_after_function() {
  # Full path to the script
  __n2038_script_file_path="$(eval "echo \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ -f "${__n2038_script_file_path}" ]; then
    __n2038_function_name="$(eval "sed -En 's/^(function )?([a-z0-9_]+)[[:space:]]*\\(\\)[[:space:]]*\{[[:space:]]*\$/\\2/p' \"${__n2038_script_file_path}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    # Not all files will have function with the same name - for example, constants and aliases.
    # So we don't consider this as error here.
    if [ -n "${__n2038_function_name}" ]; then
      # If this file is being executed - we execute function itself
      if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ]; then
        "${__n2038_function_name}" "$@" || exit "$?"
      fi
    fi
  fi

  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_unset 0 && return "$?" || return "$?"
}

# Checks if the specified commands are installed.
# Returns 0 if all the commands are installed, otherwise returns other values.
#
# Usage: _n2038_commands_must_be_installed <command...>
_n2038_commands_must_be_installed() {
  if [ "$#" -eq 0 ]; then
    echo "The commands is not specified to the \"_n2038_command_must_be_installed\" function!" >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  while [ "$#" -gt 0 ]; do
    { __n2038_command="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

    if ! type "${__n2038_command}" > /dev/null 2>&1; then
      echo "Command \"${__n2038_command}\" is not installed!" >&2
      _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
    fi
  done

  _n2038_unset 0 && return "$?" || return "$?"
}

# Regenerates symlinks for the scripts in the shell environment.
#
# Usage: _n2038_regenerate_symlinks
_n2038_regenerate_symlinks() {
  if [ -z "${_N2038_SHELL_ENVIRONMENT_SYMLINKS}" ]; then
    echo "\"_N2038_SHELL_ENVIRONMENT_SYMLINKS\" is empty!" >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  echo "Regenerating symlinks for the scripts in the shell environment..." >&2

  # Clear existing symlinks
  rm -rf "${_N2038_SHELL_ENVIRONMENT_SYMLINKS}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  mkdir --parents "${_N2038_SHELL_ENVIRONMENT_SYMLINKS}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  __n2038_scripts="$(find "${_N2038_SHELL_ENVIRONMENT_PATH}/scripts" -type f -name '*n2038*.sh')" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Create new symlink for each script
  for __n2038_script in ${__n2038_scripts}; do
    __n2038_script_name="$(basename "${__n2038_script}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    sudo ln -s "${__n2038_script}" "${_N2038_SHELL_ENVIRONMENT_SYMLINKS}/${__n2038_script_name}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Creating symlink for \"${__n2038_script_name}\": success!" >&2
    fi
  done

  echo "Regenerating symlinks for the scripts in the shell environment: success!" >&2

  _n2038_unset 0 && return "$?" || return "$?"
}

# Activates the shell environment.
#
# Usage: n2038_my_shell_environment [--no-check] [--dev] [--force] [command=activate]
# Where:
# - "--no-check": Do not check requirements (they are checked by default);
# - "--dev": (when using "install" command): Install dev version of the scripts (otherwise stable version will be installed);
# - "--force": (when using "install" command): Remove old "my-shell-environment" if it exists (if not passed and old version exists, installation will be aborted);
# - "command":
#   - "install": Install the scripts in the system + Activate the shell environment;
#   - "update": Update the repository from remote + Activate the shell environment;
#   - "activate": Just activate the shell environment.
n2038_my_shell_environment() {
  # Is "my-shell-environment" initialized successfully
  _N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED=0

  # Because we want to start calculating execution time as early as possible - we duplicate needed checks here
  if which which > /dev/null 2>&1 && which date > /dev/null 2>&1; then
    # Start calculating execution time.
    # This variable must not be exported, because it is used only in current shell - not in subshells.
    _N2038_LAST_TIME="$(date +%s%N)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  # If need to check requirements
  __n2038_is_check_requested=1

  # (If installing) If need to install dev version (otherwise stable version will be installed)
  __n2038_is_install_dev=0

  # (If installing) Remove old "my-shell-environment" if it exists (if not passed and old version exists, installation will be aborted)
  __n2038_is_install_force=0

  for __n2038_argument in "$@"; do
    if [ "${__n2038_argument}" = "--no-check" ]; then
      __n2038_is_check_requested=0 && { shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; }
    fi
    if [ "${__n2038_argument}" = "--dev" ]; then
      __n2038_is_install_dev=1 && { shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; }
    fi
    if [ "${__n2038_argument}" = "--force" ]; then
      __n2038_is_install_force=1 && { shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; }
    fi
  done

  __N2038_COMMAND_INSTALL="install"
  __N2038_COMMAND_UPDATE="update"
  __N2038_COMMAND_ACTIVATE="activate"

  [ "$#" -gt 0 ] && { __n2038_command="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_command="${__N2038_COMMAND_ACTIVATE}"

  # ========================================
  # Preparations
  # ========================================
  # If debug mode is enabled (more logs will be shown)
  export N2038_IS_DEBUG="${N2038_IS_DEBUG:-"0"}"

  # Name for the scripts folder and name to be shown in logs
  export _N2038_SHELL_ENVIRONMENT_NAME="${_N2038_SHELL_ENVIRONMENT_NAME:-"my-shell-environment"}"
  if [ -z "${_N2038_SHELL_ENVIRONMENT_NAME}" ]; then
    echo "_N2038_SHELL_ENVIRONMENT_NAME cannot be empty!" >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  # Repository URL to install scripts from
  export _N2038_SHELL_ENVIRONMENT_REPOSITORY_URL="${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL:-"https://github.com/Nikolai2038/my-shell-environment"}"

  # Path to folder, where the directory with scripts will be located
  __n2038_libs_path="/usr/local/lib"

  # ----------------------------------------
  # Termux support
  # ----------------------------------------
  if [ -n "${TERMUX_VERSION}" ]; then
    # Termux does not have "/usr/local/lib" directory - so we use app storage instead
    __n2038_libs_path="${PREFIX}/lib"

    # Termux does not need "sudo" to write to the lib directory - we fake it
    sudo() { "$@"; }
  fi
  # ----------------------------------------

  # ----------------------------------------
  # Windows support
  # ----------------------------------------
  if [ -n "${MSYSTEM}" ]; then
    # TODO: In the future find a way to run scripts with admin rights
    # # Windows does not have "/usr/local/lib" directory - so we use "Program Files" directory instead
    # __n2038_libs_path="${PROGRAMFILES}"

    # Windows does not have "/usr/local/lib" directory - so we use user's directory instead
    __n2038_libs_path="${HOME}"

    # Windows does not have "sudo" - we fake it
    sudo() { "$@"; }

    # MINGW does not have "xxhsum" - we fake it
    xxhsum() {
      if [ "${1}" = "-H0" ]; then
        shift || return "$?"
      fi
      shasum "$@" || return "$?"
    }
  fi
  # ----------------------------------------

  if [ ! -d "${__n2038_libs_path}" ]; then
    echo "Libs path \"${__n2038_libs_path}\" not found - probably, \"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not implemented for your OS." >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi
  # Path to the directory with scripts
  export _N2038_SHELL_ENVIRONMENT_PATH="${__n2038_libs_path}/${_N2038_SHELL_ENVIRONMENT_NAME}"

  # Path to the directory with symlinks to the scripts
  export _N2038_SHELL_ENVIRONMENT_SYMLINKS="${_N2038_SHELL_ENVIRONMENT_PATH}/.symlinks"
  # ========================================

  # ========================================
  # Check requirements
  # ========================================
  if [ "${__n2038_is_check_requested}" = "1" ]; then
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Checking requirements..." >&2
    fi

    # We use subshell here because we don't want to unset parent function's variables inside child ones
    (_n2038_commands_must_be_installed which git grep sudo xxhsum date) || { _n2038_unset "$?" && return "$?" || return "$?"; }

    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Checking requirements: success!" >&2
    fi
  fi
  # ========================================

  if [ "${__n2038_command}" = "${__N2038_COMMAND_INSTALL}" ]; then
    # ========================================
    # Installing the repository
    # ========================================
    if [ -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
      if [ "${__n2038_is_install_force}" = "1" ]; then
        echo "Removing old repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2
        sudo rm --recursive --force "${_N2038_SHELL_ENVIRONMENT_PATH}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
        echo "Removing old repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\": success!" >&2
      else
        echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is already installed! Pass \"--force\" argument to remove old repository." >&2
        _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
      fi
    fi

    echo "Cloning repository \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" to \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2

    __n2038_branch_name="main"
    if [ "${__n2038_is_install_dev}" = "1" ]; then
      __n2038_branch_name="dev"
    fi
    sudo git clone --branch "${__n2038_branch_name}" "${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}.git" "${_N2038_SHELL_ENVIRONMENT_PATH}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    sudo chown --recursive "${USER}:${USER}" "${_N2038_SHELL_ENVIRONMENT_PATH}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

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
      if { ! [ -f "${__n2038_bashrc_path}" ]; } || { ! grep --quiet --extended-regexp "^source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh && n2038_my_shell_environment activate\$" "${__n2038_bashrc_path}"; }; then
        # shellcheck disable=SC2320
        echo "# \"${_N2038_SHELL_ENVIRONMENT_NAME}\" - see \"${_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL}\" for more details
source ${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh && n2038_my_shell_environment activate" >> "${__n2038_bashrc_path}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
        echo "Installing for Bash: success!" >&2
      else
        echo "Installing for Bash: already installed!" >&2
      fi
    fi
    # ----------------------------------------
    # ========================================

    _n2038_regenerate_symlinks || { _n2038_unset "$?" && return "$?" || return "$?"; }
  elif [ "${__n2038_command}" = "${__N2038_COMMAND_UPDATE}" ]; then
    if [ ! -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed to be updated! Pass \"install\" argument instead of \"update\" to install it." >&2
      _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
    fi

    # ========================================
    # Updating the repository
    # ========================================
    echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\"..." >&2
    git -C "${_N2038_SHELL_ENVIRONMENT_PATH}" pull || { _n2038_unset "$?" && return "$?" || return "$?"; }
    echo "Updating repository \"${_N2038_SHELL_ENVIRONMENT_PATH}\": success!" >&2
    # ========================================

    _n2038_regenerate_symlinks || { _n2038_unset "$?" && return "$?" || return "$?"; }
  elif [ "${__n2038_command}" = "${__N2038_COMMAND_ACTIVATE}" ]; then
    if [ ! -d "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
      echo "\"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not installed! Pass \"--install\" argument to install it." >&2
      _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
    fi
  else
    echo "Unknown command \"${__n2038_command}\"! Available commands: \"${__N2038_COMMAND_INSTALL}\", \"${__N2038_COMMAND_UPDATE}\", \"${__N2038_COMMAND_ACTIVATE}\"." >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  _N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED=1

  # ========================================
  # Activating the shell environment.
  # ========================================
  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\"..." >&2
  fi

  # We use external script "_n2038_activate_inner.sh" here to be able to apply new changes right now.
  # However, if this "n2038_my_shell_environment.sh" script is changed, we still need to reload the shell (in some cases).
  # shellcheck source=/usr/local/lib/my-shell-environment/scripts/_n2038_activate_inner.sh
  . "${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/_n2038_activate_inner.sh" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_activate_inner || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating \"${_N2038_SHELL_ENVIRONMENT_NAME}\": success!" >&2
  fi
  # ========================================

  _n2038_unset 0 && return "$?" || return "$?"
}

# If this file is being executed
if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "n2038_my_shell_environment.sh" ]; then
  echo "This file is meant to be sourced, not executed! Source this file and then execute function itself:
. ${0} && n2038_my_shell_environment" >&2
  exit 1
fi
