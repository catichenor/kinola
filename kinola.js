function testResults (kind, form) {
	var IPAddress = form.ip_address.value; // Grab the entered IP address for the Yun
	if (kind == "type") { // If the user wants to type a command...
		var InputCommand = encodeURIComponent(form.type_command.value); //...encode it as a URL..
		InputCommand = InputCommand.replace(/!/g, "%21");	//...and substitute the
		InputCommand = InputCommand.replace(/'/g, "%27");	//characters that
		InputCommand = InputCommand.replace(/\(/g, "%28");	//"encodeURIComponent"
		InputCommand = InputCommand.replace(/\)/g, "%29");	//doesn't translate.
		InputCommand = InputCommand.replace(/\*/g, "%2A");
		InputCommand = InputCommand.replace(/\~/g, "%2D");				  
// See <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent> 
// for a list of characters not translated by "encodeURIComponent".
	}
	if (kind == "keys") {
		var InputCommand = form.keys_command.value;	//send the commands directly if you want 
								//to send keys. Of course, these must be 
								//sent in the macro language defined for
								//sending these keys. See README for
								//additional details.
	}
	InputCommand = InputCommand.replace(/^\//, ""); //remove a leading slash, if any
	IPAddress = IPAddress.replace(/https?:\/\//, "") //remove "http://", if any
	var theURL = "http://" + IPAddress + "/arduino/" + kind + "/" + InputCommand;
//	alert ("The URL is: " + theURL); //Testing code
	timedURL(theURL); //For testing on a local machine, gives 3 seconds to switch to another window
//	quickURL(theURL);
};

function timedURL(url) {
	setTimeout(function sendRequest() {
	quickURL(url);
	},3000);
}

function quickURL(url) {
	var XMLHttp;
	XMLHttp=new XMLHttpRequest();
	XMLHttp.open("POST",url,true);
	XMLHttp.send();
}

function searchForButton(e, cmd) {	//Check to see if the user pressed "enter" and 
					//click the appropriate button.
	if (e.keyCode == 13) {
		document.getElementById(cmd + "_btn").click();
	}
	return false;
}

function enableElement(e) {
	disableElements();
	document.getElementById(e).disabled=false;
}

function disableElements() {
	document.getElementById("modifieroption").disabled=true;
	document.getElementById("specialoption").disabled=true;
	document.getElementById("regularoption").disabled=true;
}

function startup() {
	disableElements();
	document.getElementById("holdradio").checked=true;
	document.getElementById("modifierradio").checked=true;
	document.getElementById("modifieroption").disabled=false;
}

window.onload = startup;

function addToKeys() {
	var keyAction = getRadioValue('action');
	var keyType = getRadioValue('keytype');
	
	checkDelimiter();
		
	if(keyAction == "hold") {
//		alert("Hold it!!!");
		addToFields("h", "Hold ");
	}
	if(keyAction == "push") {
//		alert("Push it good!");
		addToFields("p", "Push ");
	}
	if(keyAction == "release") {
//		alert("Release your mind...");
		addToFields("r", "Release ");
	}

	if(keyType == "modifierkey") {
		theElement = document.getElementById("modifieroption");
		addToFields(theElement.value, theElement.options[theElement.selectedIndex].innerHTML);
	}
	if(keyType == "specialkey") {
		theElement = document.getElementById("specialoption");
		addToFields(theElement.value, theElement.options[theElement.selectedIndex].innerHTML);
	}
	if(keyType == "regularkey") {
		theElement = document.getElementById("regularoption");
		addToFields(theElement.value, theElement.value);
	}
}

function checkDelimiter() {
	if (document.getElementById('keyscommand').value) {
		addToFields("/", ", ");
	}	
}

function getRadioValue(name) {
	for (i=0; i<document.getElementsByName(name).length; i++) {
		if(document.getElementsByName(name)[i].checked) {
			return document.getElementsByName(name)[i].value;
		}			
	}
}

function addToFields(shortname, longname) {
	document.getElementById('keyscommand').value += shortname;
	document.getElementById('long_input').value += longname;
}

function removeFromKeys() {
	shortField = document.getElementById('keyscommand').value;
	longField = document.getElementById('long_input').value;
	shortField = shortField.replace(/(.+)\/.+/, "$1");
	longField = longField.replace(/(.+),.+/, "$1");
	document.getElementById('keyscommand').value = shortField;
	document.getElementById('long_input').value = longField;
}

function releaseAllKeys() {
	checkDelimiter();
	addToFields('r-1', 'Release All Keys');
}
