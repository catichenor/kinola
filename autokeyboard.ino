/*
 AutoKeyboard control sketch

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

 http://github.com/catichenor/autokeyboard

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
  Serial.begin(9600);

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

void typeCommand(YunClient client) {
  String entry = client.readStringUntil('\r');

  digitalWrite(13, HIGH);
  Keyboard.begin();
////  Serial.println(entry);
  delay(1000);
  Keyboard.end();
  digitalWrite(13, LOW);
}

void keysCommand(YunClient client) {
  int delimiter;
  String command;
  char action;
  String key;
  Keyboard.begin();
  String entry = client.readStringUntil('\r');
  String message = entry;
//  Serial.println(entry);//h131/pa/r-1
  do {
  //  delay(2000);
    delimiter = message.indexOf('/');
    if(delimiter != -1) {
      command = message.substring(0,delimiter);
//      Serial.println(command);//h131
      action = command.charAt(0);
//      Serial.println(action);//h
      key = command.substring(1,command.length());
//      Serial.println(key);//131
      message = message.substring(delimiter+1, message.length());
//      Serial.println(message); //pa/r-1 
      keySequence(action,key);
    }
    else {
      if (message.length() > 0) {
        action = message.charAt(0);
//        Serial.println(action);
        key = message.substring(1,message.length());
//        Serial.println(key);
        keySequence(action,key);
      }
    }
    delay(200);   
  }
  while(delimiter >=0);
  Keyboard.end();
}

void waitCommand(YunClient client) {
  int secs;

  // Read seconds
  secs = client.parseInt();

  secs = secs * 1000;
  
  digitalWrite(13, HIGH);
  delay(secs);
  digitalWrite(13, LOW);
}

void keySequence(char theAction, String theKey) {
  char thisKey;
  boolean releaseKeys = false;
  
  // If the key is 3 characters, it's a number for a special key.
  if(theKey.length() == 3) {
    thisKey = theKey.toInt();
//    Serial.println(thisKey);
  }
  // If the key is 1 character, read the key directly.
  else if(theKey.length() == 1) {
    thisKey = theKey.charAt(0);
//    Serial.println(thisKey);
  }
  // Otherwise, release all the keys.
  else {
    Keyboard.releaseAll();
  }
  
  if(releaseKeys) {
//    Serial.println("Releasing keys");
  }
  if(theAction == 'h') {
    Keyboard.press(thisKey);
  }
  if(theAction == 'p') {
    Keyboard.write(thisKey);
//    Serial.print("Pressing ");
//    Serial.println(thisKey);
  }
  if(theAction == 'r') {
    Keyboard.release(thisKey);
//    Serial.print("Releasing ");
//    Serial.println(thisKey);
  }
}
