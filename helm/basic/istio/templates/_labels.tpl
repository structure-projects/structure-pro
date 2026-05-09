{{- define "istio.labels" -}}
helm.sh/chart: {{ include "istio.chart" . }}
{{ include "istio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "istio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "istio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "istio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "istio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
