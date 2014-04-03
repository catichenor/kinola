/*
 Kinola control sketch

 This sketch sets up an Arduino Yun to be a web server that listens
 for a url, and types whatever is in that url.

 Possible commands created in this shetch:

 * "/arduino/type/hello%20world"      -> types "hello world" as a   
                                         keyboard through the USB port
                                         on a connected computer.
 * "/arduino/keys/h128/h130/p212/r-1" -> holds the Left Control key, 
                                         then holds the Left Alt key,
                                         then presses the Delete key, 
                                         then releases all keys
 * "/arduino/wait/10                  -> turns on the LED, waits 
                                         10 seconds, then turns the
                                         LED off
                                        
 For additional reference on Key Codes 
 (used for the keys function) see:
 http://arduino.cc/en/Reference/KeyboardModifiers

 This project has been uploaded to:

 http://github.com/catichenor/kinola

 */

#include <Bridge.h>
#include <YunServer.h>
#include <YunClient.h>

// Listen on default port 5555, the webserver on the Yun
// will forward there all the HTTP requests for us.
YunServer server;

void setup() {
  // Bridge startup
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  Bridge.begin();

  // Listen for incoming connection only from localhost
  // (no one from the external network could connect)
  server.listenOnLocalhost();
  server.begin();
}

void loop() {
  // Get clients coming from server
  YunClient client = server.accept();

  // There is a new client?
  if (client) {
    // Process request
    process(client);

    // Close connection and free resources.
    client.stop();
  }

  delay(50); // Poll every 50ms
}

void process(YunClient client) {
  // read the command
  String command = client.readStringUntil('/');

  // is "type" command?
  if (command == "type") {
    typeCommand(client);
  }  
  
  // is "keys" command?
  if (command == "keys") {
    keysCommand(client);
  }

  // is "wait" command?
  if (command == "wait") {
    waitCommand(client);
  }
}

void typeCommand(YunClient client) { //For sending out a line of text.
  String entry = client.readStringUntil('\r');

  digitalWrite(13, HIGH);   //Indicate the beginning of processing.
  Keyboard.begin();         //Startup the keyboard interface
  Keyboard.println(entry);  //Print out whatever is in the URL (must be URI encoded first)
  delay(1000);              //Wait one second.
  Keyboard.end();           //Close the keyboard interface.
  digitalWrite(13, LOW);    //Indicate the end of processing.
}

void keysCommand(YunClient client) {              //For sending out specific key sequences.
  int delimiter;                                  //Marks where to split the sequence
  String command;                                 //The current command (ex. p128 = press Left Ctrl)
  char action;                                    //The action (h=Hold, r=Release, p=Press and Release)
  String key;                                     //A single letter/number, or, if 3 numbers,
                                                  //the char decimal value (ex. 128 = Left Ctrl),
                                                  //otherwise, all keys are released.
  Keyboard.begin();                               //Startup the keyboard interface
  String entry = client.readStringUntil('\r');    //Marks the end of the string
  String message = entry;                         //Contains what's left of the message during processing

  do {                                                             //Repeat
    delimiter = message.indexOf('/');                              //Find the "/" separator
    if(delimiter != -1) {                                          //If there's still a delimiter,
      command = message.substring(0,delimiter);                    //grab the text before the delimiter.
      action = command.charAt(0);                                  //The action is the first character,
      key = command.substring(1,command.length());                 //the key is the rest of the entry.
      message = message.substring(delimiter+1, message.length());  //Remove the first part of the message
      keySequence(action,key);                                     //then perform the action on the key.
    }
    else {                                                         //otherwise,
      if (message.length() > 0) {                                  //If there's no delimiter left,
        action = message.charAt(0);                                //get the action,
        key = message.substring(1,message.length());               //and the key from "message" itself,
        keySequence(action,key);                                   //then perform the action on the key.
      }
    }
    delay(200);                                                    //Simulate 60 wpm.
  }
  while(delimiter >=0);                           //end loop
  Keyboard.end();                                 //release the keyboard
}

// This is here for testing.
void waitCommand(YunClient client) {
  int secs;

  // Read seconds
  secs = client.parseInt();          //Parses the number of seconds,

  secs = secs * 1000;                //then multiplies that by 1000 ms.
  
  digitalWrite(13, HIGH);            //Turn on the light
  delay(secs);                       //for the specified number of seconds
  digitalWrite(13, LOW);             //then turn it off.
}

void keySequence(char theAction, String theKey) {
  char thisKey;                     //The specified key as a char.
  boolean releaseKeys = false;
  
  // If the key is 3 characters, it's a number for a special key.
  if(theKey == "-1") {
    Keyboard.releaseAll();          //Code to release all keys
  }
  // If the key is 1 character, read the key directly.
  else if(theKey.length() == 1) {
    thisKey = theKey.charAt(0);     //Translate the single character as a key. 
  }                                 //This won't work for characters that don't encode properly into URLs.
  // If the key is 2 or 3 characters, translate to an ASCII keycode.
  else if(theKey.length() <=3){     //This should allow the use of 
    thisKey = theKey.toInt()        //of URL untranslatable characters.
  }
  else {                            //This shouldn't happen.
    Keyboard.releaseAll();          //Release all keys, just to be safe.
  }
  
  if(theAction == 'h') {      //if "h", hold the key
    Keyboard.press(thisKey);
  }
  if(theAction == 'p') {      //if "p", press and release the key
    Keyboard.write(thisKey);
  }
  if(theAction == 'r') {      //if "r", release the key
    Keyboard.release(thisKey);
  }
}
