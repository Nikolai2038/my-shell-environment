#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_shell.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Prints name of the current shell.
# Also, defines "_N2038_SHELL_PATH" variable with the same value, which is useful to avoid recalculating the current shell.
#
# Usage: _n2038_get_current_shell
_n2038_get_current_shell() {
  # If we already calculated current shell in current terminal session - just return it
  if [ -n "${_N2038_SHELL_PATH}" ]; then
    echo "${_N2038_SHELL_PATH}"
    return 0
  fi

  # Notes:
  # - If executing script - "${0}" will be the script path.
  # - If sourcing script - "${0}" will be current shell path.
  # - We use extra variable "__n2038_shell_path" to not leave main one with wrong value if script is interrupted.

  # If executing script (we assume all scripts end up with ".sh" extension)
  if echo "${0}" | grep --extended-regexp --quiet '\.sh$'; then
    # Get shell name from shebang
    __n2038_shell_path="$(head -n 1 "${0}" | sed -En 's/^#!.*[^a-z]+([a-z]+)$/\1/p')" || return "$?"

    if [ -z "${__n2038_shell_path}" ]; then
      echo "Could not determine the current shell from shebang in file \"${0}\". Will use value from \"\${0}\"." >&2
      __n2038_shell_path="${0}"
    fi
  else
    # We use "realpath" here to resolve symbolic links (for example, "sh" is a symlink to "bash" by default in Arch Linux)
    __n2038_shell_path="$(realpath "$(which "${0}")" | sed -En 's/^.*[^a-z]+([a-z]+)$/\1/p')" || return "$?"

    if [ -z "${__n2038_shell_path}" ]; then
      echo "Could not determine the current shell. Will use value from \"\${0}\"." >&2
      __n2038_shell_path="${0}"
    fi
  fi

  _N2038_SHELL_PATH="${__n2038_shell_path}"
  unset __n2038_shell_path

  echo "${_N2038_SHELL_PATH}"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_function.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
