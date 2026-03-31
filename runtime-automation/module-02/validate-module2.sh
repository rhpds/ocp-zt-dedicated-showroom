#!/bin/bash
# validate-module2.sh
# Called by validation.yml via ansible.builtin.script
# Env vars set by Ansible: KUBECONFIG, PROJECT_NS
#
# Uses Python kubernetes library (available in zt-runner image)
# — no oc/kubectl needed

python3 <<'PYEOF'
import os, sys
from kubernetes import client, config

kubeconfig = os.environ.get('KUBECONFIG', '')
project_ns = os.environ.get('PROJECT_NS', 'dev-project')

if kubeconfig:
    config.load_kube_config(config_file=kubeconfig)
else:
    config.load_incluster_config()

v1 = client.CoreV1Api()

try:
    cm = v1.read_namespaced_config_map(name='app-config', namespace=project_ns)
    owner = cm.metadata.labels.get('created-by', 'unknown') if cm.metadata.labels else 'unknown'
    print(f"OK: ConfigMap app-config found in {project_ns} (created-by: {owner})")
    sys.exit(0)
except Exception as e:
    print(f"ERROR: ConfigMap app-config not found in {project_ns}")
    print(f"  Create it: oc create configmap app-config --from-literal=environment=development -n {project_ns}")
    sys.exit(1)
PYEOF
