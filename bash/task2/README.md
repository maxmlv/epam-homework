# Task 2

## Requirements 

1. From which ip were the most requests? 
2. What is the most requested page? 
3. How many requests were there from each ip? 
4. What non-existent pages were clients referred to?  
5. What time did site get the most requests?
6. What search bots have accessed the site? (UA + IP)

---

## Solution

Since every line in logs has a similar structure I primarerly used **awk** to pick values that I need and stored them in dictionary. 

This is for IP addresses for example:

``` bash
ipDictionary() {										
    declare -A ip_dict									
														
    while read -r line; do								
        key=$(echo $line | awk '{print $2}')			 
		value=$(echo $line | awk '{print $1}')
		ip_dict[$key]=$(($value))
    done < <(awk '{print $1}' $log_file | sort | uniq -c)	# unic -c - returns filter repeated lines and number of repeats

	echo "("
	for key in ${!ip_dict[@]}; do
		echo "[$key]=${ip_dict[$key]}"
	done
	echo ")"
}
```

So every ditionary has a similar purpose in code. Key is a what I need for part of the task and value is a number of how many times does this repeats.

In the fourth part of the task I focused on the HTTP Status code 302 to see all the pages that are not exist anymore or moved to the different path.

``` bash
# Part 4: find pages that don't exist 
nonExistPages() {
	declare -A ne_pages							# Goes thourgh the log file, grep 302 status code
												# and prints out all the pages.
	while read -r line; do
		key=$(echo $line | awk '{print $2}')
		value=$(echo $line | awk '{print $1}')
		ne_pages[$key]=$(($value))
	done < <(grep 302 $log_file | awk '{print $7}' | sort | uniq -c)

	echo "Pages that not exists: "
	for key in ${!ne_pages[@]}; do
		echo "  $key"
	done
}
```

To find the busiest time that each site had I wrote an algorythm where main loop goes through each unique site and inside that loop it has another loop that goes through the all time that site had requested and find the most repeated and gives most requested time as a value for the dictionary where site is a key.

``` bash
# Part 5: find the most busy time each site had 
mostVisitedTime() {
	# create dictionary similarly to IPs and pages 
	declare -A site_dict

	while read -r site; do
		# create dictionary of time for a specific site 
    	declare -A time_dict
    	while read -r t; do
        	key=$(echo $t | awk '{print $2}')
        	value=$(echo $t | awk '{print $1}')
        	time_dict[$key]=$(($value))
				# returns <how many repeats> <data and time> 
    	done < <(grep $site $log_file | awk '{print $4}' | cut -c 2- | sort | uniq -c)

		# goes through time dictionary and define time that have repeated the most
    	most_time=0
    	for key in ${!time_dict[@]}; do
        	if [[ ${time_dict[$key]} -gt $most_time ]]; then
            	site_dict[$site]=$key
            	most_time=${time_dict[$key]}
       		fi
    	done
	# grep all unique sites
	done < <(grep -Eo "(http|https)://[a-zA-Z0-9.]*" $log_file | sort | uniq)

	# prints out the solution
	echo "Most visited time per site:"
	for key in ${!site_dict[@]}; do
		echo "  $key	${site_dict[$key]}"
	done
}
```

Solution for the last part of the task I experimented for a bit and tried to write it in the one command.

``` bash
# Part 6: find bots in log file.
# At this point I wanted to experiment with awk
# and I tried to write this function using only awk and grep.
bots() {
	echo "Search bots:"
	grep '(compatible;.*)' $log_file | awk '{for (i = 2; i <= 13; ++i) $i=""; print $0}' | grep '[Bb]ot' | awk '{print $1" "$(NF-1)" - "$NF}' | sort | uniq  
}
```

---
## Output example

Using [apache_logs.txt](apache_logs.txt)
```

Highest request number from:    157.55.39.250 (62 requests)

Most requested page:    /sitemap1.xml.gz (8 requests)

Number of requests from each IP address:
  213.87.151.38    (1 requests)
  217.69.134.29    (2 requests)
  157.55.39.174    (4 requests)
  217.69.134.11    (1 requests)
  217.69.134.13    (1 requests)
  217.69.134.12    (1 requests)
  93.158.178.129    (1 requests)
  217.69.134.15    (1 requests)
  157.55.39.250    (62 requests)
  157.55.39.182    (2 requests)
  5.255.253.74    (1 requests)
  95.108.158.190    (1 requests)
  217.69.134.39    (1 requests)
  66.249.78.72    (1 requests)
  66.249.69.39    (1 requests)
  66.249.78.58    (2 requests)
  37.140.141.30    (3 requests)
  46.29.2.62    (61 requests)
  176.59.119.104    (7 requests)
  178.76.227.154    (10 requests)
  5.255.253.45    (1 requests)
  66.249.78.65    (1 requests)
  185.53.44.186    (1 requests)
  207.46.13.48    (34 requests)

Pages that not exists: 
  /vote/1279
  /vote/1353

Most visited time per site:
  http://example.com    30/Sep/2015:00:42:46
  http://www.google.com 30/Sep/2015:02:25:52
  http://www.xovibot.net        30/Sep/2015:02:25:52
  http://www.bing.com   30/Sep/2015:02:25:52
  http://yandex.com     30/Sep/2015:02:25:52
  https://www.google.ru 30/Sep/2015:00:42:46
  http://go.mail.ru     30/Sep/2015:00:42:46

Search bots:
157.55.39.174 bingbot/2.0; - +http://www.bing.com/bingbot.htm)"
157.55.39.182 bingbot/2.0; - +http://www.bing.com/bingbot.htm)"
157.55.39.250 bingbot/2.0; - +http://www.bing.com/bingbot.htm)"
157.55.39.250 bingbot/2.0; - +http://www.bing.com/bingbot.htm)"
185.53.44.186 XoviBot/2.0; - +http://www.xovibot.net/)"
207.46.13.48 bingbot/2.0; - +http://www.bing.com/bingbot.htm)"
207.46.13.48 bingbot/2.0; - http://www.bing.com/bingbot.htm)"
217.69.134.11 Mail.RU_Bot/Fast/2.0; - +http://go.mail.ru/help/robots)"
217.69.134.12 Mail.RU_Bot/Fast/2.0; - +http://go.mail.ru/help/robots)"
217.69.134.13 Mail.RU_Bot/Fast/2.0; - +http://go.mail.ru/help/robots)"
217.69.134.15 Mail.RU_Bot/Fast/2.0; - +http://go.mail.ru/help/robots)"
217.69.134.29 Mail.RU_Bot/Fast/2.0; - +http://go.mail.ru/help/robots)"
217.69.134.39 Mail.RU_Bot/Fast/2.0; - +http://go.mail.ru/help/robots)"
37.140.141.30 YandexBot/3.0; - +http://yandex.com/bots)"
5.255.253.45 YandexBot/3.0; - +http://yandex.com/bots)"
5.255.253.74 YandexBot/3.0; - +http://yandex.com/bots)"
66.249.69.39 Googlebot/2.1; - +http://www.google.com/bot.html)"
66.249.78.58 Googlebot/2.1; - +http://www.google.com/bot.html)"
66.249.78.58 Mediapartners-Google/2.1; - +http://www.google.com/bot.html)"
66.249.78.65 Googlebot/2.1; - +http://www.google.com/bot.html)"
93.158.178.129 YandexBot/3.0; - +http://yandex.com/bots)"
95.108.158.190 YandexBot/3.0; - +http://yandex.com/bots)"
```