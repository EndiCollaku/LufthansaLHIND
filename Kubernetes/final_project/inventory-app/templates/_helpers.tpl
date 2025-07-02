{{/*
Expand the name of the chart.
*/}}
{{- define "inventory-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "inventory-app.fullname" -}}
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
{{- define "inventory-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "inventory-app.labels" -}}
helm.sh/chart: {{ include "inventory-app.chart" . }}
{{ include "inventory-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "inventory-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "inventory-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Backend labels
*/}}
{{- define "inventory-app.backend.labels" -}}
{{ include "inventory-app.labels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "inventory-app.frontend.labels" -}}
{{ include "inventory-app.labels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
PostgreSQL labels
*/}}
{{- define "inventory-app.postgresql.labels" -}}
{{ include "inventory-app.labels" . }}
app.kubernetes.io/component: postgresql
{{- end }}

{{/*
pgAdmin labels
*/}}
{{- define "inventory-app.pgadmin.labels" -}}
{{ include "inventory-app.labels" . }}
app.kubernetes.io/component: pgadmin
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "inventory-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "inventory-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}