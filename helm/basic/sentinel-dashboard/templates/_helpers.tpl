{{/*
Expand the name of the chart.
*/}}
{{- define "sentinel-dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "sentinel-dashboard.fullname" -}}
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

{{- define "sentinel-dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "sentinel-dashboard.labels" -}}
helm.sh/chart: {{ include "sentinel-dashboard.chart" . }}
{{ include "sentinel-dashboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "sentinel-dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sentinel-dashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "sentinel-dashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sentinel-dashboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
