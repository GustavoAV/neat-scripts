#!/usr/bin/env bash

# DESCRIPTION
#   List all deployments of a specific Kubernetes namespace and replace the registry.
#   Note: Doesn't modify or fail on images without a specific registry.
# USAGE
#   kube_replace_registry <namespace> <old.registry.com> <new.registry.com>

set -euo pipefail

namespace="$1"
old_registry="$2"
new_registry="$3"

# Gets all deployments
deployments=$(kubectl get deployments \
    --namespace="$namespace" \
    -o=jsonpath='{.items[*].metadata.name}')

# Sets image of all containers in all deployments
replace_deploy_image() {
    local deploy="$1"

    current_image=$(kubectl get deployment "$deploy" \
        --namespace="$namespace" \
        -o=jsonpath='{.spec.template.spec.containers[0].image}')
    new_image="${current_image//$old_registry/$new_registry}"

    kubectl set image deployment "$deploy" "*=$new_image" --namespace="$namespace"
}

for deploy in $deployments; do
    replace_deploy_image "$deploy"
done

exit 0
