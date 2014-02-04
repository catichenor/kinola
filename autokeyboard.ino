/*
 AutoKeyboard control sketch

 This sketch sets up an Arduino Yun to be a web server that listens
 for a url, and types whatever is in that url.

 Possible commands created in this shetch:

 * "/arduino/type/hello%20world"     -> types "hello world" as a   
                                        keyboard through the USB port
                                        on a connected computer.
 * "/arduino/wait/10                 -> turns on the LED, waits 
                                        10 seconds, then turns the
                                        LED off

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

  // is "wait" command?
  if (command == "wait") {
    waitCommand(client);
  }
}

void typeCommand(YunClient client) {
  String entry = client.readStringUntil('\r');

  digitalWrite(13, HIGH);
  Keyboard.begin();
  Keyboard.println(entry);
  delay(1000);
  Keyboard.end();
  digitalWrite(13, LOW);
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
