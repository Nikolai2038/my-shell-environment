#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_docker_compose.sh"

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

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
. "../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# ========================================
# Main
# ========================================
unalias dc > /dev/null 2>&1 || true
# Alias for "docker-compose"
#
# Usage: dc [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose" command.
dc() {
  _n2038_commands_must_be_installed docker-compose || { _n2038_unset "$?" && return "$?" || return "$?"; }
  docker-compose "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcu > /dev/null 2>&1 || true
# Alias for "docker-compose up --detach --wait"
#
# Usage: dcu [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose up" command.
dcu() {
  dc up --detach --wait "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcb > /dev/null 2>&1 || true
# Alias for "docker-compose build"
#
# Usage: dcb [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose build" command.
dcb() {
  dc build "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcd > /dev/null 2>&1 || true
# Alias for "docker-compose down"
#
# Usage: dcd [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose down" command.
dcd() {
  dc down "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcr > /dev/null 2>&1 || true
# Alias for "docker-compose restart"
#
# Usage: dcr [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose restart" command.
dcr() {
  dc restart "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcl > /dev/null 2>&1 || true
# Alias for "docker-compose logs"
#
# Usage: dcl [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose logs" command.
dcl() {
  dc logs "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcps > /dev/null 2>&1 || true
# Alias for "docker-compose ps"
#
# Usage: dcps [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose ps" command.
dcps() {
  dc ps "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dce > /dev/null 2>&1 || true
# Alias for "docker-compose exec -it"
#
# Usage: dce [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose exec -it" command.
dce() {
  docker-compose exec -it "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}
# ========================================

# ========================================
# Extra
# ========================================
unalias dcud > /dev/null 2>&1 || true
# Alias for "docker-compose up --detach --wait && docker-compose down"
#
# Usage: dcud [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose up" and "docker-compose down" commands.
dcud() {
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcdu > /dev/null 2>&1 || true
# Alias for "docker-compose down && docker-compose up --detach --wait"
#
# Usage: dcdu [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose down" and "docker-compose up" commands.
dcdu() {
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcub > /dev/null 2>&1 || true
# Alias for "docker-compose up --detach --wait && docker-compose build"
#
# Usage: dcub [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose up" and "docker-compose build" commands.
dcub() {
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcbu > /dev/null 2>&1 || true
# Alias for "docker-compose build && docker-compose up --detach --wait"
#
# Usage: dcbu [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose build" and "docker-compose up" commands.
dcbu() {
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcdb > /dev/null 2>&1 || true
# Alias for "docker-compose down && docker-compose build"
#
# Usage: dcdb [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose down" and "docker-compose build" commands.
dcdb() {
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcbd > /dev/null 2>&1 || true
# Alias for "docker-compose build && docker-compose down"
#
# Usage: dcbd [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose build" and "docker-compose down" commands.
dcbd() {
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcbud > /dev/null 2>&1 || true
# Alias for "docker-compose build && docker-compose down && docker-compose up --detach --wait && docker-compose down"
#
# Usage: dcbud [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose build", "docker-compose up" and "docker-compose down" commands.
dcbud() {
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcbdu > /dev/null 2>&1 || true
# Alias for "docker-compose build && docker-compose down && docker-compose up --detach --wait"
#
# Usage: dcbdu [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose build", "docker-compose down" and "docker-compose up" commands.
dcbdu() {
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcdbu > /dev/null 2>&1 || true
# Alias for "docker-compose down && docker-compose build && docker-compose up --detach --wait"
#
# Usage: dcdbu [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose down", "docker-compose build" and "docker-compose up" commands.
dcdbu() {
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcdub > /dev/null 2>&1 || true
# Alias for "docker-compose down && docker-compose up --detach --wait && docker-compose build"
#
# Usage: dcdub [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose down", "docker-compose up" and "docker-compose build" commands.
dcdub() {
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcubd > /dev/null 2>&1 || true
# Alias for "docker-compose up --detach --wait && docker-compose build && docker-compose down"
#
# Usage: dcubd [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose up", "docker-compose build" and "docker-compose down" commands.
dcubd() {
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcudb > /dev/null 2>&1 || true
# Alias for "docker-compose up --detach --wait && docker-compose down && docker-compose build"
#
# Usage: dcudb [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose up", "docker-compose down" and "docker-compose build" commands.
dcudb() {
  dcu "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcd "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  dcb "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcpsa > /dev/null 2>&1 || true
# Alias for "docker-compose ps -a"
#
# Usage: dcpsa [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose ps" command.
dcpsa() {
  dcps -a "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcpsq > /dev/null 2>&1 || true
# Alias for "docker-compose ps -q"
#
# Usage: dcpsq [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose ps" command.
dcpsq() {
  dcps -q "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcpsaq > /dev/null 2>&1 || true
# Alias for "docker-compose ps -aq"
#
# Usage: dcpsaq [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose ps" command.
dcpsaq() {
  dcpsa -q "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dcpsqa > /dev/null 2>&1 || true
# Alias for "docker-compose ps -aq"
#
# Usage: dcpsqa [arg...]
# Where:
# - "arg": Extra argument to the "docker-compose ps" command.
dcpsqa() {
  dcpsaq "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}
# ========================================

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
