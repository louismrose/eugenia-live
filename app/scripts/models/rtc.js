  Spine = require("spine");

  // fileref=document.createElement('script');
  // fileref.setAttribute("type","text/javascript");
  // fileref.setAttribute("src", "//www.google.com/jsapi");
  // fileref2=document.createElement('script');
  // fileref2.setAttribute("type","text/javascript");
  // fileref2.setAttribute("src", "//apis.google.com/js/api.js");
  // fileref3=document.createElement('script');
  // fileref3.setAttribute("type","text/javascript");
  // fileref3.setAttribute("src", "//apis.google.com/js/api.js");


  CREATE_SELECTOR = "#createDoc";
  OPEN_SELECTOR = "#openDoc";
  AUTH_BUTTON = "authorizeButton";
  SHARE_SELECTOR = "#share";

   realTimeOptions = {
      appID: '465627783329',
      clientId: '465627783329-5rt9n9o1m3oum4i1o9quvhe5641u182f.apps.googleusercontent.com',
      authButtonElementId: AUTH_BUTTON,
      initializeModel: initializeModel,
      autoCreate: false,
      defaultTitle: "Contacts_Map",
      onFileLoaded: onFileLoaded
    };

    var realtimeDoc = null;


    var pickerCallback = function (data) {
      if (data.action == google.picker.Action.PICKED) {
       var fileId = data.docs[0].id;
        rtclient.redirectTo(fileId, realtimeLoader.authorizer.userId);
      }
    };

    function startRealtime() {
      realtimeLoader = new rtclient.RealtimeLoader(realTimeOptions);
      realtimeLoader.start(afterAuth);
    }

    var afterAuth = function(){
      $(SHARE_SELECTOR).click(popupShare);
      $(OPEN_SELECTOR).click(popupOpen);
      $(CREATE_SELECTOR).click(function() {
        var fileName = prompt("New file name:", "");
        realtimeLoader.createNewFileAndRedirect(fileName);
      });
    };

    function initializeModel (model) {
      console.log('initializeModel');
      var map = model.createMap();
      model.getRoot().set('modelsMap', map);
    }

    function onFileLoaded (doc) {
      console.log('onFileLoaded');
      var modelsMap = doc.getModel().getRoot().get('modelsMap');
      modelsMap.addEventListener(gapi.drive.realtime.EventType.VALUE_CHANGED, loadJSON);
      var keys = modelsMap.keys();
      for(var i in keys){
        var record = modelsMap.get(keys[i]);
        record.addEventListener(gapi.drive.realtime.EventType.VALUE_CHANGED, updateJSON);
      }
      realtimeDoc = doc;
      Spine.Model.trigger('Model:fileLoad',modelsMap);
    }
    
    var popupOpen = function () {
      var token = gapi.auth.getToken().access_token;
      var view = new google.picker.View(google.picker.ViewId.DOCS);
      var picker = new google.picker.PickerBuilder()
          .enableFeature(google.picker.Feature.NAV_HIDDEN)
          .setAppId(realTimeOptions.appId)
          .setOAuthToken(token)
          .addView(view)
          .setCallback(pickerCallback)
          .build();
      picker.setVisible(true);
    };

    var popupShare = function() {
      var shareClient = new gapi.drive.share.ShareClient(realTimeOptions.appId);
      shareClient.setItemIds([rtclient.params['fileId']]);
      shareClient.showSettingsDialog();
    };

    var deleteJSON = function(evt){
      var modelsMap = realtimeDoc.getModel().getRoot().get('modelsMap');
      var records = modelsMap.get(this.className);
      records.delete(this.className+evt.id);
    };

    var saveJSON = function (evt){
      // console.log("saveJSON "+evt.toString());
      var modelsMap = realtimeDoc.getModel().getRoot().get('modelsMap');
      if(modelsMap.has(this.className)){
        var records = modelsMap.get(this.className);
        records.set(this.className+evt.id,JSON.stringify(evt));
      }else {
        var records = realtimeDoc.getModel().createMap();
        records.set(this.className+evt.id,JSON.stringify(evt));
        records.addEventListener(gapi.drive.realtime.EventType.VALUE_CHANGED, updateJSON); //repetitive, maybe find better way
        modelsMap.set(this.className,records);
      }
    };

    var loadJSON = function(evt){
      console.log("loadJSON");
      var isLocal = evt.isLocal;
      if(!isLocal){
        var modelsMap = realtimeDoc.getModel().getRoot().get('modelsMap');
        var records = modelsMap.get(evt.property);
        records.addEventListener(gapi.drive.realtime.EventType.VALUE_CHANGED, updateJSON);
        Spine.Model.trigger('Model:fileLoad',modelsMap);
      }
    };

    var updateJSON = function(evt){
      var isLocal = evt.isLocal;
      if(!isLocal){
        var modelsMap = realtimeDoc.getModel().getRoot().get('modelsMap');
        Spine.Model.trigger('Model:fileUpdate',evt);
      }
    };

window.onload = startRealtime;
exports.saveJSON = saveJSON;
exports.deleteJSON = deleteJSON;
exports.loadJSON = loadJSON;

/**
 *__________________________________________________________________________________________________
 *_______________________________________ Realtime client utils library____________________________
 *_________________________________________________________________________________________________
 */
"use strict";




var rtclient = rtclient || {}


rtclient.INSTALL_SCOPE = 'https://www.googleapis.com/auth/drive.install';


/**
 * OAuth 2.0 scope for opening and creating files.
 * @const
 */
rtclient.FILE_SCOPE = 'https://www.googleapis.com/auth/drive.file';


/**
 * OAuth 2.0 scope for accessing the user's ID.
 * @const
 */
rtclient.OPENID_SCOPE = 'openid';


/**
 * MIME type for newly created Realtime files.
 * @const
 */
rtclient.REALTIME_MIMETYPE = 'application/vnd.google-apps.drive-sdk';


/**
 * Parses the query parameters to this page and returns them as an object.
 * @function
 */
rtclient.getParams = function() {
  var params = {};
  var queryString = window.location.search;
  if (queryString) {
    // split up the query string and store in an object
    var paramStrs = queryString.slice(1).split("&");
    for (var i = 0; i < paramStrs.length; i++) {
      var paramStr = paramStrs[i].split("=");
      params[paramStr[0]] = unescape(paramStr[1]);
    }
  }
  return params;
}


/**
 * Instance of the query parameters.
 */
rtclient.params = rtclient.getParams();


/**
 * Fetches an option from options or a default value, logging an error if
 * neither is available.
 * @param options {Object} containing options.
 * @param key {string} option key.
 * @param defaultValue {Object} default option value (optional).
 */
rtclient.getOption = function(options, key, defaultValue) {
  var value = options[key] == undefined ? defaultValue : options[key];
  if (value == undefined) {
    console.error(key + ' should be present in the options.');
  }
  // console.log(value);
  return value;
}


/**
 * Creates a new Authorizer from the options.
 * @constructor
 * @param options {Object} for authorizer. Two keys are required as mandatory, these are:
 *
 *    1. "clientId", the Client ID from the APIs Console
 */
rtclient.Authorizer = function(options) {
  this.clientId = rtclient.getOption(options, 'clientId');
  // Get the user ID if it's available in the state query parameter.
  this.userId = rtclient.params['userId'];
  this.authButton = document.getElementById(rtclient.getOption(options, 'authButtonElementId'));
}


/**
 * Start the authorization process.
 * @param onAuthComplete {Function} to call once authorization has completed.
 */
rtclient.Authorizer.prototype.start = function(onAuthComplete) {
  var _this = this;
  gapi.load('auth:client,drive-realtime,drive-share', function() {
    _this.authorize(onAuthComplete);
  });
}


/**
 * Reauthorize the client with no callback (used for authorization failure).
 * @param onAuthComplete {Function} to call once authorization has completed.
 */
rtclient.Authorizer.prototype.authorize = function(onAuthComplete) {
  var clientId = this.clientId;
  var userId = this.userId;
  var _this = this;

  var handleAuthResult = function(authResult) {
    if (authResult && !authResult.error) {
      _this.authButton.disabled = true;
      _this.fetchUserId(onAuthComplete);
    } else {
      _this.authButton.disabled = false;
      _this.authButton.onclick = authorizeWithPopup;
    }
  };

  var authorizeWithPopup = function() {
    gapi.auth.authorize({
      client_id: clientId,
      scope: [
        rtclient.INSTALL_SCOPE,
        rtclient.FILE_SCOPE,
        rtclient.OPENID_SCOPE
      ],
      user_id: userId,
      immediate: false
    }, handleAuthResult);
    // console.log(clientId);
  };

  // Try with no popups first.
  gapi.auth.authorize({
    client_id: clientId,
    scope: [
      rtclient.INSTALL_SCOPE,
      rtclient.FILE_SCOPE,
      rtclient.OPENID_SCOPE
    ],
    user_id: userId,
    immediate: true
  }, handleAuthResult);
};


/**
 * Fetch the user ID using the UserInfo API and save it locally.
 * @param callback {Function} the callback to call after user ID has been
 *     fetched.
 */
rtclient.Authorizer.prototype.fetchUserId = function(callback) {
  var _this = this;
  gapi.client.load('oauth2', 'v2', function() {
    gapi.client.oauth2.userinfo.get().execute(function(resp) {
      if (resp.id) {
        _this.userId = resp.id;
      }
      if (callback) {
        callback();
      }
    });
  });
};

/**
 * Creates a new Realtime file.
 * @param title {string} title of the newly created file.
 * @param callback {Function} the callback to call after creation.
 */
rtclient.createRealtimeFile = function(title, callback) {
  gapi.client.load('drive', 'v2', function() {
    gapi.client.drive.files.insert({
      'resource': {
        mimeType: rtclient.REALTIME_MIMETYPE,
        title: title
      }
    }).execute(callback);
  });
};


/**
 * Fetches the metadata for a Realtime file.
 * @param fileId {string} the file to load metadata for.
 * @param callback {Function} the callback to be called on completion, with signature:
 *
 *    function onGetFileMetadata(file) {}
 *
 * where the file parameter is a Google Drive API file resource instance.
 */
rtclient.getFileMetadata = function(fileId, callback) {
  gapi.client.load('drive', 'v2', function() {
    gapi.client.drive.files.get({
      'fileId' : id
    }).execute(callback);
  });
};


/**
 * Parses the state parameter passed from the Drive user interface after Open
 * With operations.
 * @param stateParam {Object} the state query parameter as an object or null if
 *     parsing failed.
 */
rtclient.parseState = function(stateParam) {
  try {
    var stateObj = JSON.parse(stateParam);
    return stateObj;
  } catch(e) {
    return null;
  }
};


/**
 * Redirects the browser back to the current page with an appropriate file ID.
 * @param fileId {string} the file ID to redirect to.
 * @param userId {string} the user ID to redirect to.
 */
rtclient.redirectTo = function(fileId, userId) {
  var params = [];
  if (fileId) {
    params.push('fileId=' + fileId);
  }
  if (userId) {
    params.push('userId=' + userId);
  }
  // Naive URL construction.
  window.location.href = params.length == 0 ? '/' : ('?' + params.join('&'));
};


/**
 * Handles authorizing, parsing query parameters, loading and creating Realtime
 * documents.
 * @constructor
 * @param options {Object} options for loader. Four keys are required as mandatory, these are:
 *
 *    1. "clientId", the Client ID from the APIs Console
 *    2. "initializeModel", the callback to call when the file is loaded.
 *    3. "onFileLoaded", the callback to call when the model is first created.
 *
 * and one key is optional:
 *
 *    1. "defaultTitle", the title of newly created Realtime files.
 */
rtclient.RealtimeLoader = function(options) {
  // Initialize configuration variables.
  this.onFileLoaded = rtclient.getOption(options, 'onFileLoaded');
  this.initializeModel = rtclient.getOption(options, 'initializeModel');
  this.registerTypes = rtclient.getOption(options, 'registerTypes', function(){})
  this.autoCreate = rtclient.getOption(options, 'autoCreate', false); // This tells us if need to we automatically create a file after auth.
  this.defaultTitle = rtclient.getOption(options, 'defaultTitle', 'New Realtime File');
  this.authorizer = new rtclient.Authorizer(options);
};


/**
 * Starts the loader by authorizing.
 * @param callback {Function} afterAuth callback called after authorization.
 */
rtclient.RealtimeLoader.prototype.start = function(afterAuth) {
  // Bind to local context to make them suitable for callbacks.
  var _this = this;
  this.authorizer.start(function() {
    if (_this.registerTypes) {
      _this.registerTypes();
    }
    if (afterAuth) {
      afterAuth();
    }
    _this.load();
  });
};


/**
 * Loads or creates a Realtime file depending on the fileId and state query
 * parameters.
 */
rtclient.RealtimeLoader.prototype.load = function() {
  var fileId = rtclient.params['fileId'];
  var userId = this.authorizer.userId;
  var state = rtclient.params['state'];

  // Creating the error callback.
  var authorizer = this.authorizer;
  var handleErrors = function(e) {
    if(e.type == gapi.drive.realtime.ErrorType.TOKEN_REFRESH_REQUIRED) {
      authorizer.authorize();
    } else if(e.type == gapi.drive.realtime.ErrorType.CLIENT_ERROR) {
      alert("An Error happened: " + e.message);
      window.location.href= "/";
    } else if(e.type == gapi.drive.realtime.ErrorType.NOT_FOUND) {
      alert("The file was not found. It does not exist or you do not have read access to the file.");
      window.location.href= "/";
    }
  };


  // We have a file ID in the query parameters, so we will use it to load a file.
  if (fileId) {
    gapi.drive.realtime.load(fileId, this.onFileLoaded, this.initializeModel, handleErrors);
    return;
  }

  // We have a state parameter being redirected from the Drive UI. We will parse
  // it and redirect to the fileId contained.
  else if (state) {
    var stateObj = rtclient.parseState(state);
    // If opening a file from Drive.
    if (stateObj.action == "open") {
      fileId = stateObj.ids[0];
      userId = stateObj.userId;
      rtclient.redirectTo(fileId, userId);
      return;
    }
  }

  if (this.autoCreate) {
    this.createNewFileAndRedirect();
  }
};


/**
 * Creates a new file and redirects to the URL to load it.
 */
rtclient.RealtimeLoader.prototype.createNewFileAndRedirect = function(title) {
  //No fileId or state have been passed. We create a new Realtime file and
  // redirect to it.
  var _this = this;
  rtclient.createRealtimeFile(title, function(file) {
    if (file.id) {
      rtclient.redirectTo(file.id, _this.authorizer.userId);
    }
    // File failed to be created, log why and do not attempt to redirect.
    else {
      console.error('Error creating file.');
      console.error(file);
    }
  });
};