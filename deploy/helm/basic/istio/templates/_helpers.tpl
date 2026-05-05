{{- define "istio.fullname" -}}
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

{{- define "istio.istiod.fullname" -}}
{{- printf "%s-istiod" (include "istio.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "istio.gateway.fullname" -}}
{{- printf "%s-%s" (include "istio.fullname" .) .Values.istio_gateway.name | trunc 63 | trimSuffix "-" }}
{{- end }}
