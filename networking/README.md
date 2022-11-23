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

>Unfortunately I don't have an opportunity to configure static routes on my Wi-Fi router, I already changed __Briged Network__ to __NAT__ and setted up __NAT__ service on __Server-1__ for __Client-1__ and __Client-2__ machines. (Step 8 of this task)
 
After interfaces have been configured changes to interfaces in __netplan__ YAML file, we can apply changes with:

```
sudo netplan apply
```

This is will also restart network service.

2. Set up DHCP server on Server-1 which will configure IP addresses Int1 for Client-1 and Client-2.

__/etc/dhcp/dhcpd.conf__

![Server-1 DHCP server](server_1_dhcp_config.png)

__/etc/default/isc-dhcp-server__

![Server-1 DHCP interfaces](server_1_dhcp_interfaces.png)

__Client-1__

![Client-1 IP addresses](client_1_ips.png)

__Client-2__

![Client-2 IP addresses](client_2_ips.png)

3. With __ping__ and __traceroute__ commands check the connection between virtual machines.

__Server-1__

![Server-1 ping check](server_1_ping.png)

__Client-1__

![Client-1 ping check](client_1_ping.png)

__Client-2__

![Client-2 ping check](client_2_ping.png)

4. Initialize two IP addresses __172.17.D+10.1/24__ and __172.17.D+20.1/24__ to __lo__ interface on __Client-1__. Configure routing on __Client-2__ machine that way: 

__Client-2 -> Server-1 -> 172.17.D+10.1__

__Client-2 -> Net4 -> 172.17.D+20.1__

First of all I added addresses to __lo__ interface.

![Client-1 lo interfate](client_1_lo_ips.png)

### Configuration of routing from __Client-2__ to __172.17.D+10.1/24__

Adding route from __Client-2__ to __Server-1__:

![Client-2 route to Server-1](route_c2_s1.png)

From __Server-1__ adding route for __172.17.13.0/24__ to __Client-1__:

![Server-1 route to Client-1](route_s1_c1.png)

Test connection and check traceroute from __Client-2__:

![Client-2 check routes via Server-1](traceroute_c2_s1.png)

### Configuration of routing from __Client-2__ to __172.17.D+20.1/24__

Adding route from __Client-2__ to __Client-1__ via __Net4__ network:

![Client-2 route via Net4](route_c2_net4.png)

Test connection:

![Client-2 checks via Net4](traceroute_c2_net4.png)

5. Calculate summarizing for networks __172.17.13.0/24__ and __172.17.23.0/24__. Configure routing for summarized network via __Server-1__.

Summarizing:

![Summarizing](summarizing_v2.png)

Replacing old IP addresses in __lo__ interface with new in summarized network:

![Client-1 summ IP addresses](summ_ip_c1.png)

Configuring route for to summarized network __172.17.0.0/19__ via __Server-1__

__Client-2 route__

![Client-2 route to summ](summ_route_c2_s1.png)

__Server-1 route__

![Server-1 route to summ](summ_route_s1_c1.png)

Check connection with ping and traceroute from __Client-2__ to __172.17.0.0/19__ network:

![Client-2 summ check](summ_traceroute_c2.png)