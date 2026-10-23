# terraform-cloudflare-dns

Creates Cloudflare DNS records from a map keyed by a stable caller-chosen key. It is intended for certificate and email-domain validation records and for plain CNAMEs; other modules emit DNS records in the same `records` shape so they can be passed straight in.

## Opinions

- `ttl` defaults to `300` (use `1` for Cloudflare automatic TTL); allowed values are `1` or `60`-`86400`.
- `proxied` defaults to `false`.
- A trailing `.` is stripped from record `name` and `content`.
- `type` must be one of `A`, `AAAA`, `CNAME`, `TXT`, `MX`, `NS`, `SRV`, `CAA`, `PTR`.
- `priority` (MX/SRV) is not supported in v1.
- Records are not taggable, so there are no `tags`/`name` inputs and no `arn`/`self_link` output; `id` and `name` outputs return the zone ID.

## Usage

```hcl
module "this" {
  source = "git::https://github.com/Olensys/terraform-cloudflare-dns.git?ref=v1.0.0"

  context = {
    organization = "olensys"
    environment  = "dev"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }

  zone_id = "0123456789abcdef0123456789abcdef"
  records = {
    www = { name = "www.example.com", type = "CNAME", content = "target.example.net" }
    spf = { name = "example.com", type = "TXT", content = "v=spf1 -all", comment = "spf" }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 5.0, < 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | >= 5.0, < 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [cloudflare_dns_record.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_context"></a> [context](#input\_context) | Deployment context used for naming, tagging and environment-dependent defaults. | <pre>object({<br/>    organization = string<br/>    environment  = string<br/>    application  = string<br/>    component    = optional(string)<br/>    owner        = string<br/>    cost_center  = string<br/>    extra_tags   = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Cloudflare zone ID the records are created in. | `string` | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Whether to create any resources. Set false to create nothing. | `bool` | `true` | no |
| <a name="input_records"></a> [records](#input\_records) | DNS records keyed by a caller-chosen stable key. A trailing dot on name and content is stripped.<br/>ttl is 1 (automatic) or 60-86400 seconds. MX/SRV priority is not supported in v1. | <pre>map(object({<br/>    name    = string<br/>    type    = string<br/>    content = string<br/>    ttl     = optional(number, 300)<br/>    proxied = optional(bool, false)<br/>    comment = optional(string)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_fqdns"></a> [fqdns](#output\_fqdns) | Map of record key to record name (trailing dot stripped). |
| <a name="output_id"></a> [id](#output\_id) | ID of the zone the records belong to (var.zone\_id). Null when create is false. |
| <a name="output_name"></a> [name](#output\_name) | The zone the records belong to (var.zone\_id); this module is a record set, not a named resource. Null when create is false. |
| <a name="output_record_ids"></a> [record\_ids](#output\_record\_ids) | Map of record key to Cloudflare record ID. |
<!-- END_TF_DOCS -->
