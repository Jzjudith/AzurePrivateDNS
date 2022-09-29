variable "resource_group" {
  type        = string
  description = "Name of resource group"
  default     = "devlab-privateDNS-rg"
}

variable "location" {
  type        = string
  description = "Name of location"
  default     = "East US2"
}

variable "vnet" {
  type        = string
  description = "Name of virtual network"
  default     = "devlab--vnet"
}

variable "subnet" {
  type        = string
  description = "Name of subnetwork"
  default     = "devlab--subnet"
}
