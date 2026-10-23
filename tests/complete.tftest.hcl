# Run only by the nightly integration workflow, against a real Cloudflare token
# (CLOUDFLARE_API_TOKEN) and a zone supplied through TF_VAR_zone_id.
run "apply_minimal" {
  command = apply

  module {
    source = "./examples/minimal"
  }
}
