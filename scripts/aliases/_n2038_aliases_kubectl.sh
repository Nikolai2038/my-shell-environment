#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_kubectl.sh"

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

unalias k > /dev/null 2>&1 || true
# Alias for "kubectl".
#
# Usage: k [arg...]
# Where:
# - "arg": Extra argument to the "kubectl" command.
k() {
  kubectl "$@" || return "$?"
}

unalias kn > /dev/null 2>&1 || true
# Alias for "kubectl get namespaces".
#
# Usage: kn [arg...]
# Where:
# - "arg": Extra argument to the "kubectl get namespaces" command.
kn() {
  k get namespaces "$@" || return "$?"
}

unalias kps > /dev/null 2>&1 || true
# Alias for "kubectl get all,secret,persistentvolumeclaims".
# Prints status of the Kubernetes cluster.
#
# Usage: kps [arg...]
# Where:
# - "arg": Extra argument to the "kubectl get" command.
kps() {
  k get all,secret,persistentvolumeclaims "$@" || return "$?"
}

unalias kd > /dev/null 2>&1 || true
# Alias for "kubectl delete all,secret --all".
# Removes all resources in the Kubernetes cluster (but keeping volumes data).
#
# Usage: kd [arg...]
# Where:
# - "arg": Extra argument to the "kubectl delete" command.
kd() {
  k delete all,secret --all "$@" || return "$?"
}

unalias kdd > /dev/null 2>&1 || true
# Alias for "kubectl delete all,secret,persistentvolumeclaims --all".
# Removes all resources in the Kubernetes cluster (including volumes data).
#
# Usage: kdd [arg...]
# Where:
# - "arg": Extra argument to the "kubectl delete" command.
kdd() {
  k delete all,secret,persistentvolumeclaims --all "$@" || return "$?"
}

unalias kl > /dev/null 2>&1 || true
# Alias for "kubectl describe && kubectl logs".
# Prints logs of the specified resource in the Kubernetes cluster.
#
# Usage: kl [arg...]
# Where:
# - "arg": Extra argument to the "kubectl describe" and "kubectl logs" commands.
kl() {
  k describe "$@" || return "$?"
  echo ""
  k logs "$@" || return "$?"
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
