#############################
#Module      : resource_group
#############################

module "labels" {
  source  = "../../modules/labels"

  name          = var.name
  environment   = var.environment
  managedby     = var.managedby
  business_unit = var.business_unit
  label_order   = var.label_order
}

#Module      : RESOURCE GROUP
#Description : Terraform resource for resource group.
resource "azurerm_resource_group" "default" {
  count    = var.enabled ? 1 : 0
  name     = format("%s-resource-group", module.labels.id)
  location = var.location
  tags     = module.labels.tags

  timeouts {
    create = var.create
    read   = var.read
    update = var.update
    delete = var.delete
  }
}

resource "azurerm_management_lock" "resource-group-level" {
  count      = var.enabled && var.resource_lock_enabled ? 1 : 0
  name       = format("%s-rg-lock", var.lock_level)
  scope      = azurerm_resource_group.default.*.id[0]
  lock_level = var.lock_level
  notes      = "This Resource Group is locked by terrafrom"
}