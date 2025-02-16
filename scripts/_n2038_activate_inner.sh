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
  # We must source script here to be able to get current shell via "$0" - this will not work if file is being executed.
  # shellcheck disable=SC2090
  export PS1="\$(_n2038_ps1_function \"\$?\" || return \"\$?\")"
  export PS2="\$(_n2038_ps2_function || return \"\$?\")"

  # Make scripts available in shell by their names
  export PATH="${_N2038_SHELL_ENVIRONMENT_PATH}:${PATH}"
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "_n2038_activate_inner.sh" ]; then
  _n2038_activate_inner "${@}" || exit "$?"
fi
