#!/bin/sh

export _N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED=238
export _N2038_TRUE='_N2038_TRUE'
export _N2038_FALSE='_N2038_FALSE'

# (HAS TWO DECLARATIONS)
export _N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE=239

# (HAS TWO DECLARATIONS)
export _N2038_RETURN_CODE_NOT_PASSED_TO_UNSET=240

# (HAS TWO DECLARATIONS)
# Unset local variables (starts with "__n2038") and local constants (starts with "__N2038") and then return passed return code.
#
# Usage:
# - instead of: some_function || return "$?"
#   use:        some_function || { _n2038_unset "$?" && return "$?" || return "$?"; }
# - instead of: return 0
#   use:        _n2038_unset 0 && return "$?" || return "$?"
# - instead of: return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
#   use:        _n2038_unset_init "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
_n2038_unset() {
  for __n2038_variable in $(set | sed -En 's/^(__[nN]2038_[a-zA-Z0-9_]+)=.*$/\1/p'); do
    unset "${__n2038_variable}"
  done
  unset __n2038_variable

  return "${1:-${_N2038_RETURN_CODE_NOT_PASSED_TO_UNSET}}"
}

# Special function to get current script file hash
_n2038_get_text_hash() {
  echo "${*}" | sha256sum | cut -d ' ' -f 1 || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_unset 0 && return "$?" || return "$?"
}

# Special function to return from script.
# If script is being executed - it will exit with the given code.
# If script is being sourced - it will return with the given code.
#
# Usage: _n2038_return [return_code]
_n2038_return() {
  [ "$#" -gt 0 ] && { __n2038_return_code="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || {
    echo "Return code is not provided to \"_n2038_return\"! Result code will become 1." >&2
    __n2038_return_code=1
  }

  if [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ]; then
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Ignoring return code from $(basename "$0")!" >&2
    fi
    __n2038_return_code=0
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  # If file is being executed
  if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ]; then
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Exiting from $(basename "$0") with code ${__n2038_return_code}!" >&2
    fi

    _n2038_unset "${__n2038_return_code}" && exit "$?" || exit "$?"
  # If file is being sourced
  else
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Returning from $(basename "$0") with code  ${__n2038_return_code}!" >&2
    fi

    _n2038_unset "${__n2038_return_code}" && return "$?" || return "$?"
  fi

  _n2038_unset 0 && return "$?" || return "$?"
}

_n2038_required_before_imports() {
  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
  eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}\""

  # Full path to the script
  __n2038_script_file_path="$(eval "realpath \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # We check both script path and it's contents
  __n2038_script_file_hash="$(_n2038_get_text_hash "${__n2038_script_file_path}$(cat "${__n2038_script_file_path}")")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # ========================================
  # Check about file being sourced
  # ========================================

  __n2038_script_file_is_sourced_variable_name="_N2038_FILE_IS_SOURCED_${__n2038_script_file_hash}"
  __n2038_current_file_is_sourced="$(eval "echo \"\${${__n2038_script_file_is_sourced_variable_name}}\"")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # If file is already sourced - we won't source it.
  if [ -n "${__n2038_current_file_is_sourced}" ]; then
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Skipping already sourced \"${__n2038_script_file_path}\"..." >&2
    fi

    : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"

    # NOTE: We use return here to not exit terminal, when sourcing script.
    # NOTE: Also, we use special code to track it later and then turn it down to just 0.
    return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}"
  else
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Sourcing \"${__n2038_script_file_path}\"..." >&2
    fi
  fi

  # NOTE: Do not use export here - because it will break executing scripts - declared functions will not be available in them
  eval "${__n2038_script_file_is_sourced_variable_name}=1" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  # ========================================

  # Save current working directory
  eval "_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"\${PWD}\"" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Change current directory to the script directory to be able to easily import other scripts
  cd "$(dirname "${__n2038_script_file_path}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  _n2038_unset 0 && return "$?" || return "$?"
}

# If this file is being executed
if [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "_n2038_required_before_imports.sh" ]; then
  echo "This file is not meant to be executed directly - only sourced!" >&2
  exit 1
# If this file is being sourced
else
  _n2038_required_before_imports "${@}" || return "$?"
fi
