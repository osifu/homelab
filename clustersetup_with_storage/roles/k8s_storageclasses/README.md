# k8s_storageclasses

Installs open-source storage layers and creates three StorageClasses:

- **nfs-csi-external** → shared storage via NFS CSI, backed by your external ZFS pool on the NUC
- **local-zfs** → per-node local-path provisioner using `/mnt/localfastpool`
- **zfs-localpv** → OpenEBS ZFS LocalPV (per-node ZFS datasets with quotas on `localfastpool`)

Assumes MicroK8s on the control host (`zfs_pool_host`).

## Vars (defaults)

See `defaults/main.yml` for versions and names.
