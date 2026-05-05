{{- define "alertmanager-grafana.fullname" -}}
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

{{- define "alertmanager-grafana.alertmanager.fullname" -}}
{{- printf "%s-alertmanager" (include "alertmanager-grafana.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "alertmanager-grafana.grafana.fullname" -}}
{{- printf "%s-grafana" (include "alertmanager-grafana.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "alertmanager-grafana.labels" -}}
helm.sh/chart: {{ include "alertmanager-grafana.chart" . }}
{{ include "alertmanager-grafana.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "alertmanager-grafana.selectorLabels" -}}
app.kubernetes.io/name: {{ include "alertmanager-grafana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "alertmanager-grafana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "alertmanager-grafana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
