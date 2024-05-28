resource "yandex_dns_recordset" "rs-web" {
  zone_id = var.dns_zone_id
  name    = "etozhedevops.ru."
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr-web.external_ipv4_address[0].address}"]
}

resource "yandex_dns_recordset" "rs-grafana" {
  zone_id = var.dns_zone_id
  name    = "k8s.etozhedevops.ru."
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr-k8s.external_ipv4_address[0].address}"]
}