# EPAM Homework: Networking

![Network schema](screenshots/network_vm_plan.png)

[All steps of the task in .pdf file](Task_Linux_Net.pdf)

## Task

1. [Static IP](#static_ips)
2. [DHCP Server](#dhcp_server)
3. [Check connection](#check_conn)
4. [Routing](#routing)
5. [Summarizing](#summarizing)
6. [SSH](#ssh)
7. [Firewall](#firewall)

## Networks:
- Net1 - 192.168.3.0/24
- Net2 - 10.99.3.0/24
- Net3 - 10.2.99.0/24
- Net4 - 172.16.3.0/24

---

1. Configure static IP addresses on all network interfaces for Server-1. <a name="static_ips"></a>

As you might see, __Server-1__ is running on Ubuntu. This is give a way to configure settings for network interfaces with __netplan__ starting with __Ubuntu 17.10 Artful__.

__/etc/netplan/*.yaml__

![Server-1 interfaces](screenshots/server_1_interfaces.png)

>Unfortunately I don't have an opportunity to configure static routes on my Wi-Fi router, I already changed __Briged Network__ to __NAT__ and setted up __NAT__ service on __Server-1__ for __Client-1__ and __Client-2__ machines. (Step 8 of this task)
 
After interfaces have been configured changes to interfaces in __netplan__ YAML file, we can apply changes with:

```
sudo netplan apply
```

This is will also restart network service.

2. Set up DHCP server on Server-1 which will configure IP addresses Int1 for Client-1 and Client-2. <a name="dhcp_server"></a>

__/etc/dhcp/dhcpd.conf__

![Server-1 DHCP server](screenshots/server_1_dhcp_config.png)

__/etc/default/isc-dhcp-server__

![Server-1 DHCP interfaces](screenshots/server_1_dhcp_interfaces.png)

__Client-1__

![Client-1 IP addresses](screenshots/client_1_ips.png)

__Client-2__

![Client-2 IP addresses](screenshots/client_2_ips.png)

3. With __ping__ and __traceroute__ commands check the connection between virtual machines. <a name="check_conn"></a>

__Server-1__

![Server-1 ping check](screenshots/server_1_ping.png)

__Client-1__

![Client-1 ping check](screenshots/client_1_ping.png)

__Client-2__

![Client-2 ping check](screenshots/client_2_ping.png)

4. Initialize two IP addresses __172.17.D+10.1/24__ and __172.17.D <a name="routing"></a> +20.1/24__ to __lo__ interface on __Client-1__. Configure routing on __Client-2__ machine that way: 

__Client-2 -> Server-1 -> 172.17.D+10.1__

__Client-2 -> Net4 -> 172.17.D+20.1__

First of all I added addresses to __lo__ interface.

![Client-1 lo interfate](screenshots/client_1_lo_ips.png)

### Configuration of routing from __Client-2__ to __172.17.D+10.1/24__

Adding route from __Client-2__ to __Server-1__:

![Client-2 route to Server-1](screenshots/route_c2_s1.png)

From __Server-1__ adding route for __172.17.13.0/24__ to __Client-1__:

![Server-1 route to Client-1](screenshots/route_s1_c1.png)

Test connection and check traceroute from __Client-2__:

![Client-2 check routes via Server-1](screenshots/traceroute_c2_s1.png)

### Configuration of routing from __Client-2__ to __172.17.D+20.1/24__

Adding route from __Client-2__ to __Client-1__ via __Net4__ network:

![Client-2 route via Net4](screenshots/route_c2_net4.png)

Test connection:

![Client-2 checks via Net4](screenshots/traceroute_c2_net4.png)

5. Calculate summarizing for networks __172.17.13.0/24__ and __172.17.23.0/24__. Configure routing for summarized network via __Server-1__. <a name="summarizing"></a>

Summarizing:

![Summarizing](screenshots/summarizing_v2.png)

Replacing old IP addresses in __lo__ interface with new in summarized network:

![Client-1 summ IP addresses](screenshots/summ_ip_c1.png)

Configuring route for to summarized network __172.17.0.0/19__ via __Server-1__

__Client-2 route__

![Client-2 route to summ](screenshots/summ_route_c2_s1.png)

__Server-1 route__

![Server-1 route to summ](screenshots/summ_route_s1_c1.png)

Check connection with ping and traceroute from __Client-2__ to __172.17.0.0/19__ network:

![Client-2 summ check](screenshots/summ_traceroute_c2.png)

6. Sett up __ssh__ connection on __Client-1__ and __Client-2__ to __Server-1__ and between each other. <a name="ssh"></a>

After creating keys with __ssh-keygen__ on each machine we need to copy public keys to servers that we want to connect to:

```
[client-1@client-1 ~]$ ssh-copy-id -i client1_key.pub server-1@10.99.3.1
[client-1@client-1 ~]$ ssh-copy-id -i client1_key.pub client-2@172.16.3.2

-------------

client-2@client-2:~$ ssh-copy-id -i client2_key.pub server-1@10.2.99.1
client-2@client-2:~$ ssh-copy-id -i client2_key.pub client-1@172.16.3.1
```

Now we can connect to machines with ssh:

From __Client-1__

![Client-1 to Server-1 ssh](screenshots/ssh_c1_s1.png)

![Client-1 to Client-2 ssh](screenshots/ssh_c1_c2.png)

From __Client-2__

![Client-2 to Server-1 ssh](screenshots/ssh_c2_s1.png)

![Client-2 to Client-1 ssh](screenshots/ssh_c2_c1.png)

7. Configure __Firewall__ on __Server-1__: <a name="firewall"></a>

    - Allow __ssh__ connection from __Client-1__ and deny from __Client-2__.
    - __Client-2__ can connect with __ping__ command to __172.17.D+10.1__, but can't to __172.17.D+20.1__.

__iptables__ configuration on __Server-1__

![Server-1 iptables](screenshots/firewall_server_1.png)

Check __ssh__ connectivity

![Client-1 firewall ssh](screenshots/firewall_c1_ssh.png)

![Client-2 firewall ssh](screenshots/firewall_c2_ssh.png)

Check __ping__ connection

![Client-2 firewall ping](screenshots/firewall_c2_ping.png)