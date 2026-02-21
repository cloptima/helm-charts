# Cloptima K8s Agent Helm Chart

Deploy the Cloptima Kubernetes Agent to collect cluster inventory and metrics that feed the Cloptima optimization platform. The chart is published from this repository via GitHub Pages at `https://cloptima.github.io/helm-charts`.

## Installation

1. Add and update the Helm repository:
   ```bash
   helm repo add cloptima https://cloptima.github.io/helm-charts
   helm repo update
   ```
2. Provide the onboarding registration token and install:
   ```bash
   helm install cloptima-k8s-agent cloptima/cloptima-k8s-agent \
     --namespace cloptima --create-namespace \
     --set registration.installationToken="<your-installation-token>" \
     --set config.cloptimaApiURL="https://api.cloptima.ai"
   ```
3. (Optional) Use a custom values file if you want to change image tags, resources, or metrics scraping intervals:
   ```bash
   helm install cloptima-k8s-agent cloptima/cloptima-k8s-agent -f my-values.yaml
   ```

### Required values

| Key | Description |
| --- | --- |
| `registration.installationToken` | One-time cluster registration token issued by Cloptima |
| `config.cloptimaApiURL` | API endpoint to send collected data (defaults to `https://api.cloptima.ai`) |

### Common overrides

| Key | Purpose |
| --- | --- |
| `config.clusterName` | Override the detected cluster name if you want a fixed label |
| `namespaceOverride` | Target namespace for all chart resources (defaults to `cloptima`) |
| `metrics.serviceMonitor.enabled` | Expose Prometheus metrics through a ServiceMonitor |

### Upgrade or remove

```bash
helm upgrade cloptima-k8s-agent cloptima/cloptima-k8s-agent -f my-values.yaml
helm uninstall cloptima-k8s-agent --namespace cloptima
```

## Troubleshooting

- Verify the workload is running:
  ```bash
  kubectl get pods -n cloptima
  kubectl describe deployment cloptima-k8s-agent -n cloptima
  ```
- Inspect logs for connectivity errors:
  ```bash
  kubectl logs -l app.kubernetes.io/name=cloptima-k8s-agent -n cloptima -f
  ```
- 401/403 errors from the Cloptima API usually indicate an invalid/expired `registration.installationToken` during onboarding, or an invalid persisted `API_KEY` after onboarding.
- RBAC errors ("forbidden") mean the default service account could not read cluster resources; ensure the namespace was created and that the chart-managed ClusterRole/ClusterRoleBinding were installed successfully.
- If you changed API rate limits (QPS/burst), confirm the values rendered into the ConfigMap by running `kubectl get configmap cloptima-k8s-agent -n cloptima -o yaml`.

## Support

Open an issue in this repository or contact the Cloptima support team if the agent fails to register or stream data.
