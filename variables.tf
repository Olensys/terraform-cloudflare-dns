# Part of the module interface contract; records carry no tags or names derived from it.
# tflint-ignore: terraform_unused_declarations
variable "context" {
  description = "Deployment context used for naming, tagging and environment-dependent defaults."
  type = object({
    organization = string
    environment  = string
    application  = string
    component    = optional(string)
    owner        = string
    cost_center  = string
    extra_tags   = optional(map(string), {})
  })
  validation {
    condition     = contains(["dev", "staging", "prod", "test", "shared"], var.context.environment)
    error_message = "context.environment must be one of dev, staging, prod, test, shared."
  }
}

variable "create" {
  description = "Whether to create any resources. Set false to create nothing."
  type        = bool
  default     = true
}

variable "zone_id" {
  description = "Cloudflare zone ID the records are created in."
  type        = string
}

variable "records" {
  description = <<-EOT
    DNS records keyed by a caller-chosen stable key. A trailing dot on name and content is stripped.
    ttl is 1 (automatic) or 60-86400 seconds. MX and SRV records require priority (0-65535); other types must not set it.
  EOT
  type = map(object({
    name     = string
    type     = string
    content  = string
    ttl      = optional(number, 300)
    proxied  = optional(bool, false)
    comment  = optional(string)
    priority = optional(number)
  }))
  default = {}

  validation {
    condition = alltrue([
      for r in values(var.records) : contains(["A", "AAAA", "CNAME", "TXT", "MX", "NS", "SRV", "CAA", "PTR"], r.type)
    ])
    error_message = "Each record type must be one of A, AAAA, CNAME, TXT, MX, NS, SRV, CAA, PTR."
  }

  validation {
    condition     = alltrue([for r in values(var.records) : r.ttl == 1 || (r.ttl >= 60 && r.ttl <= 86400)])
    error_message = "Each record ttl must be 1 (automatic) or between 60 and 86400."
  }

  validation {
    condition = alltrue([
      for r in values(var.records) : contains(["MX", "SRV"], r.type) ? r.priority != null : r.priority == null
    ])
    error_message = "priority is required for MX and SRV records and must be omitted for every other type."
  }

  validation {
    condition     = alltrue([for r in values(var.records) : r.priority == null || (r.priority >= 0 && r.priority <= 65535)])
    error_message = "priority must be between 0 and 65535."
  }
}
