module "resourceGroup" {
  source   = "../../resources/base/resourceGroup"
  name     = var.resourceGroupName
  location = var.location
}

module "containerRegistry" {
  source            = "../../resources/container/registry"
  name              = local.registryName
  location          = var.location
  resourceGroupName = module.resourceGroup.name
  sku               = var.registrySku
  adminEnabled      = var.registryAdminEnabled
}

/*
module "virtualNetwork" {
  source            = "../../resources/network/virtualNetwork"
  name              = var.name
  location          = var.location
  resourceGroupName = module.resourceGroup.name
  addressSpace      = var.virtualNetwork.addressSpace
  dnsServers        = var.virtualNetwork.dnsServers
  subnets           = var.virtualNetwork.subnets
}
*/


module "k8sCluster" {
  source            = "../../resources/container/k8sCluster"
  name              = local.k8sClusterName
  location          = var.location
  resourceGroupName = module.resourceGroup.name
  dnsPrefix         = var.name
  nodeResourceGroup = local.k8sNodeResourceGroup
  defaultNodePool   = local.k8sDefaultNodePool
  networkProfile    = local.k8sNetworkProfile
  servicePrincipal  = var.k8sServicePrincipal
}

resource "local_file" "kubeConfig" {
    content  = module.k8sCluster.kube_config
    filename = "${var.kubeConfigDir}/config"
}
