#!/bin/bash

# Hỏi xác nhận
read -p "Bạn có chắc chắn muốn xóa toàn bộ namespace odoo-system? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Liệt kê các PV liên quan đến namespace odoo-system
echo "PVs liên quan đến namespace odoo-system:"
kubectl get pv | grep odoo-system

# Xóa claimRef từ tất cả PVs liên quan đến namespace odoo-system
for pv in $(kubectl get pv -o jsonpath='{.items[?(@.spec.claimRef.namespace=="odoo-system")].metadata.name}')
do
    echo "Xóa claimRef từ PV $pv..."
    kubectl patch pv $pv --type json -p '[{"op":"remove","path":"/spec/claimRef"}]'
done

# Xóa namespace
echo "Xóa namespace odoo-system..."
kubectl delete namespace odoo-system

# Xóa các PVs
echo "Xóa các PVs..."
kubectl delete pv odoo-pv postgres-pv local-image-storage-pv redis-pv

echo "Đã hoàn tất việc dọn dẹp các tài nguyên Odoo."
