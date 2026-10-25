terraform {
  required_version = ">= 1.5.0"
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare", version = ">= 5.0, < 6.0" }
  }
}

variable "zone_id" {
  description = "Cloudflare zone ID to create the example records in."
  type        = string
}

variable "zone_domain" {
  description = "Subdomain under which the example creates records."
  type        = string
  default     = "tf-test.olensys.com"
}

module "this" {
  source = "../../"

  context = {
    organization = "olensys"
    environment  = "test"
    application  = "dns"
    owner        = "platform"
    cost_center  = "eng"
  }

  zone_id = var.zone_id
  records = {
    www = { name = "www.${var.zone_domain}", type = "CNAME", content = var.zone_domain }
    txt = { name = "_olensys-test.${var.zone_domain}", type = "TXT", content = "v=olensys-test" }
    mx  = { name = "mail.${var.zone_domain}", type = "MX", content = var.zone_domain, priority = 10 }
  }
}

output "record_ids" {
  description = "Record IDs by key."
  value       = module.this.record_ids
}
