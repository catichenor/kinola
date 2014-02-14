import argparse
import time
import sys

isPython3 = (sys.version_info[0] >= 3)

if isPython3:
	import urllib.parse
	import urllib.request
else:
	import urllib

parser = argparse.ArgumentParser()

parser.add_argument("address", help="IP address of the Arduino Yun")
parser.add_argument("text", help="the text or \(with -c\), the set of commands to send")
parser.add_argument("-c", "--command", action="store_true", help="send as a set of keyboard commands")

args = parser.parse_args()

# If the -c switch is used, interpret the input text as a sequence of commands.

# --- Defining functions ---

def createCommand(python3, address, kind, text):
	if kind == "keys": # Already formatted, no need to convert string
		endURL = "/arduino/keys/" + text
	else: # Needs to be URI encoded
		if python3:
			endURL = "/arduino/type/" + urllib.parse.quote(text) #URI encode the text to be sent in Python 3.x
		else:
			endURL = "/arduino/type/" + urllib.quote(text) #URI encode on Python 2.x
	return "http://" + address + endURL

def sendCommand(python3, url):
	# Put it all together, send the request.
	if python3:
		urllib.request.urlopen(url)
	else:
		urllib.urlopen(url)

# --- End defining functions ---

if args.command: # If sending key commands
	finalURL = createCommand(isPython3,args.address,"keys",args.text)
else: # If sending a line of text
	finalURL = createCommand(isPython3,args.address,"type",args.text)

# Insert a delay for local testing. Commented for instant gratification.
# time.sleep(3)

sendCommand(isPython3,finalURL)
