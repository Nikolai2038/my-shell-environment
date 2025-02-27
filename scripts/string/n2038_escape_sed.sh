#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/string/n2038_escape_sed.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Escapes the specified text for use in the sed command.
# If you will pass the result of this command to "sed" or "grep" - please, add "-E" if you will also add it to them.
# This is because, the escaping depends on condition if extended regular expressions will be used.
#
# Usage: _n2038_escape_sed [-E] [text]
n2038_escape_sed() {
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || return "$?"; } || __n2038_text=""
  [ "$#" -gt 0 ] && { __n2038_arg="${1}" && shift || return "$?"; } || __n2038_arg=""

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

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
