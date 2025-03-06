#!/bin/sh

# Required steps after function declaration.
# Checks if this file is being executed or sourced.
# If this file is being executed - it will execute the function itself.
# If this file is being sourced - it will do nothing.
#
# Usage: _n2038_required_after_function
_n2038_required_after_function() {
  __n2038_function_name="$(eval "sed -En 's/^(function )?([a-z0-9_]+)[[:space:]]*\\(\\)[[:space:]]*\{[[:space:]]*\$/\\2/p' \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || return "$?"
  if [ -n "${__n2038_function_name}" ]; then
    # If this file is being executed - we execute function itself
    if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ]; then
      "${__n2038_function_name}" "${@}" || exit "$?"
    fi
  fi

  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"
}

# If this file is being executed
if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "_n2038_required_after_function.sh" ]; then
  echo "This file is not meant to be executed directly - only sourced!" >&2
  exit 1
# If this file is being sourced
else
  _n2038_required_after_function "${@}" || return "$?"
fi
