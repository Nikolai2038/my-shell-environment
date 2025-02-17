#!/bin/sh

: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_get_current_shell.sh\""
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" && _n2038_required_before_imports; } || { __n2038_return_code="$?" && [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" && _n2038_required_after_imports; } || _n2038_return "$?"

# Prints name of the current shell.
#
# Usage: _n2038_get_current_shell
_n2038_get_current_shell() {
  # If executing script
  if [ -f "${0}" ]; then
    # Check first line in the script
    __n2038_shell_path="$(head -n 1 "${0}" | sed -En 's/^#!.*[^a-z]+([a-z]+)$/\1/p')" || return "$?"
  else
    # We use "realpath" here to resolve symbolic links (for example, "sh" is a symlink to "bash" by default in Arch Linux)
    __n2038_shell_path="$(realpath "$(which "${0}")" | sed -En 's/^.*[^a-z]+([a-z]+)$/\1/p')" || return "$?"
  fi

  if [ -z "${__n2038_shell_path}" ]; then
    echo "Could not determine the current shell. Will use value from \$0." >&2
    __n2038_shell_path="${0}"
  fi

  echo "${__n2038_shell_path}"
  unset __n2038_shell_path
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ]; then
  _n2038_get_current_shell "${@}" || exit "$?"
fi
: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"
