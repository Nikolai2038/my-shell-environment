#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_docker.sh"

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
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# ========================================
# Main
# ========================================
unalias dps > /dev/null 2>&1 || true
# Alias for "docker ps".
# Prints list of the running containers.
#
# Usage: dps [arg...]
# Where:
# - "arg": Extra argument to the "docker ps" command.
dps() {
  _n2038_commands_must_be_installed docker || { _n2038_unset "$?" && return "$?" || return "$?"; }
  docker ps --format "table {{.Names}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}" "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias di > /dev/null 2>&1 || true
# Alias for "docker images".
# Prints colorful list of the images with line format:
# `<image>:<tag> (<size>)`
#
# Usage: di [arg...]
# Where:
# - "arg": Extra argument to the "docker ps" command.
di() {
  _n2038_commands_must_be_installed docker less || { _n2038_unset "$?" && return "$?" || return "$?"; }
  docker image list --format "${c_success}{{.Repository}}${c_text}:${c_border_usual}{{.Tag}}${c_text} ({{.Size}})${c_reset}" --filter "dangling=false" | grep -v '<none>' | sort | less -R || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}
# ========================================

# ========================================
# Extra
# ========================================
unalias dpsq > /dev/null 2>&1 || true
# Alias for "docker ps -q".
# Prints list of hashes of the running containers.
#
# Usage: dpsq [arg...]
# Where:
# - "arg": Extra argument to the "docker ps" command.
dpsq() {
  dps -q "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dpsa > /dev/null 2>&1 || true
# Alias for "docker ps -a".
# Prints list of all containers (running and stopped).
#
# Usage: dpsa [arg...]
# Where:
# - "arg": Extra argument to the "docker ps" command.
dpsa() {
  dps -a "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias dpsaq > /dev/null 2>&1 || true
# Alias for "docker ps -aq".
# Prints list of hashes of all containers (running and stopped).
#
# Usage: dpsaq [arg...]
# Where:
# - "arg": Extra argument to the "docker ps" command.
dpsaq() {
  dpsa -q "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}
# ========================================

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
