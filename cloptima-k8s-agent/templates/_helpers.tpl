{{/*
Expand the name of the chart.
*/}}
{{- define "cloptima-k8s-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "cloptima-k8s-agent.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cloptima-k8s-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cloptima-k8s-agent.labels" -}}
helm.sh/chart: {{ include "cloptima-k8s-agent.chart" . }}
{{ include "cloptima-k8s-agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloptima-k8s-agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloptima-k8s-agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cloptima-k8s-agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cloptima-k8s-agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Resolve the target namespace for namespaced resources.
Defaults to "cloptima" unless overridden via helm --namespace or values.
*/}}
{{- define "cloptima-k8s-agent.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else if .Release.Namespace }}
{{- .Release.Namespace }}
{{- else }}
cloptima
{{- end }}
{{- end }}

{{/*
Secret name helper
*/}}
{{- define "cloptima-k8s-agent.secretName" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- printf "%s-credentials" (include "cloptima-k8s-agent.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
