# EPAM Homework: Networking

![Network schema](network_vm_plan.png)

## Subnets:
- Net1 - 192.168.3.0/24
- Net2 - 10.99.3.0/24
- Net3 - 10.2.99.0/24
- Net4 - 172.16.3.0/24

---
## Task

1. Configure static IP addresses on all network interfaces for Server-1.

As you might see, __Server-1__ is running on Ubuntu. This is give a way to configure settings for network interfaces with __netplan__ starting with __Ubuntu 17.10 Artful__.

__/etc/netplan/*.yaml__
![Server-1 interfaces](server_1_interfaces.png)

After interfaces have been configured changes to interfaces in __netplan__ YAML file, we can apply changes with:

```
sudo netplan apply
```

This is will also restart network service.

2. Set up DHCP server on Server-1 which will configure IP addresses Int1 for Client-1 and Client-2.

/etc/dhcp/dhcpd.conf
![Server-1 DHCP server](server_1_dhcp_config.png)

/etc/default/isc-dhcp-server
![Server-1 DHCP interfaces](server_1_dhcp_interfaces.png)

Client-1
![Client-1 IP addresses](client_1_ips.png)
Client-2
![Client-2 IP addresses](client_2_ips.png)

