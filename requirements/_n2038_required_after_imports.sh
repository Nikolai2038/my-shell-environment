#!/bin/sh

# Required steps after imports.
#
# Usage: _n2038_required_after_imports
_n2038_required_after_imports() {
  eval "cd \"\${_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  eval "unset _N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

# If this file is being executed
if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "_n2038_required_after_imports.sh" ]; then
  echo "This file is not meant to be executed directly - only sourced!" >&2
  exit 1
# If this file is being sourced
else
  _n2038_required_after_imports "${@}" || return "$?"
fi
