#!/bin/bash

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="autocompletion/bash/aliases/_n2038_aliases_kubectl.sh"

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
. "../../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
# ...

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Get functions for autocompletion from original command
# shellcheck disable=SC1090
. <(kubectl completion bash) || _n2038_return "$?" || return "$?"

__k() {
  __start_kubectl || return "$?"
}
complete -F __k k || _n2038_return "$?" || return "$?"

# TODO: I found this check in the "kubectl" autocompletion - maybe implement this check for custom autocompletion too?
# if [ "$(type -t compopt)" = "builtin" ]; then
#   complete -o default -F __k k
# else
#   complete -o default -o nospace -F __k k
# fi

__kl() {
  COMP_WORDS=("k" "logs" "${COMP_WORDS[@]:1}") || return "$?"
  COMP_CWORD="$((COMP_CWORD + 1))" || return "$?"
  COMP_LINE="k logs ${COMP_LINE#kl }" || return "$?"
  __start_kubectl || return "$?"
}
complete -F __kl kl || _n2038_return "$?" || return "$?"

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
