#!/bin/sh

_n2038_template() {
  echo "Template!" >&2
}

_n2038_template "${@}" || {
  return_code="$?"
  # If file is being executed
  if [ "$(basename "$0")" = "_n2038_template.sh" ]; then
    exit "${return_code}"
  # If file is being sourced
  else
    return "${return_code}"
  fi
}
