
output "key" {
    value = tls_private_key.my_key.private_key_pem
}