#!/bin/bash

# Tạo namespace
kubectl apply -f namespace/namespace.yaml

# Triển khai storage
kubectl apply -f storage/ceph-storageclass.yaml
kubectl apply -f secrets/ceph-admin-secret.yaml
kubectl apply -f storage/postgres-pv.yaml
kubectl apply -f storage/postgres-pvc.yaml
kubectl apply -f storage/odoo-pv.yaml
kubectl apply -f storage/odoo-pvc.yaml
kubectl apply -f storage/local-image-storage-pv.yaml
kubectl apply -f storage/local-image-storage-pvc.yaml
kubectl apply -f storage/redis-pv.yaml
kubectl apply -f storage/redis-pvc.yaml
kubectl apply -f redis/redis-deployment.yaml
kubectl apply -f redis/redis-service.yaml


# Triển khai secrets và config
kubectl apply -f secrets/odoo-secrets.yaml
kubectl apply -f config/odoo-config.yaml
kubectl apply -f config/postgres-config.yaml

# Triển khai PostgreSQL
kubectl apply -f database/postgres-deployment.yaml
kubectl apply -f database/postgres-service.yaml

# Đợi PostgreSQL khởi động
echo "Đợi PostgreSQL khởi động..."
sleep 20

# Triển khai Odoo
kubectl apply -f application/odoo-deployment-update.yaml
kubectl apply -f application/odoo-service.yaml

# Kiểm tra triển khai
echo "Triển khai hoàn tất. Kiểm tra trạng thái..."
kubectl get all -n odoo-system
