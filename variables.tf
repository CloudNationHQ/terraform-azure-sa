variable "storage" {
  description = "storage account details"
  type = any
}

variable "naming" {
  description = "contains naming convention"
  type    = map(string)
  default = {}
}
