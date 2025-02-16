#!/bin/sh

: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/_n2038_activate_inner.sh\""
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" && _n2038_required_before_imports; } || { __n2038_return_code="$?" && [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./shell/_n2038_ps1_function.sh" || _n2038_return "$?"
. "./shell/_n2038_ps2_function.sh" || _n2038_return "$?"

# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" && _n2038_required_after_imports; } || _n2038_return "$?"

_n2038_activate_inner() {
  # Set command prompt.
  # We must use function here to be able to get current shell via "$0" - this will not work if file is being executed.
  # Also, when we are entering "sh" from "bash" (even if "sh" is a symbolic link to "bash"), "sh" won't know about functions - because of that, we source them, if first execution fails.
  # shellcheck disable=SC2090
  export PS1="\$(__n2038_return_code=\"\$?\"; _n2038_ps1_function \"\${__n2038_return_code}\" 2> /dev/null || { . \"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps1_function.sh\" && _n2038_ps1_function \"\${__n2038_return_code}\"; } || exit \"\$?\")"
  export PS2="\$(n2038_ps2_function 2> /dev/null || { . \"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps2_function.sh\" && _n2038_ps2_function; } || exit \"\$?\")"

  # Make scripts available in shell by their names
  export PATH="${_N2038_SHELL_ENVIRONMENT_PATH}:${PATH}"
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ]; then
  _n2038_activate_inner "${@}" || exit "$?"
fi
: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"
