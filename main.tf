resource "cloudflare_dns_record" "this" {
  for_each = var.create ? var.records : {}

  zone_id  = var.zone_id
  name     = trimsuffix(each.value.name, ".")
  type     = each.value.type
  content  = trimsuffix(each.value.content, ".")
  ttl      = each.value.ttl
  proxied  = each.value.proxied
  comment  = each.value.comment
  priority = each.value.priority
}
