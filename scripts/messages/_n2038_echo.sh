#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_echo.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../shell/_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

# Executes "echo", based on current shell, with the given arguments.
#
# Usage: _n2038_echo [-e] [-n] [text]
_n2038_echo() {
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_text=""

  if [ "${__n2038_text}" = "-e" ] || [ "${__n2038_text}" = "-n" ] || [ "${__n2038_text}" = "-en" ] || [ "${__n2038_text}" = "-ne" ]; then
    __n2038_args="${__n2038_text}"
    [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_text=""
  fi

  if [ "$(_n2038_get_current_shell_name)" = "${_N2038_CURRENT_SHELL_NAME_BASH}" ]; then
    # shellcheck disable=SC2320
    echo "${__n2038_args}" "${__n2038_text}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    # "echo" in "sh" does not accept any arguments
    # shellcheck disable=SC2320
    echo "${__n2038_text}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
