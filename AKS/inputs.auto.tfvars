aks_vnet_name = "aksvnet"

sshkvsecret = "akssshpubkey"

clientidkvsecret = "clientID"

spnkvsecret = "spnSecret"

vnetcidr = ["10.0.0.0/24"]

subnetcidr = ["10.0.0.0/25"]

keyvault_rg = "manduterraformrg"

keyvault_name = "manduterraformkeyvault2"

azure_region = "southindia"

resource_group = "akscluster-rg"

cluster_name = "akscluster"

dns_name = "akscluster"

admin_username = "aksuser"

kubernetes_version = "1.21.7"

agent_pools = {
  name            = "pool1"
  count           = 1
  vm_size         = "Standard_D2_v2"
  os_disk_size_gb = "30"
}