#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_shell_name.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

_N2038_SHELL_NAME_UNKNOWN="shell"

_N2038_CURRENT_SHELL_NAME_SH="sh"
_N2038_CURRENT_SHELL_NAME_BASH="bash"
_N2038_CURRENT_SHELL_NAME_DASH="dash"
_N2038_CURRENT_SHELL_NAME_KSH="ksh"
_N2038_CURRENT_SHELL_NAME_ZSH="zsh"
_N2038_CURRENT_SHELL_NAME_TCSH="tcsh"
_N2038_CURRENT_SHELL_NAME_FISH="fish"

# Prints name of the current shell.
# Also, defines "_N2038_CURRENT_SHELL_NAME" variable with the same value, which is useful to avoid recalculating the current shell name.
#
# Usage: _n2038_get_current_shell_name
_n2038_get_current_shell_name() {
  # If we already calculated current shell in current terminal session - just return it
  if [ -n "${_N2038_CURRENT_SHELL_NAME}" ]; then
    echo "${_N2038_CURRENT_SHELL_NAME}"
    return 0
  fi

  # If executing script - "${0}" will be the script path. (we assume all scripts end up with ".sh" extension)
  if echo "${0}" | grep --extended-regexp --quiet '\.sh$'; then
    if [ -n "${BASH}" ]; then
      _N2038_CURRENT_SHELL_NAME="${_N2038_CURRENT_SHELL_NAME_BASH}"
    elif [ -n "${ZSH_NAME}" ]; then
      _N2038_CURRENT_SHELL_NAME="${_N2038_CURRENT_SHELL_NAME_ZSH}"
    elif [ -n "${KSH_VERSION}" ]; then
      _N2038_CURRENT_SHELL_NAME="${_N2038_CURRENT_SHELL_NAME_KSH}"
    elif [ -n "${shell}" ]; then
      _N2038_CURRENT_SHELL_NAME="${_N2038_CURRENT_SHELL_NAME_TCSH}"
    else
      _N2038_CURRENT_SHELL_NAME="${_N2038_CURRENT_SHELL_NAME_SH}"
    fi
  # If sourcing script - "${0}" will be current shell path.
  else
    # NOTE: We use extra variable "__n2038_current_shell_name" to not leave main one with wrong value if script is interrupted.
    # We use "realpath" here to resolve symbolic links (for example, "sh" is a symlink to "bash" by default in Arch Linux).
    __n2038_current_shell_name="$(realpath "$(which "${0}")" | sed -En 's/^.*[^a-z]+([a-z]+)$/\1/p')" || return "$?"

    if [ -z "${__n2038_current_shell_name}" ]; then
      echo "Could not determine the current shell!" >&2
      __n2038_current_shell_name="${_N2038_SHELL_NAME_UNKNOWN}"
    fi

    _N2038_CURRENT_SHELL_NAME="${__n2038_current_shell_name}"
    unset __n2038_current_shell_name
  fi

  echo "${_N2038_CURRENT_SHELL_NAME}"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
