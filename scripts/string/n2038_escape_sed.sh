#!/bin/sh

: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/string/n2038_escape_sed.sh\""
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" && _n2038_required_before_imports; } || { __n2038_return_code="$?" && [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" && _n2038_required_after_imports; } || _n2038_return "$?"

n2038_escape_sed() {
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || return "$?"; }
  [ "$#" -gt 0 ] && { __n2038_arg="${1}" && shift || return "$?"; }

  # "-E" can be as first argument or as second, so we switch them, if necessary
  if [ "${__n2038_text}" = "-E" ]; then
    __n2038_text="${__n2038_arg}"
    __n2038_arg="-E"
  fi

  if [ "${__n2038_arg}" = "-E" ]; then
    # For "sed -E"
    echo "${__n2038_text}" | sed -e 's/[]\/#$&*.^;|{}()[]/\\&/g' || return "$?"
  else
    # For "sed"
    echo "${__n2038_text}" | sed -e 's/[]\/#$&*.^;[]/\\&/g' || return "$?"
  fi

  unset __n2038_text __n2038_arg
}

# If this file is being executed - we execute function itself
if [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ]; then
  n2038_escape_sed "${@}" || exit "$?"
fi
: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"
