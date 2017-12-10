output "endpoint" {
  value = "${google_container_cluster.cluster.endpoint}"
}

output "ca_cert_pem" {
  value = "${tls_self_signed_cert.root.cert_pem}"
}

output "tls_key" {
  value = "${tls_private_key.ingress.private_key_pem}"
}

output "tls_cert" {
  value = "${tls_locally_signed_cert.ingress.cert_pem}"
}
