######################################
# Provision the resources in this file
######################################

provider "azurerm" {
  features {}
}


#################################################
# Define the resource groups for each service bus
#################################################

module "resource_group1" {
  source = "../../modules/resource_group"

  environment = "test1"
  label_order = ["name", "environment", ]

  name     = "test1"
  location = "North Europe"

  #resource lock
  resource_lock_enabled = true
  lock_level            = "CanNotDelete"
}

module "resource_group2" {
  source = "../../modules/resource_group"

  environment = "test2"
  label_order = ["name", "environment", ]

  name     = "test2"
  location = "North Europe"

  # resource lock
  resource_lock_enabled = true
  lock_level            = "CanNotDelete"
}


########################
# Define the service bus 
########################

module "service_bus1" {
  source = "../../modules/service_bus"

  name        = "app"
  environment = "test"
  cost_centre = "test"
  
  # resource lock
  resource_lock_enabled = true

  # select the resource group for the service bus
  resource_group_name = module.resource_group1.resource_group_name
  location            = module.resource_group1.resource_group_location
  
  # Define the number of queues
  queues = [
    {
      name = "queue1"
      authorization_rules = [
        {
          name   = "testapp_auth1"
          rights = ["listen", "send"]
        }
      ]
    },

    {
    name = "queue2"
      authorization_rules = [
        {
          name   = "testapp_auth2"
          rights = ["listen", "send"]
        }
      ]
    }
  ]
}

module "service_bus2" {
  source = "../../modules/service_bus"

  name        = "app"
  environment = "test"

  # resource lock
  resource_lock_enabled = true
  
  cost_centre = "test2"
  
  # select the resource group for the service bus
  resource_group_name = module.resource_group2.resource_group_name
  location            = module.resource_group2.resource_group_location

  # define the number of queues 
  queues = [
    {
      name = "queue1"
      authorization_rules = [
        {
          name   = "example1"
          rights = ["listen", "send"]
        }
      ]
    },

    {
      name = "queue2"
      authorization_rules = [
        {
          name   = "example2"
          rights = ["listen", "send"]
        }
      ]
    }
  ]
}