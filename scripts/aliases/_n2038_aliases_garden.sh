#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_garden.sh"

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
# ...

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# ========================================
# Main
# ========================================
unalias g > /dev/null 2>&1 || true
# Alias for "garden".
#
# Usage: g [arg...]
# Where:
# - "arg": Extra argument to the "garden" command.
gn() {
  garden "$@" || return "$?"
}

unalias gnb > /dev/null 2>&1 || true
# Alias for "garden build".
#
# Usage: gnb [arg...]
# Where:
# - "arg": Extra argument to the "garden build" command.
gnb() {
  gn build "$@" || return "$?"
}

unalias gnu > /dev/null 2>&1 || true
# Alias for "garden deploy".
#
# Usage: gnu [arg...]
# Where:
# - "arg": Extra argument to the "garden deploy" command.
gnu() {
  gn deploy "$@" || return "$?"
}

unalias gnd > /dev/null 2>&1 || true
# Alias for "garden cleanup deploy".
#
# Usage: gnd [arg...]
# Where:
# - "arg": Extra argument to the "garden cleanup deploy" command.
gnd() {
  gn cleanup deploy "$@" || return "$?"
}

unalias gndd > /dev/null 2>&1 || true
# Alias for "garden cleanup namespace".
#
# Usage: gndd [arg...]
# Where:
# - "arg": Extra argument to the "garden cleanup namespace" command.
gndd() {
  gn cleanup namespace "$@" || return "$?"
}
# ========================================

# ========================================
# Extra
# ========================================
unalias gndu > /dev/null 2>&1 || true
gndu() {
  gnd "$@" || return "$?"
  gnu "$@" || return "$?"
}

unalias gnddu > /dev/null 2>&1 || true
gnddu() {
  gndd "$@" || return "$?"
  gnu "$@" || return "$?"
}

unalias gnbdu > /dev/null 2>&1 || true
gnbdu() {
  gnb "$@" || return "$?"
  gnd "$@" || return "$?"
  gnu "$@" || return "$?"
}

unalias gnbddu > /dev/null 2>&1 || true
gnbddu() {
  gnb "$@" || return "$?"
  gndd "$@" || return "$?"
  gnu "$@" || return "$?"
}
# ========================================

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
