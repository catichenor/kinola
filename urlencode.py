import urllib
import sys

theOutput = sys.argv[1]
print urllib.quote(theOutput)
