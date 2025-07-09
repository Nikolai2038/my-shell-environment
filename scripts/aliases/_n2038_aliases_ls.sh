#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_ls.sh"

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

unalias l > /dev/null 2>&1 || true
# Alias for "ls".
# Prints list of the files (exclude hidden).
#
# Usage: l [arg...]
# Where:
# - "arg": Extra argument to the "ls" command.
l() {
  # - We use "sed" to remove "total".
  # - We don't use "-1" from "ls" because it does not show us where links are pointing.
  #   Instead, we use "cut".
  # - We use "tr" to remove duplicate spaces - for "cut" to work properly.
  command ls -F --group-directories-first --color -l --human-readable --time-style=long-iso "$@" | sed -E '/^(total|итого)/d' | tr -s '[:blank:]' | cut -d ' ' -f 8- || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias la > /dev/null 2>&1 || true
# Alias for "ls --almost-all".
# Prints list of the files (include hidden).
#
# Usage: la [arg...]
# Where:
# - "arg": Extra argument to the "ls" command.
la() {
  l --almost-all "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias ll > /dev/null 2>&1 || true
# Alias for "ls -l".
# Prints list of the files (exclude hidden) with their details.
#
# Usage: ll [arg...]
# Where:
# - "arg": Extra argument to the "ls" command.
ll() {
  command ls -F --group-directories-first --color -l --human-readable --time-style=long-iso "$@" | sed -E '/^(total|итого)/d' || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias lla > /dev/null 2>&1 || true
# Alias for "ls -l --almost-all".
# Prints list of the files (include hidden) with their details.
#
# Usage: lla [arg...]
# Where:
# - "arg": Extra argument to the "ls" command.
lla() {
  ll --almost-all "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias lm > /dev/null 2>&1 || true
# Prints list of the files (exclude hidden) in Markdown format.
#
# Usage: lm [arg...]
# Where:
# - "arg": Extra argument to the "ls" command.
lm() {
  # shellcheck disable=SC2016
  l "$@" | sed -E 's/^(.*)$/- `\1`;/' || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias lam > /dev/null 2>&1 || true
# Prints list of the files (include hidden) in Markdown format.
#
# Usage: lam [arg...]
# Where:
# - "arg": Extra argument to the "ls" command.
lam() {
  lm --almost-all "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias lma > /dev/null 2>&1 || true
# Alias for "lam".
# Prints list of the files (include hidden) in Markdown format.
#
# Usage: lma [arg...]
# Where:
# - "arg": Extra argument to the "lam" command.
lma() {
  lam "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
