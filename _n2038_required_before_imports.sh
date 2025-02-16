#!/bin/sh

# Special function to get current script file hash
_n2038_get_text_hash() {
  echo "${*}" | sha256sum | cut -d ' ' -f 1 || return "$?"
  return 0
}

_n2038_return() {
  return_code="${1}" && { shift || true; }
  # If file is being executed
  if [ "$(basename "$0")" = "_n2038_required.sh" ]; then
    exit "${return_code}"
  # If file is being sourced
  else
    return "${return_code}"
  fi
}

_n2038_required_before_imports() {
  # Full path to the script
  __n2038_script_file_path="$(eval "realpath \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" || return "$?"

  # We check both script path and it's contents
  __n2038_script_file_hash="$(_n2038_get_text_hash "${__n2038_script_file_path}$(cat "${__n2038_script_file_path}")")" || return "$?"

  # Save current working directory
  eval "_N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"\${PWD}\"" || return "$?"

  # eval "echo _N2038_PWD_BEFORE_IMPORTS_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"\${PWD}\"" || return "$?"
  # echo "Current PWD: ${PWD}" >&2

  # Change current directory to the script directory to be able to easily import other scripts
  cd "$(dirname "${__n2038_script_file_path}")" || return "$?"

  # TODO: Check if already sourced
  # ...

  # echo "Went to new PWD: ${PWD}" >&2

  unset __n2038_script_file_path __n2038_script_file_hash
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "_n2038_required_before_imports.sh" ]; then
  _n2038_required_before_imports "${@}" || exit "$?"
fi
