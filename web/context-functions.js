testJs = function(a){
    console.log(a);
}

firestoreTest = function(link){
    console.log('{firestoreTest}link: ' + link);
    let storage = firebase.storage();
    let promis = storage.ref(link).getDownloadURL();
    promis.then(function(url) {
        let funcname = link.split('.')[0]
        runFunctionByName(funcname, document, url);
        // updateImage(url);
      }).catch(function(error) {
          console.log(error);
        // Handle any errors
      });
}

function runFunctionByName(functionName, context, args) {
    // If using Node.js, the context will be an empty object
    if(typeof(window) == "undefined") {
        context = context || global;
    }else{
        // Use the window (from browser) as context if none providen.
        context = context || window;
    }
    
    // Retrieve the namespaces of the function you want to execute
    // e.g Namespaces of "MyLib.UI.alerti" would be ["MyLib","UI"]
    var namespaces = functionName.split(".");
    
    // Retrieve the real name of the function i.e alerti
    var functionToExecute = namespaces.pop();
    
    // Iterate through every namespace to access the one that has the function
    // you want to execute. For example with the alert fn "MyLib.UI.SomeSub.alert"
    // Loop until context will be equal to SomeSub
    for (var i = 0; i < namespaces.length; i++) {
        context = context[namespaces[i]];
    }
    
    // If the context really exists (namespaces), return the function or property
    return context[functionToExecute].apply(context, args);
}