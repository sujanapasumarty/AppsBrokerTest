// API token for IEX cloud
resource "kubernetes_secret" "iex_cred" {
  metadata {
    name = "iex-cred"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }
  data = {
    username = "admin"
    password = "P4ssw0rd"
    //"token" = var.api_key
  }
} 

resource "kubernetes_certificate_signing_request" "example" {
  metadata {
    name = "example"
  }
  spec {
    usages  = ["client auth", "server auth"]
    request = <<EOT
-----BEGIN CERTIFICATE REQUEST-----
MIHSMIGBAgEAMCoxGDAWBgNVBAoTD2V4YW1wbGUgY2x1c3RlcjEOMAwGA1UEAxMF
YWRtaW4wTjAQBgcqhkjOPQIBBgUrgQQAIQM6AASSG8S2+hQvfMq5ucngPCzK0m0C
ImigHcF787djpF2QDbz3oQ3QsM/I7ftdjB/HHlG2a5YpqjzT0KAAMAoGCCqGSM49
BAMCA0AAMD0CHQDErNLjX86BVfOsYh/A4zmjmGknZpc2u6/coTHqAhxcR41hEU1I
DpNPvh30e0Js8/DYn2YUfu/pQU19
-----END CERTIFICATE REQUEST-----
EOT
  }
  auto_approve = true
}

resource "tls_private_key" "tlskey" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}


//creates secret for the tls cert and key
resource "kubernetes_secret" "tls_cred" {
  metadata {
            name = "tls-cred"
            namespace = kubernetes_namespace.dev.metadata[0].name
          }

          data = {
            #"tls.crt" = file("${path.root}/.tls/revevellidan.com_ssl_certificate.cer")
           // "tls.crt" = var.tls_crt
            "tls.crt"   = kubernetes_certificate_signing_request.example.certificate
            "tls.key" = tls_private_key.tlskey.private_key_pem
            #"tls.key" = file("${path.root}/.tls/_.revevellidan.com_private_key.key")
          }

          type = "kubernetes.io/tls"
}

/* 
Since a private key is a logical resource that lives only in the Terraform state, 
it will persist until it is explicitly destroyed by the user.

In order to force the generation of a new key within an existing state, 
the private key instance can be "tainted":

terraform taint tls_private_key.example
 */