#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_echo.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../shell/_n2038_is_shell_bash_compatible.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Executes "echo", based on current shell, with the given arguments.
#
# Usage: _n2038_echo [-e] [-n] [text]
_n2038_echo() {
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || return "$?"; } || __n2038_text=""

  if [ "${__n2038_text}" = "-e" ] || [ "${__n2038_text}" = "-n" ] || [ "${__n2038_text}" = "-en" ] || [ "${__n2038_text}" = "-ne" ]; then
    __n2038_args="${__n2038_text}"
    [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || return "$?"; } || __n2038_text=""
  fi

  if _n2038_is_shell_bash_compatible; then
    # shellcheck disable=SC2320
    echo "${__n2038_args}" "${__n2038_text}" || return "$?"
  else
    # "echo" in "sh" does not accept any arguments
    # shellcheck disable=SC2320
    echo "${__n2038_text}" || return "$?"
  fi

  unset __n2038_text
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
