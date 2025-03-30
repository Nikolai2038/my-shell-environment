#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_os_version.sh"

# Required before imports
# shellcheck disable=SC1091
if [ "${_N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED}" != "1" ]; then
  # If we have not initialized the shell environment, but has it (for example, when starting "dash" from "bash"), then we will try to initialize it.
  if [ -n "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    . "${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"
  else
    echo "\"my-bash-environment\" is not initialized. Please, initialize it first." >&2 && return 1 2> /dev/null || exit 1
  fi
fi
_n2038_required_before_imports || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || _n2038_return "${__n2038_return_code}" || return "$?"; }

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
. "../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_get_current_os_name.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

export _N2038_CURRENT_OS_VERSION=""

# Prints version of the current OS.
# It can be empty (for example, for Arch).
# Also, defines "_N2038_CURRENT_OS_VERSION" variable with the same value, which is useful to avoid recalculating the current OS name.
# Even if OS version can be sometimes updated in the current shell, it is not worth to recalculate it every command.
#
# Usage: _n2038_get_current_os_version
_n2038_get_current_os_version() {
  # If we already calculated OS version - just print it
  if [ -n "${_N2038_CURRENT_OS_VERSION}" ]; then
    echo "${_N2038_CURRENT_OS_VERSION}"
    return 0
  fi

  # There is no version for Arch, so we skip checking it every time.
  # NOTE: Here we assume that "${_N2038_CURRENT_OS_NAME}" was already initialized via calling "_n2038_get_current_os_name" function.
  if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_ARCH}" ]; then
    return 0
  fi

  # For Termux there is no "/etc/os-release" file, so we need to check it separately
  if [ -n "${TERMUX_VERSION}" ]; then
    _N2038_CURRENT_OS_VERSION="${TERMUX_VERSION}"
    echo "${_N2038_CURRENT_OS_VERSION}"
    return 0
  fi

  # For Windows there is no "/etc/os-release" file, so we need to check it separately
  if [ -n "${MSYSTEM}" ]; then
    _n2038_commands_must_be_installed powershell || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Convert to lowercase and replace spaces with dashes
    _N2038_CURRENT_OS_VERSION="$(powershell -command "(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName" | sed -E 's/[^a-zA-Z0-9]+/-/g' | tr '[:upper:]' '[:lower:]' | sed -E 's/^windows-//')" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    echo "${_N2038_CURRENT_OS_VERSION}"
    return 0
  fi

  if [ ! -f "/etc/os-release" ]; then
    _n2038_print_error "File \"${c_highlight}/etc/os-release${c_return}\" not found - probably, \"${c_highlight}_n2038_get_current_os_version${c_return}\" is not implemented for your OS." || { _n2038_unset "$?" && return "$?" || return "$?"; }
    return 0
  fi

  _N2038_CURRENT_OS_VERSION="$(sed -En 's/^VERSION_ID="?([^"]+)"?/\1/p' /etc/os-release)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  echo "${_N2038_CURRENT_OS_VERSION}"

  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
