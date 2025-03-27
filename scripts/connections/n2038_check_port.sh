#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/connections/n2038_check_port.sh"

# Required before imports
# shellcheck disable=SC1091
if [ "${_N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED}" != "1" ]; then
  # If we have not initialized the shell environment, but has it (for example, when starting "dash" from "bash"), then we will try to initialize it.
  if [ -n "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    . "${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"
  else
    echo "\"my-bash-environment\" is not initialized. Please, initialize it first." >&2 && return 1 2> /dev/null || exit 1
  fi
fi
_n2038_required_before_imports || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || _n2038_return "${__n2038_return_code}" || return "$?"; }

# Imports
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Check if the port is open on the host.
#
# Usage: n2038_check_port <host>:<port> [<proxy_host>:<proxy_port>]
# Where:
# - `host`: Host to connect;
# - `port`: Port to connect;
# - `proxy_host`: Host of the proxy to use before checking connection;
# - `proxy_port`: Port of the proxy to use before checking connection.
n2038_check_port() {
  if [ "$#" -lt 1 ]; then
    _n2038_print_error "Usage: ${c_highlight}n2038_check_port <host:port> [proxy_host:proxy_port]${c_return}" || return "$?"
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi
  { __n2038_host_and_port="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ "$#" -eq 1 ]; then
    _n2038_commands_must_be_installed sudo proxytunnel || { _n2038_unset "$?" && return "$?" || return "$?"; }

    { __n2038_proxy_host_and_port="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

    __n2038_host="127.0.0.1"
    # TODO: Find free port instead of hardcoding
    __n2038_port="19999"

    # Update sudo rights
    sudo echo -n '' > /dev/null || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Create proxytunnel in background
    timeout 2 sudo proxytunnel -p "${__n2038_proxy_host_and_port}" -d "${__n2038_host_and_port}" -a "${__n2038_host}:${__n2038_port}" &

    # Wait until proxytunnel is ready
    sleep 1
  else
    __n2038_host="${__n2038_host_and_port%:*}"
    __n2038_port="${__n2038_host_and_port#*:}"
  fi

  timeout 1 sh -c "</dev/tcp/${__n2038_host}/${__n2038_port}" || { _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"; }

  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
