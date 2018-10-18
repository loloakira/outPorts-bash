# outPorts-bash
A little script to test a range of outgoing ports using portquiz
# Usage
-c 		: Use with curl
-w 		: Use with wget
-b <num>	: First port in the range (Default 1)
-e <num>	: Last port in the range (Default 65535)

Beginning port must be smaller than Ending port

# Tuning
A list of forbidden ports is written in the script and is relative to used ports on portquiz. This list can be manually changed if the script is used on another server. 
