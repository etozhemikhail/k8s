resource "yandex_vpc_network" "k8s-network" {
    name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet" {
    for_each = var.subnets
    name = each.key
    zone = each.value["zone"]
    network_id = yandex_vpc_network.k8s-network.id
    v4_cidr_blocks = [each.value["cidr"]]
}