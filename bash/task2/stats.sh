#!/bin/bash

# log file coming as a parameter
log_file=$1

# Part 1: find IP address that requests the most
mostReqIP() {
	declare -A ip_dict=$( ipDictionary ) # See line 49
	local req=0
	local mostIP=""

	for key in ${!ip_dict[@]}; do 					# Goes through the all unique IP addresses
		if [[ ${ip_dict[$key]} -ge $req ]]; then	# and define the most requested address,
			mostIP=$key								# number of requests.
			req=${ip_dict[$key]}
		fi
	done

	echo "Highest request number from: 	$mostIP ($req requests)"	# Prints out the solution.
}

# Part 2: find the most requested page in log file
mostReqPage() {
	declare -A page_dict=$( pageDictionary )
	local req=0
	local mostPage=""

	for key in ${!page_dict[@]}; do						# Goes through the all unique pages,
		if [[ ${page_dict[$key]} -ge $req ]]; then		# and define the most requested
			mostPage="$key"								# similarly to the solution with IP addresses.
			req=${page_dict[$key]}
		fi
	done

	echo "Most requested page:	$mostPage ($req requests)"		# Prints out the solution.
}

# Part 3: prints all IP adderesses with number of requests
reqFromEachIP() {
	declare -A ip_dict=$( ipDictionary )

	echo "Number of requests from each IP address:"		# Goes through the dictionary as you've may
														# seen in first task, but instead of find the most requests	
	for key in ${!ip_dict[@]}; do						# it just prints all the keys and values
		echo "  $key    (${ip_dict[$key]} requests)"
	done
}

# This function returns a dictionary of IP addresses as a key and requests as a value.
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

# This function works sismilarly to the ipDictionary()
pageDictionary() {						
	declare -A page_dict

	while read -r line; do
		key=$(echo $line | awk '{print $2}')
		value=$(echo $line | awk '{print $1}')
		page_dict[$key]=$(($value))
	done < <(awk '{print $7}' $log_file | sed 's/\"//g' | sort | uniq -c)

	echo "("
	for key in ${!page_dict[@]}; do
		echo "[$key]=${page_dict[$key]}"
	done
	echo ")"
}

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

# Part 6: find bots in log file.
# At this point I wanted to experiment with awk
# and I tried to write this function using only awk and grep.
bots() {
	echo "Search bots:"
	grep '(compatible;.*)' $log_file | awk '{for (i = 2; i <= 13; ++i) $i=""; print $0}' | grep '[Bb]ot' | awk '{print $1" "$(NF-1)" - "$NF}' | sort | uniq  
}

mostReqIP
echo
mostReqPage
echo
reqFromEachIP
echo
nonExistPages
echo
mostVisitedTime
echo
bots