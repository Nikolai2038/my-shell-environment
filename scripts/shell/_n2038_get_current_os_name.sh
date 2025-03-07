#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_os_name.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

_N2038_OS_NAME_UNKNOWN="os"
_N2038_OS_NAME_TERMUX="termux"

# Prints name of the current OS.
# Also, defines "_N2038_CURRENT_OS_NAME" variable with the same value, which is useful to avoid recalculating the current OS name.
#
# Usage: _n2038_get_current_os_name
_n2038_get_current_os_name() {
  # If we already calculated current shell in current terminal session - just return it
  if [ -n "${_N2038_CURRENT_OS_NAME}" ]; then
    echo "${_N2038_CURRENT_OS_NAME}"
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  # For Termux there is no "/etc/os-release" file, so we need to check it separately
  if [ -n "${TERMUX_VERSION}" ]; then
    _N2038_CURRENT_OS_NAME="${_N2038_OS_NAME_TERMUX}"
    echo "${_N2038_CURRENT_OS_NAME}"
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  if [ ! -f "/etc/os-release" ]; then
    _n2038_print_error "File \"${c_highlight}/etc/os-release${c_return}\" not found - probably, \"${c_highlight}_n2038_get_current_os_name${c_return}\" is not implemented for your OS." || { _n2038_unset "$?" && return "$?" || return "$?"; }
    echo "${_N2038_OS_NAME_UNKNOWN}"
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  # NOTE: We use extra variable "__n2038_current_os_name" to not leave main one with wrong value if sed returns error.
  __n2038_current_os_name="$(sed -n 's/^ID=//p' /etc/os-release)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ -z "${__n2038_current_os_name}" ]; then
    _n2038_print_error "Could not determine the current OS!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    echo "${_N2038_OS_NAME_UNKNOWN}"
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  # Save value to avoid recalculations
  _N2038_CURRENT_OS_NAME="${__n2038_current_os_name}"

  echo "${_N2038_CURRENT_OS_NAME}"
  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
