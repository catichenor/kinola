import argparse
import time
import sys

# Python 3 changed urllib, the following code checks for that and imports the correct library

isPython3 = (sys.version_info[0] >= 3) # True/False, is this Python 3?

if isPython3:
	import urllib.parse
	import urllib.request
	urlencoder = urllib.parse
	urlparser = urllib.parse
	urlsender = urllib.request
else:
	import urllib
	import urlparse
	urlencoder = urllib
	urlparser = urlparse
	urlsender = urllib
	
# Set up and parse the arguments

argparser = argparse.ArgumentParser()

argparser.add_argument("address", help="IP address of the Arduino Yun")
argparser.add_argument("text", help="the text or (with -c), the set of key commands to send")
argparser.add_argument("-c", "--command", action="store_true", help="send the text as a set of keyboard commands")

args = argparser.parse_args()

# Fix the input

inputText = args.text

## Remove a leading slash from the input text, if any
if inputText[0] == "/":
	inputText = inputText[1:]

## urlparse should be able to handle different forms of addresses, but depending on how it was entered, it might be in "netloc" or in "path"
IPaddress = (urlparser.urlparse(args.address).netloc + urlparser.urlparse(args.address).path)

# If the -c switch is used, interpret the input text as a sequence of key commands to send directly. Otherwise, URI encode the text.

if args.command:
	outCommand = inputText # Pass the commands directly
	outKind = "keys"
else:
	outCommand = urlencoder.quote(inputText) # URI encode the text to be sent
	outKind = "type"

# Insert a delay for testing, if the Yun is connected to the same machine that is executing the script. This should give enough time to switch to another window. Commented for instant gratification.
#time.sleep(3)

# Put it all together, send the request.
urlsender.urlopen("http://" + IPaddress + "/arduino/" + outKind + "/" + outCommand)
