# Changelog

## [1.1.0](https://github.com/Olensys/terraform-cloudflare-dns/compare/v1.0.1...v1.1.0) (2026-10-25)


### Features

* MX and SRV record priority ([#1](https://github.com/Olensys/terraform-cloudflare-dns/issues/1)) ([3c6ed5f](https://github.com/Olensys/terraform-cloudflare-dns/commit/3c6ed5f6c5f82fb04f305ece25eec13460c91df5))

## 1.0.1

### Fixes

- render declared provider constraints and skip .terraform in trivy scans
- declare required_version and providers in examples/minimal

## 1.0.0

- Cloudflare DNS records from a `records` map with a single `cloudflare_dns_record` `for_each`.
- Trailing dots stripped from name and content; type and ttl validated.
- Outputs: `record_ids`, `fqdns`, `id`, `name`.
