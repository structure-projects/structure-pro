{{- define "logstash-kibana.fullname" -}}
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

{{- define "logstash-kibana.logstash.fullname" -}}
{{- printf "%s-logstash" (include "logstash-kibana.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "logstash-kibana.kibana.fullname" -}}
{{- printf "%s-kibana" (include "logstash-kibana.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "logstash-kibana.labels" -}}
helm.sh/chart: {{ include "logstash-kibana.chart" . }}
{{ include "logstash-kibana.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "logstash-kibana.selectorLabels" -}}
app.kubernetes.io/name: {{ include "logstash-kibana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "logstash-kibana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "logstash-kibana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
