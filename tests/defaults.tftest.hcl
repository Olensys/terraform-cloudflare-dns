mock_provider "cloudflare" {}

variables {
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }
  zone_id = "0123456789abcdef0123456789abcdef"
  records = {
    www = { name = "www.example.com", type = "CNAME", content = "target.example.net" }
    txt = { name = "_abc.example.com", type = "TXT", content = "v=spf1 -all", ttl = 60, comment = "spf" }
    api = { name = "api.example.com", type = "A", content = "192.0.2.10", proxied = true, ttl = 1 }
  }
}

run "test_records_created_per_key" {
  command = plan

  assert {
    condition     = length(cloudflare_dns_record.this) == 3
    error_message = "One record must be planned per input key."
  }

  assert {
    condition     = cloudflare_dns_record.this["www"].ttl == 300 && cloudflare_dns_record.this["www"].proxied == false
    error_message = "ttl must default to 300 and proxied to false."
  }

  assert {
    condition     = cloudflare_dns_record.this["api"].proxied == true && cloudflare_dns_record.this["txt"].comment == "spf"
    error_message = "proxied and comment must pass through."
  }

  assert {
    condition     = cloudflare_dns_record.this["www"].zone_id == var.zone_id
    error_message = "zone_id must be applied to every record."
  }
}

run "test_trailing_dot_stripped" {
  command = plan

  variables {
    records = {
      validation = { name = "_abc.example.com.", type = "CNAME", content = "_xyz.acm-validations.aws." }
    }
  }

  assert {
    condition     = cloudflare_dns_record.this["validation"].name == "_abc.example.com"
    error_message = "Trailing dot must be stripped from name."
  }

  assert {
    condition     = cloudflare_dns_record.this["validation"].content == "_xyz.acm-validations.aws"
    error_message = "Trailing dot must be stripped from content."
  }
}

run "test_create_false_plans_nothing" {
  command = plan

  variables {
    create = false
  }

  assert {
    condition     = length(cloudflare_dns_record.this) == 0
    error_message = "No records may be planned when create is false."
  }

  assert {
    condition     = output.id == null && output.name == null
    error_message = "id and name must be null when create is false."
  }
}

run "test_type_validation" {
  command = plan

  variables {
    records = {
      bad = { name = "bad.example.com", type = "FOO", content = "x" }
    }
  }

  expect_failures = [var.records]
}

run "test_ttl_validation" {
  command = plan

  variables {
    records = {
      bad = { name = "bad.example.com", type = "A", content = "192.0.2.1", ttl = 30 }
    }
  }

  expect_failures = [var.records]
}

run "test_mx_priority_passed" {
  command = plan
  variables {
    records = {
      mx = { name = "mail.example.com", type = "MX", content = "feedback-smtp.us-east-1.amazonses.com", priority = 10 }
    }
  }
  assert {
    condition     = cloudflare_dns_record.this["mx"].priority == 10
    error_message = "MX priority must be passed to the record."
  }
}

run "test_priority_required_for_mx" {
  command = plan
  variables {
    records = { mx = { name = "mail.example.com", type = "MX", content = "feedback-smtp.us-east-1.amazonses.com" } }
  }
  expect_failures = [var.records]
}

run "test_priority_rejected_for_other_types" {
  command = plan
  variables {
    records = { www = { name = "www.example.com", type = "CNAME", content = "example.com", priority = 10 } }
  }
  expect_failures = [var.records]
}

run "test_priority_range_validation" {
  command = plan
  variables {
    records = { mx = { name = "mail.example.com", type = "MX", content = "mx.example.com", priority = 70000 } }
  }
  expect_failures = [var.records]
}
