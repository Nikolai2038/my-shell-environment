#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_git.sh"

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
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

unalias gs > /dev/null 2>&1 || true
# Alias: "git status"
#
# Usage: gs [args]
gs() {
  git status "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias ga > /dev/null 2>&1 || true
# Alias: "git add"
#
# Usage: ga [args, default: .]
ga() {
  # If no files specified - we will add all
  [ "$#" -gt 0 ] && { __n2038_files="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_files="."

  git add "${__n2038_files}" "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_unset 0 && return "$?" || return "$?"
}

unalias gc > /dev/null 2>&1 || true
# Alias: "git commit -m"
#
# Usage: gc <message>
gc() {
  if [ "$#" -ne 1 ]; then
    _n2038_print_error "Usage: gc <message>" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"
  fi
  { __n2038_message="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

  git commit -m "${__n2038_message}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_unset 0 && return "$?" || return "$?"
}

unalias gpush > /dev/null 2>&1 || true
# Alias: "git push"
#
# Usage: gpush [args]
gpush() {
  git push "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias gpull > /dev/null 2>&1 || true
# Alias: "git pull"
#
# Usage: gpull [args]
gpull() {
  git pull "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

unalias gl > /dev/null 2>&1 || true
# Alias: "git log" (beautified)
#
# Usage: gl [args]
gl() {
  git log --graph --pretty=format:"%C(yellow)%h %C(green)%ad %C(cyan)%G? %C(blue)%an%C(magenta)%d%C(reset) %s" --date=format:"%Y-%m-%d %H:%M:%S" "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
