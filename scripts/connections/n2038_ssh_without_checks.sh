#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/connections/n2038_ssh_without_checks.sh"

# Required before imports
if ! type _n2038_required_before_imports > /dev/null 2>&1; then
  # If we have not initialized the shell environment, but has it (for example, when starting "dash" from "bash"), then we will try to initialize it.
  if [ -n "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    # shellcheck disable=SC1091
    _N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED=0 . "${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"
  else
    echo "\"my-bash-environment\" is not initialized. Please, initialize it first." >&2 && return 1 2> /dev/null || exit 1
  fi
fi
_n2038_required_before_imports || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || _n2038_return "${__n2038_return_code}" || return "$?"; }

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
. "../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "./n2038_ssh_with_checks.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Connect to the specified address via SSH and do not check known hosts (useful for VM/dualboot testing).
#
# Usage: n2038_ssh_without_checks <address[:port]> [password] [arg...]
# Where:
# - "arg": Extra argument to the "ssh" command.
#
# Example: n2038_ssh_without_checks.sh root@archiso:22 some_password
n2038_ssh_without_checks() {
  if [ "$#" -lt 1 ]; then
    _n2038_print_error "Usage: ${c_highlight}n2038_ssh_without_checks <address[:port]> [password] [arg...]${c_return}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi
  { __n2038_address_with_port="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

  [ "$#" -gt 0 ] && { __n2038_password="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_password=""

  n2038_ssh_with_checks "${__n2038_address_with_port}" "${__n2038_password}" \
    -o "StrictHostKeyChecking=no" \
    -o "UserKnownHostsFile=/dev/null" \
    -o "LogLevel=quiet" \
    "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
