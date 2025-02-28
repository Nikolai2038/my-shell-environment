#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_os_name.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

_N2038_OS_NAME_UNKNOWN="os"

# Prints name of the current OS.
# Also, defines "_N2038_CURRENT_OS_NAME" variable with the same value, which is useful to avoid recalculating the current OS name.
#
# Usage: _n2038_get_current_os_name
_n2038_get_current_os_name() {
  # If we already calculated current shell in current terminal session - just return it
  if [ -n "${_N2038_CURRENT_OS_NAME}" ]; then
    echo "${_N2038_CURRENT_OS_NAME}"
    return 0
  fi

  # For Termux there is no "/etc/os-release" file, so we need to check it separately
  if [ -n "${TERMUX_VERSION}" ]; then
    _N2038_CURRENT_OS_NAME="termux"
    echo "${_N2038_CURRENT_OS_NAME}"
    return 0
  fi

  if [ ! -f "/etc/os-release" ]; then
    echo "File \"/etc/os-release\" not found - probably, \"_n2038_get_current_os_name\" is not implemented for your OS." >&2
    echo "${_N2038_OS_NAME_UNKNOWN}"
    return 0
  fi

  # NOTE: We use extra variable "__n2038_current_os_name" to not leave main one with wrong value if sed returns error.
  __n2038_current_os_name="$(sed -n 's/^ID=//p' /etc/os-release)" || return "$?"

  if [ -z "${__n2038_current_os_name}" ]; then
    echo "Could not determine the current OS!" >&2
    echo "${_N2038_OS_NAME_UNKNOWN}"
    return 0
  fi

  # Save value to avoid recalculations
  _N2038_CURRENT_OS_NAME="${__n2038_current_os_name}"

  unset __n2038_current_os_name
  echo "${_N2038_CURRENT_OS_NAME}"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
