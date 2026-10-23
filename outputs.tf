# No arn/self_link output: Cloudflare records have no ARN or self link, and are not taggable.

output "id" {
  description = "ID of the zone the records belong to (var.zone_id). Null when create is false."
  value       = var.create ? var.zone_id : null
}

output "name" {
  description = "The zone the records belong to (var.zone_id); this module is a record set, not a named resource. Null when create is false."
  value       = var.create ? var.zone_id : null
}

output "record_ids" {
  description = "Map of record key to Cloudflare record ID."
  value       = { for k, r in cloudflare_dns_record.this : k => r.id }
}

output "fqdns" {
  description = "Map of record key to record name (trailing dot stripped)."
  value       = { for k, r in cloudflare_dns_record.this : k => r.name }
}
