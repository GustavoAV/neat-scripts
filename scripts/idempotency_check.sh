#!/bin/sh

# DESCRIPTION
#   Runs ansible playbooks twice and check if there are changes.
#   First argument is the inventory file.
#   All the others are ansible-playbook arguments.
# USAGE
#   ./idempotency_check.sh inventory_file [ansible_opts] playbook

set -eu

play_count=2
log_file=play.log
hosts_count=$(wc --lines <"$1")
shift

# Empties log file
printf "" >"$log_file"

# Runs playbook logging to file
for i in $(seq "$play_count"); do
    ANSIBLE_LOG_PATH="$log_file" ansible-playbook "$@"
done

# Get lines equal to number of hosts after last "PLAY RECAP"
play_recap=$(tail --lines "$hosts_count" "$log_file")

# Get only "changed" result codes
changed_code_list=$(
    echo "$play_recap" | grep -oE 'changed=.{,1}' | sed 's/changed=//'
)

# Checks if there's a change code different than zero
for code in $changed_code_list; do
    if [ "$code" -ne 0 ]; then
        echo "There are changes after $play_count plays. Not idempotent!"
        exit 0
    fi
done

echo "No changes after $play_count plays!"

exit 0
