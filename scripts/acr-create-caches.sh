#!/usr/bin/env bash

ACR="creastusd0v1rlaigtcom"
SUB="lot-rla-shd-d0-na"

az acr cache create --registry "${ACR}" --name postgres --source-repo docker.io/library/postgres --target-repo postgres --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name apache --source-repo docker.io/bitnami/apache --target-repo bitnami/apache --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name grafana --source-repo docker.io/grafana/grafana --target-repo grafana/grafana --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name grafana-loki --source-repo docker.io/grafana/loki --target-repo grafana/loki --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name nginx-unprivileged --source-repo docker.io/nginxinc/nginx-unprivileged --target-repo nginxinc/nginx-unprivileged --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name promtail --source-repo docker.io/grafana/promtail --target-repo grafana/promtail --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name alertmanager --source-repo quay.io/prometheus/alertmanager --target-repo prometheus/alertmanager --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name prometheus --source-repo quay.io/prometheus/prometheus --target-repo prometheus/prometheus --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name prometheus-operator --source-repo quay.io/prometheus-operator/prometheus-operator --target-repo prometheus-operator/prometheus-operator --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name prometheus-config-reloader --source-repo quay.io/prometheus-operator/prometheus-config-reloader --target-repo prometheus-operator/prometheus-config-reloader --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name prometheus-node-exporter --source-repo quay.io/prometheus/node-exporter --target-repo prometheus/node-exporter --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name thanos --source-repo quay.io/thanos/thanos --target-repo thanos/thanos --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name grafana --source-repo docker.io/grafana/grafana --target-repo grafana/grafana --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name kube-webhook-certgen --source-repo registry.k8s.io/ingress-nginx/kube-webhook-certgen --target-repo ingress-nginx/kube-webhook-certgen --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name kube-state-metrics --source-repo registry.k8s.io/kube-state-metrics/kube-state-metrics --target-repo kube-state-metrics/kube-state-metrics --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name curlimages-curl --source-repo docker.io/curlimages/curl --target-repo curlimages/curl --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name busybox --source-repo docker.io/library/busybox --target-repo library/busybox --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name kiwigrid-k8s-sidecar --source-repo quay.io/kiwigrid/k8s-sidecar --target-repo kiwigrid/k8s-sidecar --subscription "${SUB}"

az acr cache create --registry "${ACR}" --name grafana-image-renderer --source-repo docker.io/grafana/grafana-image-renderer --target-repo grafana/grafana-image-renderer --subscription "${SUB}"