#!/bin/sh

_n2038_required_after_imports() {
  eval "cd \"\${_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || return "$?"
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "_n2038_required_after_imports.sh" ]; then
  _n2038_required_after_imports "${@}" || exit "$?"
fi
