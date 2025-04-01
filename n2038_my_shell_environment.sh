#!/bin/sh

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
if [ -n "${_N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED}" ]; then
  return
fi

export _N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED=238
export _N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE=239
export _N2038_RETURN_CODE_NOT_PASSED_TO_UNSET=240

# Value for this variable must not be in the variable name itself - otherwise it can unset itself in "_n2038_unset_imports" (right now it won't but just to be sure)
export _N2038_FILE_IS_SOURCED_PREFIX="_N2038_FILE_IS_SOURCED_WITH_HASH_"

export _N2038_TRUE='true'
export _N2038_FALSE='false'

export _N2038_CURRENT_OS_TYPE=""
export _N2038_OS_TYPE_WINDOWS="windows"
export _N2038_OS_TYPE_LINUX="linux"
export _N2038_OS_TYPE_MACOS="macos"

export _N2038_CURRENT_KERNEL_ARCHITECTURE=""
export _N2038_KERNEL_ARCHITECTURE_X86_64="x86_64"
export _N2038_KERNEL_ARCHITECTURE_ARM64="aarch64"

export _N2038_CURRENT_OS_NAME=""
export _N2038_OS_NAME_UNKNOWN="os"
export _N2038_OS_NAME_WINDOWS="windows"
export _N2038_OS_NAME_TERMUX="termux"
export _N2038_OS_NAME_ARCH="arch"
export _N2038_OS_NAME_FEDORA="fedora"
export _N2038_OS_NAME_DEBIAN="debian"
export _N2038_OS_NAME_MACOS="macos"

export _N2038_CURRENT_OS_VERSION=""

export N2038_AUTO_INSTALL_PACKAGES
if [ -z "${N2038_AUTO_INSTALL_PACKAGES}" ]; then
  N2038_AUTO_INSTALL_PACKAGES=1
fi

# Unset local variables (starts with "__n2038") and local constants (starts with "__N2038") and then return passed return code.
#
# Usage:
# - instead of: some_function || return "$?"
#   use:        some_function || { _n2038_unset "$?" && return "$?" || return "$?"; }
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
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_unset 2> /dev/null || true

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
    unset __n2038_return_code
    return 0
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

  unset __n2038_return_code
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_return 2> /dev/null || true

_n2038_unset_imports() {
  # "sha256sum" will generate only "[a-z0-9]" for hash, so we check only for them
  # shellcheck disable=SC2046
  unset $(set | sed -En "s/^(${_N2038_FILE_IS_SOURCED_PREFIX}[a-z0-9]+)=.*\$/\\1/p") || return "$?"
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_unset_imports 2> /dev/null || true

_n2038_required_before_imports() {
  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
  eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}\""

  # Full path to the script
  __n2038_script_file_path="$(eval "echo \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ ! -f "${__n2038_script_file_path}" ]; then
    echo "File \"${__n2038_script_file_path}\" not found! Check if \"__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT\" was set correctly." >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  # ========================================
  # Check about file being sourced
  # ========================================
  # "_n2038_activate_inner" is executing from "n2038_my_shell_environment" where we source it every time - so we skip it here
  if [ "${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}" != "scripts/_n2038_activate_inner.sh" ] \
    && [ "${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}" != "scripts/_n2038_activate_inner_bash.sh" ]; then
    # We check both script path and it's contents
    __n2038_script_file_hash="$(sha256sum "${__n2038_script_file_path}" | cut -d ' ' -f 1)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

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
  eval "_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${PWD}\"" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Change current directory to the script directory to be able to easily import other scripts
  cd "$(dirname "${__n2038_script_file_path}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  unset __n2038_script_file_path __n2038_script_file_hash __n2038_script_file_is_sourced_variable_name __n2038_current_file_is_sourced
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_required_before_imports 2> /dev/null || true

# Required steps after imports.
#
# Usage: _n2038_required_after_imports
_n2038_required_after_imports() {
  eval "cd \"\${_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  eval "unset _N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_required_after_imports 2> /dev/null || true

# Required steps after function declaration.
# Checks if this file is being executed or sourced.
# If this file is being executed - it will execute the function itself.
# If this file is being sourced - it will do nothing.
#
# Usage: _n2038_required_after_function
_n2038_required_after_function() {
  # If this file is being executed - we execute function itself
  if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ]; then
    # Full path to the script
    __n2038_script_file_path="$(eval "echo \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    if [ -f "${__n2038_script_file_path}" ]; then
      __n2038_function_name="$(eval "sed -En 's/^(function )?([a-z0-9_]+)[[:space:]]*\\(\\)[[:space:]]*\{[[:space:]]*\$/\\2/p' \"${__n2038_script_file_path}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
      # Not all files will have function with the same name - for example, constants and aliases.
      # So we don't consider this as error here.
      if [ -n "${__n2038_function_name}" ]; then
        "${__n2038_function_name}" "$@" || exit "$?"
      fi
    fi

    : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    unset __n2038_script_file_path __n2038_function_name
    return 0
  fi

  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_required_after_function 2> /dev/null || true

# Checks if the specified commands are installed.
# Returns 0 if all the commands are installed, otherwise returns other values.
#
# Usage: _n2038_commands_must_be_installed <command...>
_n2038_commands_must_be_installed() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: _n2038_commands_must_be_installed <command...>" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  while [ "$#" -gt 0 ]; do
    { __n2038_command="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

    if ! type "${__n2038_command}" > /dev/null 2>&1; then
      echo "Command \"${__n2038_command}\" is not installed!" >&2

      # ========================================
      # Define package name for the command.
      # This can differ from OS to OS - this can be broken.
      # Right now I am testing only on Arch.
      # ========================================
      __n2038_is_aur=0
      __n2038_packages_names="${__n2038_command}"
      if [ "${__n2038_command}" = "wl-copy" ]; then
        __n2038_packages_names="wl-clipboard"
      elif [ "${__n2038_command}" = "man" ]; then
        __n2038_packages_names="man-db man-pages"
      elif [ "${__n2038_command}" = "genisoimage" ]; then
        __n2038_packages_names="cdrtools"
      elif [ "${__n2038_command}" = "plasma-activities-cli6" ]; then
        __n2038_packages_names="plasma-activities"
      elif [ "${__n2038_command}" = "netstat" ]; then
        __n2038_packages_names="net-tools"
      elif [ "${__n2038_command}" = "_init_completion" ]; then
        __n2038_packages_names="bash-completion"
      elif [ "${__n2038_command}" = "remote-viewer" ]; then
        __n2038_packages_names="virt-viewer"
      elif [ "${__n2038_command}" = "vncviewer" ]; then
        __n2038_packages_names="tigervnc"
      elif [ "${__n2038_command}" = "telnet" ]; then
        __n2038_packages_names="inetutils"
      elif [ "${__n2038_command}" = "debtap" ]; then
        __n2038_packages_names="debtap"
        __n2038_is_aur=1
      elif [ "${__n2038_command}" = "tput" ]; then
        if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ]; then
          __n2038_packages_names="ncurses-utils"
        elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_ARCH}" ]; then
          __n2038_packages_names="ncurses"
        elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_FEDORA}" ]; then
          __n2038_packages_names="ncurses"
        elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_DEBIAN}" ]; then
          __n2038_packages_names="ncurses-bin"
        else
          echo "Installing command \"${__n2038_command}\" is not implemented for \"${_N2038_CURRENT_OS_NAME}\"!" >&2
        fi
      elif [ "${__n2038_command}" = "pstree" ]; then
        __n2038_packages_names="psmisc"
      fi
      # ========================================

      # ========================================
      # Define installation steps
      # ========================================
      # Add hint for installing "jq" in Windows
      if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_WINDOWS}" ]; then
        if [ "${__n2038_command}" = "jq" ]; then
          __n2038_command_to_install="sudo curl -L -o /usr/bin/jq.exe https://github.com/jqlang/jq/releases/latest/download/jq-win64.exe"
        else
          echo "Installing command \"${__n2038_command}\" is not implemented for \"${_N2038_OS_NAME_WINDOWS}\"!" >&2
          _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
        fi
      elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ]; then
        __n2038_command_to_install="pkg update && pkg install -y ${__n2038_packages_names}"
      elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_ARCH}" ]; then
        if [ "${__n2038_is_aur}" = "1" ]; then
          __n2038_command_to_install="yay --sync --refresh --needed --noconfirm ${__n2038_packages_names}"
        else
          __n2038_command_to_install="sudo pacman --sync --refresh --needed --noconfirm ${__n2038_packages_names}"
        fi
      elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_FEDORA}" ]; then
        __n2038_command_to_install="sudo dnf install -y ${__n2038_packages_names}"
      elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_DEBIAN}" ]; then
        __n2038_command_to_install="sudo apt-get update && sudo apt-get install -y ${__n2038_packages_names}"
      elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_MACOS}" ]; then
        echo "Installing commands \"${__n2038_command}\" are not implemented for \"${_N2038_OS_NAME_MACOS}\"!" >&2
        _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
      fi
      # ========================================

      # ========================================
      # Define post installation steps
      # ========================================
      if [ "${__n2038_command}" = "debtap" ]; then
        __n2038_command_to_install="${__n2038_command_to_install} && sudo debtap -u"
      fi
      # ========================================

      # ========================================
      # Installation itself, or just print hint
      # ========================================
      if [ "${N2038_AUTO_INSTALL_PACKAGES}" = "1" ]; then
        echo "Installing \"${__n2038_command}\" for ${_N2038_CURRENT_OS_NAME} via command \"${__n2038_command_to_install}\"..." >&2
        eval "${__n2038_command_to_install}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
        echo "Installing \"${__n2038_command}\" for ${_N2038_CURRENT_OS_NAME} via command \"${__n2038_command_to_install}\": success!" >&2
        return 0
      else
        echo "You can install \"${__n2038_command}\" for ${_N2038_CURRENT_OS_NAME} via command: \"${__n2038_command_to_install}\"" >&2
        _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
      fi
      # ========================================
    fi
  done

  unset __n2038_command
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_commands_must_be_installed 2> /dev/null || true

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

  unset __n2038_scripts __n2038_script_name
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_regenerate_symlinks 2> /dev/null || true

# Inits the "_N2038_CURRENT_OS_TYPE" variable with type of the current OS.
#
# Usage: _n2038_init_current_os_type
_n2038_init_current_os_type() {
  _n2038_commands_must_be_installed uname || { _n2038_unset "$?" && return "$?" || return "$?"; }

  __n2038_current_kernel_name="$(uname -s)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ -n "${MSYSTEM}" ]; then
    _N2038_CURRENT_OS_TYPE="${_N2038_OS_TYPE_WINDOWS}"
  elif [ "${__n2038_current_kernel_name}" = "Linux" ]; then
    _N2038_CURRENT_OS_TYPE="${_N2038_OS_TYPE_LINUX}"
  elif [ "${__n2038_current_kernel_name}" = "Darwin" ]; then
    _N2038_CURRENT_OS_TYPE="${_N2038_OS_TYPE_MACOS}"
  else
    echo "Could not determine the current OS type!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  unset __n2038_current_kernel_name
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_init_current_os_type 2> /dev/null || true

# Inits the "_N2038_CURRENT_KERNEL_ARCHITECTURE" variable with type of the current OS.
#
# Usage: _n2038_init_current_kernel_architecture
_n2038_init_current_kernel_architecture() {
  _n2038_commands_must_be_installed uname || { _n2038_unset "$?" && return "$?" || return "$?"; }

  __n2038_current_kernel_name="$(uname -m)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ "${__n2038_current_kernel_name}" = "x86_64" ]; then
    _N2038_CURRENT_KERNEL_ARCHITECTURE="${_N2038_KERNEL_ARCHITECTURE_X86_64}"
  elif [ "${__n2038_current_kernel_name}" = "aarch64" ]; then
    _N2038_CURRENT_KERNEL_ARCHITECTURE="${_N2038_KERNEL_ARCHITECTURE_ARM64}"
  else
    echo "Could not determine the current kernel architecture!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  unset __n2038_current_kernel_name
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_init_current_kernel_architecture 2> /dev/null || true

# Inits the "_N2038_CURRENT_OS_NAME" variable with name of the current OS.
#
# Usage: _n2038_init_current_os_name
_n2038_init_current_os_name() {
  if [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_WINDOWS}" ]; then
    _N2038_CURRENT_OS_NAME="${_N2038_OS_NAME_WINDOWS}"
  elif [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_LINUX}" ]; then
    # For Termux there is no "/etc/os-release" file, so we need to check it separately
    if [ -n "${TERMUX_VERSION}" ]; then
      _N2038_CURRENT_OS_NAME="${_N2038_OS_NAME_TERMUX}"
      return 0
    fi

    if [ ! -f "/etc/os-release" ]; then
      echo "File \"/etc/os-release\" not found - probably, \"_n2038_init_current_os_name\" is not implemented for your OS." >&2
      echo "${_N2038_OS_NAME_UNKNOWN}"
      return 0
    fi

    _N2038_CURRENT_OS_NAME="$(sed -n 's/^ID=//p' /etc/os-release)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    if [ -z "${_N2038_CURRENT_OS_NAME}" ]; then
      echo "Could not determine the current OS name!" >&2
      return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
    fi
  elif [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_MACOS}" ]; then
    _N2038_CURRENT_OS_NAME="${_N2038_OS_NAME_MACOS}"
  else
    echo "Unknown current OS type in \"_n2038_init_current_os_name\"!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_init_current_os_name 2> /dev/null || true

# Inits the "_N2038_CURRENT_OS_VERSION" variable with version of the current OS.
# It can be empty (for example, for Arch).
# Even if OS version can be sometimes updated in the current shell, it is not worth to recalculate it every command.
#
# Usage: _n2038_init_current_os_version
_n2038_init_current_os_version() {
  if [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_WINDOWS}" ]; then
    # For Windows there is no "/etc/os-release" file, so we need to check it separately
    _n2038_commands_must_be_installed powershell || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Convert to lowercase and replace spaces with dashes
    _N2038_CURRENT_OS_VERSION="$(powershell -command "(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName" | sed -E 's/[^a-zA-Z0-9]+/-/g' | tr '[:upper:]' '[:lower:]' | sed -E 's/^windows-//')" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    return 0
  elif [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_LINUX}" ]; then
    if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_ARCH}" ]; then
      # There is no version for Arch
      _N2038_CURRENT_OS_VERSION=""
      return 0
    elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ]; then
      # For Termux there is no "/etc/os-release" file
      _N2038_CURRENT_OS_VERSION="${TERMUX_VERSION}"
      return 0
    else
      if [ ! -f "/etc/os-release" ]; then
        echo "File \"/etc/os-release\" not found - probably, \"_n2038_init_current_os_version\" is not implemented for your OS." >&2
        return 0
      fi

      _N2038_CURRENT_OS_VERSION="$(sed -En 's/^VERSION_ID="?([^"]+)"?/\1/p' /etc/os-release)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    fi
  elif [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_MACOS}" ]; then
    echo "Getting OS version is not implemented in \"_n2038_init_current_os_version\" for \"${_N2038_CURRENT_OS_NAME}\"!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  else
    echo "Unknown current OS type in \"_n2038_init_current_os_version\"!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f _n2038_init_current_os_version 2> /dev/null || true

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
  export _N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED=0

  _n2038_init_current_os_type || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_init_current_kernel_architecture || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_init_current_os_name || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_init_current_os_version || { _n2038_unset "$?" && return "$?" || return "$?"; }

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
  if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ]; then
    # Termux does not have "/usr/local/lib" directory - so we use app storage instead
    __n2038_libs_path="${PREFIX}/lib"

    # Termux does not need "sudo" to write to the lib directory - we fake it
    sudo() { "$@"; }
    # Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
    # shellcheck disable=SC3045
    export -f sudo 2> /dev/null || true
  fi
  # ----------------------------------------

  # ----------------------------------------
  # Windows support
  # ----------------------------------------
  if [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_WINDOWS}" ]; then
    # TODO: In the future find a way to run scripts with admin rights
    # # Windows does not have "/usr/local/lib" directory - so we use "Program Files" directory instead
    # __n2038_libs_path="${PROGRAMFILES}"

    # Windows does not have "/usr/local/lib" directory - so we use user's directory instead
    __n2038_libs_path="${HOME}"

    # Windows does not have "sudo" - we fake it.
    # In "_n2038_activate_inner_bash.sh" we properly define "sudo" function to run new Bash process as administrator
    sudo() { "$@"; }
    # Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
    # shellcheck disable=SC3045
    export -f sudo 2> /dev/null || true
  fi
  # ----------------------------------------

  if [ ! -d "${__n2038_libs_path}" ]; then
    echo "Libs path \"${__n2038_libs_path}\" not found - probably, \"${_N2038_SHELL_ENVIRONMENT_NAME}\" is not implemented for your OS." >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi
  # Path to the directory with scripts
  export _N2038_SHELL_ENVIRONMENT_PATH="${__n2038_libs_path}/${_N2038_SHELL_ENVIRONMENT_NAME}"

  # Path to the directory with symlinks to this shell environment scripts
  export _N2038_SHELL_ENVIRONMENT_SYMLINKS="${_N2038_SHELL_ENVIRONMENT_PATH}/.symlinks"

  # Path to the directory with symlinks to installed programs via "my-shell-environment"
  export _N2038_SHELL_ENVIRONMENT_PROGRAMS="${_N2038_SHELL_ENVIRONMENT_PATH}/.programs"

  # Path to the directory with symlinks to installed programs via "my-shell-environment".
  # On Windows we use "Program Files" directory.
  export N2038_DOWNLOADS_PATH
  if [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_WINDOWS}" ]; then
    export N2038_PROGRAMS_PATH
    N2038_PROGRAMS_PATH="$(cygpath -u "${PROGRAMFILES}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    if [ ! -d "${N2038_PROGRAMS_PATH}" ]; then
      echo "Programs path \"${N2038_PROGRAMS_PATH}\" not found!" >&2
      _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
    fi

    if [ -z "${N2038_DOWNLOADS_PATH}" ]; then
      N2038_DOWNLOADS_PATH="$(powershell.exe -NoProfile -Command "(New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path")"
    fi
  elif [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_LINUX}" ]; then
    export N2038_PROGRAMS_PATH="/opt"
    if [ ! -d "${N2038_PROGRAMS_PATH}" ]; then
      sudo mkdir "${N2038_PROGRAMS_PATH}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    fi

    if [ -z "${N2038_DOWNLOADS_PATH}" ]; then
      N2038_DOWNLOADS_PATH="${HOME}/Downloads"
    fi
  else
    echo "Initializing N2038_PROGRAMS_PATH is not supported for \"${_N2038_CURRENT_OS_TYPE}\"!" >&2
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi
  # ========================================

  # ========================================
  # Check requirements
  # ========================================
  if [ "${__n2038_is_check_requested}" = "1" ]; then
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "Checking requirements..." >&2
    fi

    # We use subshell here because we don't want to unset parent function's variables inside child ones
    (_n2038_commands_must_be_installed which sudo sed grep git tput sha256sum date) || { _n2038_unset "$?" && return "$?" || return "$?"; }
    # Optional commands - we don't consider fails as errors here
    (_n2038_commands_must_be_installed pstree) 2> /dev/null || true

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

      __n2038_bash_profile_path="${HOME}/.bash_profile"
      if [ ! -f "${__n2038_bash_profile_path}" ]; then
        echo "Creating \"${__n2038_bash_profile_path}\"..." >&2
        # Fix "WARNING: Found ~/.bashrc but no ~/.bash_profile, ~/.bash_login or ~/.profile." in Windows
        cat << EOF | tee "${__n2038_bash_profile_path}" > /dev/null || { _n2038_unset "$?" && return "$?" || return "$?"; }
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc
EOF
        echo "Creating \"${__n2038_bash_profile_path}\": success!" >&2
      fi

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

  unset __n2038_is_check_requested __n2038_is_install_dev __n2038_is_install_force __n2038_command __n2038_branch_name __n2038_libs_path __n2038_bashrc_path
  return 0
}
# Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
# shellcheck disable=SC3045
export -f n2038_my_shell_environment 2> /dev/null || true

# If this file is being executed
if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "n2038_my_shell_environment.sh" ]; then
  echo "This file is meant to be sourced, not executed! Source this file and then execute function itself:
. ${0} && n2038_my_shell_environment" >&2
  exit 1
fi
