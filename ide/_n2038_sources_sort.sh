#!/bin/bash

# Fail command if any of pipeline blocks fail
set -o pipefail

# Sort sources in the specified file
_n2038_sources_sort() {
  local file_path="${1}" && { shift || true; }

  # File content
  local file_content
  file_content="$(cat "${file_path}")" || return "$?"

  # Lines of the file content
  declare -a file_lines
  # Make sure to add empty line, so the "for" cycle will check all source blocks
  mapfile -t file_lines <<< "${file_content}
" || return "$?"

  # New file content - with sorted "source" blocks
  local new_file_content

  local was_source=0
  local sources_to_sort=""

  local line
  for line in "${file_lines[@]}"; do
    if [[ ! ${line} =~ ^source[[:blank:]] ]] && [[ ! ${line} =~ ^\.[[:blank:]] ]]; then
      if ((was_source)); then
        # Sort and remove empty line at the end
        sources_to_sort="$(echo -n "${sources_to_sort}" | sort --unique | grep -v '^$')" || return "$?"
        if [ -n "${new_file_content}" ]; then
          new_file_content+="
" || return "$?"
        fi
        new_file_content+="${sources_to_sort}" || return "$?"
      fi

      was_source=0
      sources_to_sort=""
      if [ -n "${new_file_content}" ]; then
        new_file_content+="
" || return "$?"
      fi
      new_file_content+="${line}" || return "$?"
    else
      was_source=1
      if [ -n "${sources_to_sort}" ]; then
        sources_to_sort+="
" || return "$?"
      fi
      sources_to_sort+="${line}" || return "$?"
    fi
  done

  # Remove one empty line at the end because we added it when converting to array
  # shellcheck disable=SC2320
  echo -n "${new_file_content}" > "${file_path}" || return "$?"

  return 0
}

_n2038_sources_sort "${@}" || exit "$?"
