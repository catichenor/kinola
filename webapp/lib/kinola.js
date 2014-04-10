// Generated by CoffeeScript 1.7.1
(function() {
  var changeField, getRadioValue, quickURL, refreshKeyCommands, timedURL,
    __slice = [].slice;

  window.KeyList = (function() {
    function KeyList() {
      this.LIST_OF_KEYS = [];
    }

    KeyList.prototype.addKeyCommand = function(theKeyCommand) {
      return this.LIST_OF_KEYS.push(theKeyCommand);
    };

    KeyList.prototype.removeKeyCommand = function() {
      return this.LIST_OF_KEYS.pop();
    };

    KeyList.prototype.returnCommands = function(joiner) {
      var outKeys;
      return outKeys = this.LIST_OF_KEYS.join(joiner);
    };

    return KeyList;

  })();

  window.sendCommand = function(kind, form) {
    var IPAddress, InputCommand, delayTime, sendDelay, theURL;
    IPAddress = form.ip_address.value;
    alert("We're getting the IP address: " + IPAddress);
    IPAddress = IPAddress.replace(/https?:\/\//, "");
    sendDelay = true;
    delayTime = 3000;
    if (kind === "type") {
      InputCommand = encodeURIComponent(form.type_command.value);
      InputCommand = InputCommand.replace(/!/g, "%21");
      InputCommand = InputCommand.replace(/'/g, "%27");
      InputCommand = InputCommand.replace(/\(/g, "%28");
      InputCommand = InputCommand.replace(/\)/g, "%29");
      InputCommand = InputCommand.replace(/\*/g, "%2A");
      InputCommand = InputCommand.replace(/\~/g, "%2D");
    }
    if (kind === "keys") {
      InputCommand = form.keys_command.value;
    }
    InputCommand = InputCommand.replace(/^\//, "");
    theURL = "http://" + IPAddress + "/arduino/" + kind + "/" + InputCommand;
    if (sendDelay) {
      timedURL(theURL);
    } else {
      quickURL(theURL);
    }
  };

  timedURL = function(url) {
    var sendRequest;
    setTimeout((sendRequest = function() {
      quickURL(url);
    }), 3000);
  };

  quickURL = function(url) {
    var XMLHttp;
    XMLHttp = new XMLHttpRequest();
    XMLHttp.open("POST", url, true);
    XMLHttp.send();
  };

  window.docElement = function(elementId) {
    return document.getElementById(elementId);
  };

  window.searchForButton = function(e, cmd) {
    if (e.keyCode === 13) {
      docElement(cmd + "_btn").click();
    }
    return false;
  };

  window.enableElement = function(e) {
    docElement(e).disabled = false;
  };

  window.disableElements = function() {
    var itemToDisable, itemsToDisable, _i, _len;
    itemsToDisable = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (_i = 0, _len = itemsToDisable.length; _i < _len; _i++) {
      itemToDisable = itemsToDisable[_i];
      docElement(itemToDisable).disabled = true;
    }
  };

  refreshKeyCommands = function() {
    changeField("short_command", shortKeyList.returnCommands("/"));
    return changeField("long_command", longKeyList.returnCommands(", "));
  };

  window.addToKeys = function() {
    var keyAction, keySelection, keyType, keyValue, longAction, longCommandText, longKeyChar, selectedKeyElement, shortAction, shortCommandText, shortKeyChar, _ref;
    keyAction = getRadioValue("action");
    keyType = getRadioValue("keytype");
    _ref = [keyType.split("_")[0], keyType.split("_")[2]], keySelection = _ref[0], keyValue = _ref[1];
    shortAction = keyAction[0];
    longAction = keyAction[0].toUpperCase() + keyAction.slice(1) + " ";
    selectedKeyElement = docElement(keySelection + keyValue);
    shortKeyChar = selectedKeyElement.value;
    if (keyValue === "option") {
      longKeyChar = selectedKeyElement.options[selectedKeyElement.selectedIndex].innerHTML;
    } else {
      longKeyChar = selectedKeyElement.value;
    }
    shortCommandText = shortAction + shortKeyChar;
    longCommandText = longAction + longKeyChar;
    shortKeyList.addKeyCommand(shortCommandText);
    longKeyList.addKeyCommand(longCommandText);
    refreshKeyCommands();
  };

  getRadioValue = function(name) {
    var radioElement, radioElements, _i, _len;
    radioElements = document.getElementsByName(name);
    for (_i = 0, _len = radioElements.length; _i < _len; _i++) {
      radioElement = radioElements[_i];
      if (radioElement.checked) {
        return radioElement.value;
      }
    }
  };

  changeField = function(fieldToChange, textToAdd) {
    docElement(fieldToChange).value = textToAdd;
  };

  window.removeFromKeys = function() {
    shortKeyList.removeKeyCommand();
    longKeyList.removeKeyCommand();
    refreshKeyCommands();
  };

  window.releaseAllKeys = function() {
    shortKeyList.addKeyCommand("r-1");
    longKeyList.addKeyCommand("Release All Keys");
    refreshKeyCommands();
  };

}).call(this);
