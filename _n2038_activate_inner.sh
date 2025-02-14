#!/bin/sh

_n2038_activate_inner() {
  # Set command prompt
  # shellcheck disable=SC2154
  export PS1='`command_result=$?; if [ $command_result -ne 0 ]; then echo "\[\033[01;31m\]Exit Code $command_result "; fi`\[\033[01;32m\]\u@\h \[\033[01;34m\]\w \[\033[01;32m\]$ \[\033[00m\]'

  # Make scripts available in shell by their names
  export PATH="${_N2038_SHELL_ENVIRONMENT_PATH}:${PATH}"
}

_n2038_activate_inner "${@}" || {
  return_code="$?"
  # If file is being executed
  if [ "$(basename "$0")" = "_n2038_activate_inner.sh" ]; then
    exit "${return_code}"
  # If file is being sourced
  else
    return "${return_code}"
  fi
}
