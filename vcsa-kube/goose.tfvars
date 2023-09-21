vsphere_server = "vcsa7.thegoose.work"
vsphere_user = "administrator@vcsa7.thegoose.work"
vsphere_password = "gDcyVZTM(r6waSnX"

vsphere_datacenter = "GooseHQ"
vsphere_compute_cluster = "Anthos"
vsphere_datastore = "BaracudaRaid0"
vsphere_network="VM Network"
vsphere_template_folder="Packer_Images"
worker_vm-template-name="k3os-worker-template"
master_vm-template-name="k3os-server-template"

worker_count = 5
worker_name = "k3os-alpha-worker-01"
worker_cpu = 4
worker_cores-per-socket = 8
worker_ram = 16384
worker_vm-guest-id = "other4xLinux64Guest"
worker_disksize = 20

master_count = 3
master_name = "k3os-alpha-master-01"
master_cpu = 4
master_cores-per-socket = 8
master_ram = 16384
master_vm-guest-id = "other4xLinux64Guest"
master_disksize = 20