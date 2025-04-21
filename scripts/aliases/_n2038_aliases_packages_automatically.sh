#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_packages_automatically.sh"

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

unalias i > /dev/null 2>&1 || true
# Install specified packages (Confirm all prompts automatically).
#
# Usage: i <package...> [arg...]
# Where:
# - "arg": Extra argument to the "apt"/"apt-get"/"pacman"/"yay"/"dnf"/"pkg" command.
i() {
  if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_ARCH}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_FEDORA}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_DEBIAN}" ]; then
    :
  else
    _n2038_print_error "Installing packages via \"${c_highlight}i${c_return}\" is not implemented for \"${_N2038_CURRENT_OS_NAME}\"!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    return 1
  fi
  return 0
}

unalias r > /dev/null 2>&1 || true
# Remove specified packages (Confirm all prompts automatically).
#
# Usage: r <package...> [arg...]
# Where:
# - "arg": Extra argument to the "apt"/"apt-get"/"pacman"/"yay"/"dnf"/"pkg" command.
r() {
  if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_ARCH}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_FEDORA}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_DEBIAN}" ]; then
    :
  else
    _n2038_print_error "Removing packages via \"${c_highlight}r${c_return}\" is not implemented for \"${_N2038_CURRENT_OS_NAME}\"!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    return 1
  fi
  return 0
}

unalias u > /dev/null 2>&1 || true
# Update specified packages (Confirm all prompts automatically).
# If no package is specified, this will update all packages.
#
# Usage: u [package...] [arg...]
# Where:
# - "arg": Extra argument to the "apt"/"apt-get"/"pacman"/"yay"/"dnf"/"pkg" command.
u() {
  if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_ARCH}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_FEDORA}" ]; then
    :
  elif [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_DEBIAN}" ]; then
    :
  else
    _n2038_print_error "Updating packages via \"${c_highlight}u${c_return}\" is not implemented for \"${_N2038_CURRENT_OS_NAME}\"!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    return 1
  fi
  return 0
}

unalias uu > /dev/null 2>&1 || true
# Update all packages and optimize the system (Confirm all prompts automatically).
#
# Usage: uu [arg...]
# Where:
# - "arg": Extra argument to the "apt"/"apt-get"/"pacman"/"yay"/"dnf"/"pkg" command.
uu() {
  u "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # TODO: System optimizations
  # ...

  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
