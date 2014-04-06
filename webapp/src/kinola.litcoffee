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

Text entered is sent directly if you want to send a key command. This must be sent in the macro language defined for sending these keys. See [README](http://github.com/catichenor/kinola/blob/master/README.md) for details.

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

    timedURL = (url) ->
        setTimeout (sendRequest = ->
            quickURL url
            return
            ), 3000
        return

## quickURL

Sends the (hopefully) clean URL to the Yun.

    quickURL = (url) ->
        XMLHttp = new XMLHttpRequest()
        XMLHttp.open "POST", url, true
        XMLHttp.send()
        return
        
---

# Command Entry UI Functions #

Functions for manipulating the Command Entry UI.

## docElement

Using `document.getElementById` too much, simplifying.

    window.docElement = (elementId) ->
        return document.getElementById(elementId)

## searchForButton

Checks to see if the user pressed "enter" and clicks the button sent through `cmd`.

    window.searchForButton = (e, cmd) -> 
        docElement(cmd + "_btn").click() if e.keyCode is 13
        false

## enableElement

Takes the element passed to it, and enables it.

    window.enableElement = (e) ->
        docElement(e).disabled = false
        return

## disableElements

Disables elements passed to it.

    window.disableElements = (itemsToDisable...) ->
        docElement(itemToDisable).disabled = true for itemToDisable in itemsToDisable
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
            theElement = docElement("modifieroption")
            addToFields theElement.value, theElement.options[theElement.selectedIndex].innerHTML

        if keyType is "specialkey"
            theElement = docElement("specialoption")
            addToFields theElement.value, theElement.options[theElement.selectedIndex].innerHTML

        if keyType is "regularkey"
            theElement = docElement("regularoption")
            addToFields theElement.value, theElement.value

        return

## checkDelimiter

Adds delimiters to the key command fields.

    checkDelimiter = ->
        addToFields "/", ", " if docElement("keyscommand").value
        return

## getRadioValue

Figure out which radio value is checked on the entered "name" element.

    getRadioValue = (name) ->
        radioElements = document.getElementsByName(name)
        return radioElement.value for radioElement in radioElements when radioElement.checked
        return

## addToFields

Add the command to the key command fields.

    addToFields = (shortname, longname) ->
        docElement("keyscommand").value += shortname
        docElement("long_input").value += longname
        return

## removeFromKeys

Remove the last element from the key command fields.

    window.removeFromKeys = ->
        shortField = docElement("keyscommand").value
        longField = docElement("long_input").value
        shortField = shortField.replace(/(.+)\/.+/, "$1")
        longField = longField.replace(/(.+),.+/, "$1")
        docElement("keyscommand").value = shortField
        docElement("long_input").value = longField
        return

## releaseAllKeys

Adds the "Release All Keys" key command.

    window.releaseAllKeys = ->
        checkDelimiter()
        addToFields "r-1", "Release All Keys"
        return
