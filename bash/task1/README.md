# Task 1

## Requirements
- When starting without parameters, it will display a list of possible keys and their description. 
- The **--all** key displays the IP addresses and symbolic names of all hosts in the current subnet 
- The **--target** key displays a list of open system TCP ports.

---

## Solution

To manage functions I used switch case.

``` bash
case $1 in
	"")
		echo "You need to specify command:"
		echo "	--all - displays the IP addresses and symbolic names of all hosts in the current subnet."
		echo "	--target - displays a list of open system TCP ports."
		;;
	"--all")
		listAllHosts
		;;
	"--target")
		listAllTcpPorts
		;;
esac	
```

Function **listAllHosts()** using ARP as a foundation to look for all hosts in current subnet and awk prints only IP address and host name.

``` bash
function listAllHosts() {
	echo "All hosts in subnet:"
	arp -a | awk '{print $1"  "$2}'
}
```

Function **listAllTcpPorts()** using Netstat and looking only for listening tpc ports.

``` bash
function listAllTcpPorts() {
	echo "Open TCP ports:"
	netstat -lnt
} 
```

---

## Output example

```
./locnet.sh

You need to specify command:
        --all - displays the IP addresses and symbolic names of all hosts in the current subnet.
        --target - displays a list of open system TCP ports.
-----------------------------------------------------------------------------

./locnet.sh --all

All hosts in subnet:
maxmlv.mshome.net  (172.17.0.1)
-----------------------------------------------------------------------------

./locnet.sh --target

Open TCP ports:
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 127.0.0.1:33533         0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:36393         0.0.0.0:*               LISTEN 
-----------------------------------------------------------------------------
```