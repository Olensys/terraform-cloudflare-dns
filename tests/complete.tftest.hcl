# Run only by the integration workflow, against a real Cloudflare token
# (CLOUDFLARE_API_TOKEN) and a zone supplied through TF_VAR_zone_id; the records
# are created under the example's default zone_domain and destroyed afterwards.
run "apply_minimal" {
  command = apply

  module {
    source = "./examples/minimal"
  }

  assert {
    condition     = length(output.record_ids) == 3
    error_message = "The example should create three records."
  }
}
