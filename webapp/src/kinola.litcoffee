# Yun Communication Functions #

Functions for communicating with the Yun.

## sendCommand

Takes in the type of command as well as the command to be sent and sends it to the Arduino device. 

If it's text, this encodes the text as a URL to be sent to the Yun. If it's a command, it assumes you know what you're doing with the macro language syntax and sends it directly.

    window.sendCommand = (kind, form) ->
        IPAddress = form.ip_address.value                              
        # Grab the entered IP address for the Yun
        
        alert "We're getting the IP address: #{ IPAddress }"

        IPAddress = IPAddress.replace(/https?:\/\//, "")               
        # Remove "http://" from the IP address, if any

        sendDelay = true                                               
        # Introduce a delay when sending for testing purposes
        
        delayTime = 3000
        # If sendDelay is true, the time to wait before sending the command

        if kind is "type"                                              
        # If the user wants to send a line of text...
            # ...encode it as a URL...
            InputCommand = encodeURIComponent(form.type_command.value) 
            # ...then substitute the characters that "encodeURIComponent" doesn't translate.
            InputCommand = InputCommand.replace(/!/g, "%21")           
            InputCommand = InputCommand.replace(/'/g, "%27")
            InputCommand = InputCommand.replace(/\(/g, "%28")
            InputCommand = InputCommand.replace(/\)/g, "%29")
            InputCommand = InputCommand.replace(/\*/g, "%2A")
            InputCommand = InputCommand.replace(/\~/g, "%2D")
        
See [Mozilla's "encodeURIComponent" page](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent) for a list of characters that are not translated by encodeURICompnent.

        InputCommand = form.keys_command.value if kind is "keys" 

Text entered is sent directly if you want to send a key command. This, of course, these must be sent in the macro language defined for sending these keys. See [README](http://github.com/catichenor/kinola/blob/master/README.md) for additional details.

        InputCommand = InputCommand.replace(/^\//, "")                 
        # Remove a leading slash from the command, if any

        theURL = "http://" + IPAddress + "/arduino/" + kind + "/" + InputCommand
        # Form the URL. There's probably a better way of doing this.

        # alert theURL
        
        if sendDelay
            timedURL theURL
        else
            quickURL theURL
        return

## timedURL

Takes in the URL passed to it, adds a delay, then sends the URL to quickURL.

    window.timedURL = (url) ->
        setTimeout (sendRequest = ->
            quickURL url
            return
            ), 3000
        return

## quickURL

Sends the (hopefully) clean URL to the Yun.

    window.quickURL = (url) ->
        XMLHttp = new XMLHttpRequest()
        XMLHttp.open "POST", url, true
        XMLHttp.send()
        return
        
---

# Command Entry UI Functions #

Functions for manipulating the Command Entry UI.

## searchForButton

Checks to see if the user pressed "enter" and clicks the appropriate button.

    window.searchForButton = (e, cmd) -> 
        document.getElementById(cmd + "_btn").click() if e.keyCode is 13
        false

## enableElement

Takes the element passed to it, and enables it. 

Also disables all other elements, this probably will need to be separated from the disableElements function to be more "clean".

    window.enableElement = (e) ->
        disableElements()
        document.getElementById(e).disabled = false
        return

## disableElements

Disables 3 specific elements.

Should change this to loop over an array/turn it into a splat.

    window.disableElements = ->
        document.getElementById("modifieroption").disabled = true
        document.getElementById("specialoption").disabled = true
        document.getElementById("regularoption").disabled = true
        return

## startup

Set up initial form values.

    window.startup = ->
        disableElements()
        document.getElementById("holdradio").checked = true
        document.getElementById("modifierradio").checked = true
        document.getElementById("modifieroption").disabled = false
        return

## addToKeys

Collects the information to show what keys are being added to the form.

    window.addToKeys = ->
        keyAction = getRadioValue("action")
        keyType = getRadioValue("keytype")
        checkDelimiter()
        
        addToFields "h", "Hold " if keyAction is "hold"
        addToFields "p", "Push " if keyAction is "push"
        addToFields "r", "Release " if keyAction is "release"

        if keyType is "modifierkey"
            theElement = document.getElementById("modifieroption")
            addToFields theElement.value, theElement.options[theElement.selectedIndex].innerHTML

        if keyType is "specialkey"
            theElement = document.getElementById("specialoption")
            addToFields theElement.value, theElement.options[theElement.selectedIndex].innerHTML

        if keyType is "regularkey"
            theElement = document.getElementById("regularoption")
            addToFields theElement.value, theElement.value

        return

## checkDelimiter

Adds delimiters to the key command fields.

    window.checkDelimiter = ->
        addToFields "/", ", " if document.getElementById("keyscommand").value
        return

## getRadioValue

Figure out which radio value is checked on the entered "name" element.

    window.getRadioValue = (name) ->
        i = 0
        while i < document.getElementsByName(name).length
            return document.getElementsByName(name)[i].value if document.getElementsByName(name)[i].checked
            i++
        return

## addToFields

Add the command to the key command fields.

    window.addToFields = (shortname, longname) ->
        document.getElementById("keyscommand").value += shortname
        document.getElementById("long_input").value += longname
        return

## removeFromKeys

Remove the last element from the key command fields.

    window.removeFromKeys = ->
        shortField = document.getElementById("keyscommand").value
        longField = document.getElementById("long_input").value
        shortField = shortField.replace(/(.+)\/.+/, "$1")
        longField = longField.replace(/(.+),.+/, "$1")
        document.getElementById("keyscommand").value = shortField
        document.getElementById("long_input").value = longField
        return

## releaseAllKeys

Adds the "Release All Keys" key command.

    window.releaseAllKeys = ->
        checkDelimiter()
        addToFields "r-1", "Release All Keys"
        return
        
---

# Initial Startup #

Startup script to set the initial values of the form.

    window.onload = startup
