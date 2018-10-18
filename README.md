# outPorts-bash
A little script to test a range of outgoing ports using http://portquiz.net/

# Description
This script is made to test a range of outgoing ports using an external server.
By default, it's done using http://portquiz.net/ from port 1 to 65535

# Usage
* -c 		: Use with curl
* -w 		: Use with wget
* -b <num>	: First port in the range (Default 1)
* -e <num>	: Last port in the range (Default 65535)

Beginning port must be smaller than Ending port

# Tuning
A list of forbidden ports is written in the script and is relative to used ports on portquiz. This list can be manually changed if the script is used on another server.
