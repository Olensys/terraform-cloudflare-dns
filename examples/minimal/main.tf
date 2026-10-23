terraform {
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare", version = ">= 5.0, < 6.0" }
  }
}

variable "zone_id" {
  description = "Cloudflare zone ID to create the example records in."
  type        = string
}

module "this" {
  source = "../../"

  context = {
    organization = "olensys"
    environment  = "test"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }

  zone_id = var.zone_id
  records = {
    www = { name = "www.example.com", type = "CNAME", content = "target.example.net" }
    spf = { name = "example.com", type = "TXT", content = "v=spf1 -all", comment = "example" }
  }
}

output "record_ids" {
  description = "Record IDs by key."
  value       = module.this.record_ids
}
