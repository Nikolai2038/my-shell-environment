#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_echo.sh"

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

# Imports
. "../shell/_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

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
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
