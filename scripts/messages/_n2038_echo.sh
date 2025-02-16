#!/bin/sh

: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/messages/_n2038_echo.sh\""
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" && _n2038_required_before_imports; } || { __n2038_return_code="$?" && [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../shell/_n2038_is_shell_bash_compatible.sh" || _n2038_return "$?"

# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" && _n2038_required_after_imports; } || _n2038_return "$?"

_n2038_echo() {
  __n2038_text="${1}" && { shift || true; }

  if [ "${__n2038_text}" = "-e" ] || [ "${__n2038_text}" = "-n" ] || [ "${__n2038_text}" = "-en" ] || [ "${__n2038_text}" = "-ne" ]; then
    __n2038_args="${__n2038_text}"
    __n2038_text="${1}" && { shift || true; }
  fi

  if _n2038_is_shell_bash_compatible; then
    # shellcheck disable=SC2320
    echo "${__n2038_args}" "${__n2038_text}" || return "$?"
  else
    # "echo" in "sh" does not accept any arguments
    # shellcheck disable=SC2320
    echo "${__n2038_text}" || return "$?"
  fi
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ]; then
  _n2038_echo "${@}" || exit "$?"
fi
: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"
