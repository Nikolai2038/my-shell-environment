#!/bin/sh

_n2038_required_after_function() {
  __n2038_function_name="$(eval "sed -En 's/^(function )?([a-z0-9_]+)[[:space:]]*\\(\\)[[:space:]]*\{[[:space:]]*\$/\\2/p' \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || return "$?"
  if [ -n "${__n2038_function_name}" ]; then
    # If this file is being executed - we execute function itself
    if [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ]; then
      "${__n2038_function_name}" "${@}" || exit "$?"
    fi
  fi
  unset __n2038_function_name

  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"
}

# If this file is being executed
if [ "$(basename "$0")" = "_n2038_required_after_function.sh" ]; then
  echo "This file is not meant to be executed directly - only sourced!" >&2
  exit 1
# If this file is being sourced
else
  _n2038_required_after_function "${@}" || return "$?"
fi
