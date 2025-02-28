#!/bin/sh

export _N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED=238

# Special function to get current script file hash
_n2038_get_text_hash() {
  echo "${*}" | sha256sum | cut -d ' ' -f 1 || return "$?"
  return 0
}

# Special function to return from script.
# If script is being executed - it will exit with the given code.
# If script is being sourced - it will return with the given code.
#
# Usage: _n2038_return [return_code]
_n2038_return() {
  [ "$#" -gt 0 ] && { __n2038_return_code="${1}" && shift || return "$?"; } || {
    echo "Return code is not provided to \"_n2038_return\"! Result code will become 1." >&2
    __n2038_return_code=1
  }

  if [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ]; then
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Ignoring return code..." >&2
    fi
    __n2038_return_code=0
  fi

  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"

  # If file is being executed
  if [ "$({ basename "$0" || true; } 2> /dev/null)" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ]; then
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Exiting ${__n2038_return_code}..." >&2
    fi

    exit "${__n2038_return_code}"
  # If file is being sourced
  else
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Returning ${__n2038_return_code}..." >&2
    fi

    return "${__n2038_return_code}"
  fi
}

_n2038_required_before_imports() {
  : "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
  eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/${__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT}\""
  unset __N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT

  # Full path to the script
  __n2038_script_file_path="$(eval "realpath \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || return "$?"

  # We check both script path and it's contents
  __n2038_script_file_hash="$(_n2038_get_text_hash "${__n2038_script_file_path}$(cat "${__n2038_script_file_path}")")" || return "$?"

  # ========================================
  # Check about file being sourced
  # ========================================

  __n2038_script_file_is_sourced_variable_name="_N2038_FILE_IS_SOURCED_${__n2038_script_file_hash}"
  unset __n2038_script_file_hash
  __n2038_current_file_is_sourced="$(eval "echo \"\${${__n2038_script_file_is_sourced_variable_name}}\"")" || exit "$?"

  # If file is already sourced - we won't source it.
  if [ -n "${__n2038_current_file_is_sourced}" ]; then
    unset __n2038_current_file_is_sourced

    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Skipping already sourced \"${__n2038_script_file_path}\"..." >&2
    fi

    unset __n2038_script_file_path __n2038_script_file_is_sourced_variable_name

    # NOTE: We use return here to not exit terminal, when sourcing script.
    # NOTE: Also, we use special code to track it later and then turn it down to just 0.
    return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}"
  else
    if [ "${N2038_IS_DEBUG_BASH}" = "1" ]; then
      echo "Sourcing \"${__n2038_script_file_path}\"..." >&2
    fi
  fi
  unset __n2038_current_file_is_sourced

  # NOTE: Do not use export here - because it will break executing scripts - declared functions will not be available in them
  eval "${__n2038_script_file_is_sourced_variable_name}=1" || exit "$?"
  unset __n2038_script_file_is_sourced_variable_name
  # ========================================

  # Save current working directory
  eval "_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"\${PWD}\"" || return "$?"

  # Change current directory to the script directory to be able to easily import other scripts
  cd "$(dirname "${__n2038_script_file_path}")" || return "$?"
  unset __n2038_script_file_path
}

# If this file is being executed
if [ "$({ basename "$0" || true; } 2> /dev/null)" = "_n2038_required_before_imports.sh" ]; then
  echo "This file is not meant to be executed directly - only sourced!" >&2
  exit 1
# If this file is being sourced
else
  _n2038_required_before_imports "${@}" || return "$?"
fi
