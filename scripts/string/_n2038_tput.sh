#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/string/_n2038_tput.sh"

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
# ...

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# "tput" but without errors if terminal does not support it.
# I use this function instead of "tput" because "tput" will just return "1" if terminal does not support some capability - without any error messages.
#
# Usage: _n2038_tput <argument> [extra arguments...]
_n2038_tput() {
  if [ "$#" -lt 1 ]; then
    echo "No arguments passed to \"_n2038_tput\"!" >&2
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi

  { __n2038_argument="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # "tput" will not work with undefined "TERM" variable (for example, "ssh-copy-id" executes without that) - so we check it first.
  if [ -n "${TERM}" ]; then
    if infocmp | grep -qE "\s${__n2038_argument}="; then
      tput "${__n2038_argument}" "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    elif [ "${N2038_IS_DEBUG}" = "1" ]; then
      echo "\"tput\" ignored - \"infocmp\" has no entry for \"${__n2038_argument}\"!" >&2
    fi
  elif [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "\"tput\" ignored - \"TERM\" is empty!" >&2
  fi

  unset __n2038_argument
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
