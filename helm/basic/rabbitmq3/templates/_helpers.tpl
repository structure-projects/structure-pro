{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rabbitmq3.fullname" -}}
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

{{- define "rabbitmq3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rabbitmq3.labels" -}}
helm.sh/chart: {{ include "rabbitmq3.chart" . }}
{{ include "rabbitmq3.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "rabbitmq3.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rabbitmq3.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "rabbitmq3.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rabbitmq3.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
