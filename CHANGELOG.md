# Changelog

## 1.0.0

- Cloudflare DNS records from a `records` map with a single `cloudflare_dns_record` `for_each`.
- Trailing dots stripped from name and content; type and ttl validated.
- Outputs: `record_ids`, `fqdns`, `id`, `name`.
