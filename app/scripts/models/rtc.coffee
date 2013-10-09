define [
  'spine'
], (Spine) ->
  
  # Script loading currently happens in index.html, but could be moved here.
  
  # fileref=document.createElement('script');
  # fileref.setAttribute("type","text/javascript");
  # fileref.setAttribute("src", "//www.google.com/jsapi");
  # fileref2=document.createElement('script');
  # fileref2.setAttribute("type","text/javascript");
  # fileref2.setAttribute("src", "//apis.google.com/js/api.js");
  # fileref3=document.createElement('script');
  # fileref3.setAttribute("type","text/javascript");
  # fileref3.setAttribute("src", "//apis.google.com/js/api.js");
  
  # Pointers to interface button IDs for interacting with realtime code
  
  #appID and clientID should be copied from Google Console
  startRealtime = ->
    beforeAuth()
    realtimeLoader = new rtclient.RealtimeLoader(realTimeOptions)
    realtimeLoader.start afterAuth
  
  # add button listeners after successful authorization and make them enabled
  
  # Called when a realtime model is loaded for the first time
  initializeModel = (model) ->
    console.log "initializeModel"
    map = model.createMap()
    model.getRoot().set "modelsMap", map
  
  #Called everytime a realtime model is loaded
  onFileLoaded = (doc) ->
    console.log "onFileLoaded"
    modelsMap = doc.getModel().getRoot().get("modelsMap")
    modelsMap.addEventListener gapi.drive.realtime.EventType.VALUE_CHANGED, remoteJSONAdded
    keys = modelsMap.keys()
    for i of keys
      record = modelsMap.get(keys[i])
      
      #add change listeners to every map entry. This only affects local copy of map
      record.addEventListener gapi.drive.realtime.EventType.VALUE_CHANGED, remoteJSONUpdate
    realtimeDoc = doc
    Spine.Model.trigger "Model:fileLoad", modelsMap
    installCollaboratorListener()
    updateCollaborators()
  rtc = rtc or {}
  CREATE_SELECTOR = "#createDoc"
  OPEN_SELECTOR = "#openDoc"
  AUTH_BUTTON = "authorizeButton"
  SHARE_SELECTOR = "#share"
  realTimeOptions =
    appID: "465627783329"
    clientId: "465627783329-5rt9n9o1m3oum4i1o9quvhe5641u182f.apps.googleusercontent.com"
    authButtonElementId: AUTH_BUTTON
    initializeModel: initializeModel
    autoCreate: false
    defaultTitle: "Contacts_Map"
    onFileLoaded: onFileLoaded

  realtimeDoc = null
  userId = null
  lastReqTime = 0
  beforeAuth = ->
    $(OPEN_SELECTOR).attr "disabled", "true"
    $(CREATE_SELECTOR).attr "disabled", "true"

  afterAuth = ->
    $(SHARE_SELECTOR).click popupShare
    $(OPEN_SELECTOR).click popupOpen
    $(CREATE_SELECTOR).click ->
      fileName = prompt("New file name:", "")
      realtimeLoader.createNewFileAndRedirect fileName  if fileName

    $(OPEN_SELECTOR).removeAttr "disabled"
    $(CREATE_SELECTOR).removeAttr "disabled"

  
  # Displays Google Picker, for selecting rt file to load
  popupOpen = ->
    token = gapi.auth.getToken().access_token
    view = new google.picker.View(google.picker.ViewId.DOCS)
    view.setMimeTypes rtclient.REALTIME_MIMETYPE # filters files, and only displays realtime files
    picker = new google.picker.PickerBuilder().enableFeature(google.picker.Feature.NAV_HIDDEN).setAppId(realTimeOptions.appId).setOAuthToken(token).addView(view).addView(new google.picker.DocsUploadView()).setCallback(pickerCallback).build()
    picker.setVisible true

  
  # redirects client to the selected realtime document
  pickerCallback = (data) ->
    if data.action is google.picker.Action.PICKED
      fileId = data.docs[0].id
      console.log fileId
      rtclient.redirectTo fileId, realtimeLoader.authorizer.userId

  
  # commented code is required for modular share window. Currently not working.
  # The reason is most likely wrong configuration of Drive SDK within Google Console
  popupShare = ->
    window.open "https://drive.google.com/#recent"

  
  # var fileID = [rtclient.params['fileId']];
  # if(fileID!=""){
  #   var shareClient = new gapi.drive.share.ShareClient(realTimeOptions.appId);
  #   shareClient.setItemIds(fileID);
  #   shareClient.showSettingsDialog();
  # }else{
  #   alert("Please open the file you wish to share first.");
  # }
  
  # deletes a collaborative map entry. Called from realtime.coffee
  deleteJSON = (evt) ->
    modelsMap = realtimeDoc.getModel().getRoot().get("modelsMap")
    records = modelsMap.get(@className)
    records.deleteme @className + evt.id

  
  #create a new collaborative map entry. Called from realtime.coffee
  createJSON = (evt) ->
    modelsMap = realtimeDoc.getModel().getRoot().get("modelsMap")
    if modelsMap.has(@className)
      records = modelsMap.get(@className)
      records.set @className + evt.id, JSON.stringify(evt)
    else
      records = realtimeDoc.getModel().createMap()
      records.set @className + evt.id, JSON.stringify(evt)
      records.addEventListener gapi.drive.realtime.EventType.VALUE_CHANGED, remoteJSONUpdate #repetitive, maybe find better way
      modelsMap.set @className, records

  
  #update a collaborative map entry. Called from realtime.coffee
  updateJSON = (evt) ->
    current = new Date().getTime()
    if true
      lastReqTime = current
      console.log "updateJSON "
      modelsMap = realtimeDoc.getModel().getRoot().get("modelsMap")
      records = modelsMap.get(@className)
      records.set @className + evt.id, JSON.stringify(evt)

  
  # called when a new entry is added on outer map. This will happen when a new Model type
  # is created.
  remoteJSONAdded = (evt) ->
    isLocal = evt.isLocal
    unless isLocal
      modelsMap = realtimeDoc.getModel().getRoot().get("modelsMap")
      records = modelsMap.get(evt.property)
      records.addEventListener gapi.drive.realtime.EventType.VALUE_CHANGED, remoteJSONUpdate
      Spine.Model.trigger "Model:fileLoad", modelsMap

  
  # called when a change is made in the collaborative map
  remoteJSONUpdate = (evt) ->
    isLocal = evt.isLocal
    unless isLocal
      modelsMap = realtimeDoc.getModel().getRoot().get("modelsMap")
      Spine.Model.trigger "Model:fileUpdate", evt

  installCollaboratorListener = ->
    realtimeDoc.addEventListener gapi.drive.realtime.EventType.COLLABORATOR_JOINED, updateCollaborators
    realtimeDoc.addEventListener gapi.drive.realtime.EventType.COLLABORATOR_LEFT, updateCollaborators

  
  ###
  Draw function for the collaborator list. It will search the DOM for the specified
  location and add it self.
  ###
  updateCollaborators = ->
    
    # Creating the Collaborators container in the Dom if it's not already there.
    if not document.getElementById("collaborators") and document.getElementsByClassName
      toolbarElement = document.getElementsByClassName("brand")[0]
      collaboratorsElement = document.createElement("span")
      collaboratorsElement.id = "collaborators"
      collaboratorsElement.style.position = "absolute"
      collaboratorsElement.style.right = "15px"
      toolbarElement.appendChild collaboratorsElement
    collaboratorsElement = document.getElementById("collaborators")
    if collaboratorsElement
      collaboratorsList = realtimeDoc.getCollaborators()
      collaboratorsElement.innerHTML = ""
      if collaboratorsList.length > 1
        spanContainer = document.createElement("span")
        spanContainer.style.horizontalAlign = "left"
        collaboratorsElement.appendChild spanContainer
        i = 0

        while i < collaboratorsList.length
          collaborator = collaboratorsList[i]
          unless collaborator.isMe
            img = document.createElement("img")
            img.src = collaborator.photoUrl
            img.alt = collaborator.displayName
            img.title = collaborator.displayName
            img.style.backgroundColor = collaborator.color
            img.style.marginLeft = "5px"
            img.style.height = "25px"
            img.style.width = "25px"
            img.style.paddingBottom = "5px"
            collaboratorsElement.appendChild img
          else
            userId = collaborator.userId
          i = i + 1
      else if collaboratorsList.length is 1
        collaborator = collaboratorsList[0]
        userId = collaborator.userId  if collaborator.isMe

  window.onload = startRealtime


# make update/delete/create JSON function available to external files. Used for realtime.coffee
# exports.updateJSON = updateJSON;
#  exports.deleteJSON = deleteJSON;
#  exports.createJSON = createJSON;