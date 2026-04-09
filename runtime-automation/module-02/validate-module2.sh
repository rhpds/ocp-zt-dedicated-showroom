#!/bin/bash
if oc get configmap app-config -n demo-project &>/dev/null; then
  echo "app-config ConfigMap exists in demo-project"
  exit 0
else
  echo "app-config ConfigMap not found in demo-project"
  exit 1
fi
