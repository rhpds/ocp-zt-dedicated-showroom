#!/bin/bash
oc create configmap app-config \
  --from-literal=environment=production \
  --from-literal=app=my-app \
  -n demo-project \
  --dry-run=client -o yaml | oc apply -f -
echo "app-config ConfigMap applied in demo-project"
