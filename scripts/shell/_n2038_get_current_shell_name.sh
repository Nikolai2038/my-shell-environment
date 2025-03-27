#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_shell_name.sh"

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
# ...

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

_N2038_CURRENT_SHELL_NAME_BASH="bash"
_N2038_CURRENT_SHELL_NAME_ZSH="zsh"
_N2038_CURRENT_SHELL_NAME_KSH="ksh"
_N2038_CURRENT_SHELL_NAME_TCSH="tcsh"
_N2038_CURRENT_SHELL_NAME_DASH="dash"
_N2038_CURRENT_SHELL_NAME_SH="sh"

# TODO: Implement.
_N2038_CURRENT_SHELL_NAME_FISH="fish"

# Prints name of the current shell.
#
# Usage: _n2038_get_current_shell_name
_n2038_get_current_shell_name() {
  if [ -n "${BASH}" ]; then
    echo "${_N2038_CURRENT_SHELL_NAME_BASH}"
  elif [ -n "${ZSH_NAME}" ]; then
    echo "${_N2038_CURRENT_SHELL_NAME_ZSH}"
  elif [ -n "${KSH_VERSION}" ]; then
    echo "${_N2038_CURRENT_SHELL_NAME_KSH}"
  elif [ -n "${shell}" ]; then
    echo "${_N2038_CURRENT_SHELL_NAME_TCSH}"
  else
    echo "${_N2038_CURRENT_SHELL_NAME_SH}"
  fi
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
