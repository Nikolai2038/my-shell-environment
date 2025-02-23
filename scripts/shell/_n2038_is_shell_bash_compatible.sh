#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_is_shell_bash_compatible.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./_n2038_get_current_shell.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Checks if this shell is bash-compatible.
#
# Usage: _n2038_is_shell_bash_compatible
#
# Returns:
# - 0: If current shell is bash-compatible
# - 1: Otherwise
_n2038_is_shell_bash_compatible() {
  if [ "$(_n2038_get_current_shell)" = "bash" ]; then
    return 0
  else
    return 1
  fi
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_function.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
