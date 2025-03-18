#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_shell_name.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

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
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
