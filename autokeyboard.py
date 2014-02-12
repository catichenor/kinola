import argparse
import urllib
import time

parser = argparse.ArgumentParser()

parser.add_argument("address", help="IP address of the Arduino Yun")
parser.add_argument("text", help="the text or \(with -c\), the set of commands to send")
parser.add_argument("-c", "--command", action="store_true", help="send as a set of keyboard commands")

args = parser.parse_args()

# If the -c switch is used, interpret the input text as a sequence of commands.

if args.command:
	outCommand = args.text #Pass the commands directly
	outKind = "keys"
else:
	outCommand = urllib.quote(args.text) #URI encode the text to be sent
	outKind = "type"

# Insert a delay for local testing. Comment for instant gratification.
#time.sleep(3)

# Put it all together, send the request.
urllib.urlopen("http://" + args.address + "/arduino/" + outKind + "/" + outCommand)

