variable "zoneName" {
}

variable "resourceGroupName" {
}

variable "ttl" {
  default = "30"
}

variable "records" {
  type    = map(list(string))
  default = {}
}

