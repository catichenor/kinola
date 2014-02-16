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

This will print `Hello, World!` on the computer that has the Yun attached. Note that when sending text to a remote computer in this fashion, there will always be a return/enter that will be performed after the text is typed.

If you'd like to send specific keys, such as the Control key, F2, or Tab, you can use the `-c` switch to send a keyboard macro. For example:

`python autokeyboard.py [ip.address] 'h128/h130/p212/r-1'`

This sends the familiar DOS/Windows "three finger salute" a.k.a. the Control-Alt-Delete command to the Arduino-connected computer. 

#### Breaking this down:

* `h128` means "hold down the 128th character". Character 128 is understood by the Arduino as the "Left Control" key.
* `/` is used as a separator for each key command.
* `h130` means "hold down the 130th character". Character 130 is the "Left Alt" key.
* `p212` means "press (and release) the 212th character". Character 212 is the "Delete" key.
* `r-1` means "release all keys".

Alternatively, you could use `/r128/r130` at the end of the command instead of `r-1` to release the "Control" and "Alt" keys.

You can also send single keys to the Arduino, i.e. `pa/pb/pc/p1/p2/p3` sends "abc123". This won't work for some keys, such as `%` and `/`, so you can use the equivalent ASCII key code.

A table of ASCII key codes is here:
<http://www.asciitable.com>

An list of Arduino key codes above 127 is available here: <http://arduino.cc/en/Reference/KeyboardModifiers>

#### 

You can use a combination of these commands in succession to operate a computer remotely. An example of this sort of usage is included in the `exampleScript.sh` script.

#### Limitations: 

Sending mouse commands isn't possible with the Arduino sketch, and the communication with the remote computer is strictly one-way; you can send commands, but you won't receive the results through the Arduino.

For this script, you must enter the numeric IP address of the Arduino; the zeroconf ".local" name is not understood by Python's urllib. If you have a name server, that assigned address will probably work.

### Javascript/HTML: autokeyboard.html

You can open this file in a web browser and use it to send text or key commands to the Yun, using a more friendly GUI interface. It's more of a proof-of-concept at this point than a useful tool. 

You can enter text in the first field, and send it to the remote computer, or you can enter key commands in the second field.	This script does have the advantage that it will be able to send commands to a zeroconf ".local" address if your computer supports it.

### Future Possibilities:

* Arduino Sketch:
	* Ability to save and recall commands
	* Feedback on command success/fail
* Javascript/HTML:
	* Command history
	* Recording and playing back a sequence of commands as a script
	* Import/export of scripts
* Python:
	* Adding Zeroconf.
	* Checking for success after sending a command.																																																																																																																																																																																																																																																																																																																								

## Warning

This document assumes that you have not applied a password to the REST API of the Yun. Even if you have, other people on your network will probably be able to read the commands that you send. Do not send sensitive data to the Yun.

Also, anyone else on your network (including someone far away with a strong enough wifi antenna) will be able to send remote commands to the machine that currently has the Yun connected.
