{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "REALM_APPLICATION.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "REALM_APPLICATION.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "REALM_APPLICATION.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "REALM_APPLICATION-default.name"  -}}
{{ include "REALM_APPLICATION.name" . }}-default
{{- end }}

{{- define "REALM_APPLICATION-default.fullname"  -}}
{{ include "REALM_APPLICATION.fullname" . }}-default
{{- end }}

{{- define "REALM_APPLICATION-rpc.fullname" -}}
{{ include "REALM_APPLICATION.fullname" . }}-rpc
{{- end -}}

{{- define "REALM_APPLICATION-rpc.name" -}}
{{ include "REALM_APPLICATION.name" . }}-rpc
{{- end -}}

{{/*
Common labels
*/}}
{{- define "REALM_APPLICATION.labels" -}}
helm.sh/chart: {{ include "REALM_APPLICATION.chart" . }}
{{ include "REALM_APPLICATION.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "REALM_APPLICATION.selectorLabels" -}}
app.kubernetes.io/name: {{ include "REALM_APPLICATION.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
REALM_APPLICATION Default Selector labels
*/}}
{{- define "REALM_APPLICATION.defaultSelectorLabels" -}}
app.kubernetes.io/name: {{ include "REALM_APPLICATION-default.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
REALM_APPLICATION RPC Selector labels
*/}}
{{- define "REALM_APPLICATION.rpcSelectorLabels" -}}
app.kubernetes.io/name: {{ include "REALM_APPLICATION-rpc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "REALM_APPLICATION.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "REALM_APPLICATION.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}