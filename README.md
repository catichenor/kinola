# autokeyboard

## What is this?

This is an Arduino sketch combined with various scripts, which effectively turn an Arduino Yún into a wifi- or ethernet-connected programmable keyboard. From another computer, you can effectively do almost anything that you can do on a keyboard. 

Each script provides a different interface to allow you to easily send lines of text, or use a simple macro language to send specific keyboard commands.

To use this, you'll need the following hardware:

* An Arduino Yún
* A micro-USB cable, or mini-USB cable with a micro adapter
* A USB 2.0-capable computer capable of providing 5V of power, which should be any computer made after 2002
* Another computer with wifi or ethernet capability
* Optional:
	* A case for the Arduino Yún
	* An Ethernet cable
	
Software-wise, if you have a Mac or a Linux PC, you should have everything you need to connect the Arduino.

## How to install the sketch

1. Install the [Arduino 1.5-series IDE software](http://arduino.cc/en/main/software#toc3), currently in beta.
	* If you're on Linux, it's best to install your distro's packaged version of the Arduino IDE first, which should contain the dependencies for the beta.
2. Download the *autokeyboard.ino* sketch by right-clicking on [this link](https://github.com/catichenor/autokeyboard/raw/master/autokeyboard.ino) and saving the linked file to your "Downloads" folder or wherever you'd like to put it.
3. Plug the Arduino into a computer via USB, plugging the micro-USB cable into the Arduino, and the other side of the USB cable into the computer.
	* If you're on Windows, you'll need to install the Arduino driver before the Arduino can be used as a keyboard.
	* Preferably, you should connect the Yun to another computer
4. Set up the Arduino on your wifi network as documented [here](http://arduino.cc/en/Guide/ArduinoYun#toc13).
	* Ethernet setup instructions are [here](http://arduino.cc/en/Guide/ArduinoYun#toc15).
	* To access the device more easily, turn off password access to the REST API on the configuration page. Note that your commands probably can be sniffed even if you turn on the password access.
5. Launch the Arduino Beta IDE software.
	* This will need to be done via command-line on Linux.
6. Go to **File -> Open**, navigate to where you saved the *autokeyboard.ino* file, and open it.
7. In the IDE, go to the **Tools** menu, then go to the **Board** submenu, and select **Arduino Yun**
8. Go back to **Tools** menu, then to the **Port** menu, and select the port that contains the Arduino's IP address that you found in step 3.
	* If you did not change the Yun's defaults, the menu item should read **Arduino at 192.168.240.1 (Arduino Yun)**
9. Click on the Upload command (the icon containing a right arrow below the window's title/menu bar).
10. The script should now be loaded. To test that it's working, go to a web browser, and enter the following web address and hit return: http://arduino.local/arduino/wait/5	
	* No page will load, but a red LED on the Arduino should light up for 5 seconds.
	* This address assumes that you haven't changed the Arduino Yun's name. If you have, use that address instead of *arduino.local*.

## How to use the scripts

### Python script: autokeyboard.py

With the autokeyboard.py script, you can send lines of text to a remote computer with the following syntax:

`python autokeyboard.py [ip.address] 'Hello, World!'`

You must enter the numeric IP address of the Arduino; the zeroconf ".local" name is not understood by python.

## Warning

This tutorial assumes that you have not applied a password to the REST API of the Yun. Even if you have, other people on your network will probably be able to read the commands that you send. Do not send sensitive data to the Yun.

Also, anyone else on your network (including someone far away with a strong enough wifi antenna) will be able to send remote commands to the machine that currently has the Yun connected.
