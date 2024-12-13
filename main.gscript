function formatCurrentDate() {
  var currentDate = new Date();  
  var timeZone = Session.getScriptTimeZone();
  var formattedDate = Utilities.formatDate(currentDate, timeZone, "yyyy-MM-dd HH:mm:ss");
  
  return formattedDate;
}

function createDoc(pDocId) {
  //const templateId = PropertiesService.getScriptProperties().getProperty('templateId');
  _fName = pDocId + '.tmp'

  const templateDoc = DriveApp.getFileById(pDocId)
  targetFile = templateDoc.makeCopy(pDocId);
  targetFileId = targetFile.getId()
  //targetdoc = DocumentApp.openById(targetFileId);

  return targetFileId
}

function connInfo(pDocId) {
  //const templateId = PropertiesService.getScriptProperties().getProperty('templateId');
  const _url = PropertiesService.getScriptProperties().getProperty('url');
  const _user = PropertiesService.getScriptProperties().getProperty('user');
  const _pass = PropertiesService.getScriptProperties().getProperty('pass');
  
  var doc = DocumentApp.openById(pDocId)
  var body = doc.getBody();
  var tables = body.getTables();

  _dbConn = Jdbc.getConnection(_url, _user, _pass);
  
  _sql = "select vw.shapeType,c.uuid,c.ver,c.name,c.subType from vwProcessConnection vw inner join component c on vw.shapeUUID = c.uuid where shapeType = 'connectoraction'";
  
  stmt = _dbConn.createStatement();
  rs = stmt.executeQuery(_sql);
  
  var resultsArray = [];

  tbl = tables[1];
  _rowIdx = 1

  while (rs.next()) {
    //var row = [];
    var _row = tbl.appendTableRow();
    
    _uuid = rs.getString('uuid')
    _row.appendTableCell(_uuid);
    
    _name = rs.getString('name')
    _row.appendTableCell(_name);
    
    _ver = rs.getString('ver')
    _row.appendTableCell(_ver);
    
    _subType = rs.getString('subType')
    _row.appendTableCell(_subType);
  }
  
  rs.close();
  stmt.close();
  _dbConn.close();
}

function mapInfo(pDocId,pUUID) {
  const _url = PropertiesService.getScriptProperties().getProperty('url');
  const _user = PropertiesService.getScriptProperties().getProperty('user');
  const _pass = PropertiesService.getScriptProperties().getProperty('pass');

  var doc = DocumentApp.openById(pDocId)
  var body = doc.getBody();
  var tables = body.getTables();

  _dbConn = Jdbc.getConnection(_url, _user, _pass);
  
  _sql = "select name,ver,fromPath,fromProfileType,toPath,toProfileType from vwComponentMap where uuid = '"
  _sql += pUUID + "'"

  stmt = _dbConn.createStatement();
  rs = stmt.executeQuery(_sql);

  var resultsArray = [];

  tbl = tables[2];
  _rowIdx = 1

  while (rs.next()) {
    //var row = [];
    var _row = tbl.appendTableRow();
    
    _name = rs.getString('name')
    _row.appendTableCell(_name);
    _row.setForegroundColor('#000000')
    
    _ver = rs.getString('ver')
    _row.appendTableCell(_ver);
    
    _fromPath = rs.getString('fromPath')
    _row.appendTableCell(_fromPath);
    
    _fromProfile = rs.getString('fromProfileType')
    _row.appendTableCell(_fromProfile);
    
    _toPath = rs.getString('toPath')
    _row.appendTableCell(_toPath);
    
    _toProfile = rs.getString('toProfileType')
    _row.appendTableCell(_toProfile);
  }
  
  if (tables.length > 0) {
    var table = tables[2];
    
    for (var row = 1; row < table.length; row++) {
      for (var col = 0; col < table[row].length; col++) {
        var cell = table[row][col];
        cell.setTextStyle(0, cell.getText().length, DocumentApp.newTextStyle().setForegroundColor('#000000').build());
      }
    }
  }

  rs.close();
  stmt.close();
  _dbConn.close();
}

function findElementByName(element, name) {
  var children = element.getChildren();
  for (var i = 0; i < children.length; i++) {
    if (children[i].getName() === name) {
      return children[i];
    }
    var result = findElementByName(children[i], name);
    if (result) {
      return result;
    }
  }
  return null;
}

function genDoc(pUUID,procName,procDescr,procMode,schedAll,pFName) {
  const data = {
    '{{BoomiProcessName}}': procName,
    '{{BoomiProcessDescr}}': procDescr,
    '{{BoomiIntType}}': procMode,
    '{{BoomiSchedule}}': schedAll,
    '{{GenDateTime}}': formatCurrentDate()
  };

  targetdoc = DocumentApp.openById(pUUID);
  body = targetdoc.getBody();

  for (const placeholder in data) {
    body.replaceText(placeholder, data[placeholder]);
  }

  targetFile.saveAndClose
  targetFile.setName(fName);
  
  var elements = body.getParagraphs();
  
  for (var i = 0; i < elements.length; i++) {
    var element = elements[i];
    
    // Check if the element is a Table of Contents
    if (element.getText().indexOf('Table of Contents') !== -1) {
      var toc = element.asTableOfContents();
      
      // Refresh the Table of Contents
      toc.refresh();
      Logger.log('TOC has been refreshed.');
      break;  // Exit the loop after refreshing the TOC
    }
  }

  Logger.log('File created: ' + targetFile.getUrl());

  return targetFile.getUrl()
}

function doPost(e) {
  var data = JSON.parse(e.postData.contents);
  
  var targetDocId = main(data);
  
  return ContentService.createTextOutput(JSON.stringify({status: "success", document: targetDocId}))
    .setMimeType(ContentService.MimeType.JSON);
}

function main(data) {
  const boomiAtomSphereAPI = 'https://api.boomi.com/api/rest/v1/'
  const boomiAccount = PropertiesService.getScriptProperties().getProperty('boomiAccount');
  const resource = '/Component/'
  const _apiUrl = boomiAtomSphereAPI + boomiAccount

  const auth = PropertiesService.getScriptProperties().getProperty('auth');
  
  _uuid = data.processId
  
  fName = 'Boomi Integration Spec. - ';

  apiUrl = _apiUrl + resource + _uuid
  
  resourceSched = '/ProcessSchedules/'
  apiAction = 'query'
  apiUrlSched = _apiUrl + resourceSched + apiAction

  const headersProc = {
    'Authorization': "Basic " + auth
  };

  const headersSched = {
    "Authorization": "Basic " + auth,
    "Content-Type": "application/xml",
    "Accept": "application/json"
  };

  const optionsProc = {
    "method": "get",
    "headers": headersProc,
    "Accept": "application/xml"
  };

  apiRequestSched = '<QueryConfig xmlns="http://api.platform.boomi.com/"><QueryFilter><expression operator="and" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="GroupingExpression"><nestedExpression operator="EQUALS" property="atomId" xsi:type="SimpleExpression"><argument>7f69061c-c731-4e3d-80b6-3f8be47d81d3</argument></nestedExpression><nestedExpression operator="EQUALS" property="processId" xsi:type="SimpleExpression"><argument>'
  apiRequestSched += _uuid + '</argument></nestedExpression></expression></QueryFilter></QueryConfig>'

  const optionsSched = {
    "method": "post",
    "muteHttpExceptions": true,
    "headers": headersSched,
    "payload": apiRequestSched
  };

  Logger.log("Generating document")
  
  xmlRespAll = UrlFetchApp.fetch(apiUrl,optionsProc)
  xmlResp = xmlRespAll.getContentText()

  xmlDoc = XmlService.parse(xmlResp)
  namespace = XmlService.getNamespace('http://api.platform.boomi.com/')
  root = xmlDoc.getRootElement()

  procName = root.getAttribute('name') ? root.getAttribute('name').getValue() : 'Process name not found';
  fName += procName

  descrElement = root.getChild('description', XmlService.getNamespace('http://api.platform.boomi.com/'));
  procDescrElement = root.getChild('description', namespace);
  procDescr = procDescrElement ? procDescrElement.getText() : 'Description not found';

  objElement = root.getChild('object', namespace);
  procElement = objElement.getChild('process');
  workload = procElement.getAttribute('workload') ? procElement.getAttribute('workload').getValue() : 'Workload not found';

  var actionType = ""
  connectorActionElement = findElementByName(root, 'connectoraction');
  if (connectorActionElement) {
    actionType = connectorActionElement.getAttribute('actionType').getValue();
    actionType = actionType.toLowerCase()
  }

  //Logger.log("workload: " + workload)
  //Logger.log("start: " + actionType)
  
  procMode = 'Unknown'
  if (workload == 'general' && actionType != 'listen') {
    procMode = 'non-Event'
  } else if ((workload == 'bridge' || workload == 'low_latency') && (actionType) == 'listen') {
    procMode = 'Event'
  }
  
  //Schedules
  response = UrlFetchApp.fetch(apiUrlSched,optionsSched)
  jsonResponse = response.getContentText();
  
  var parsedData = JSON.parse(jsonResponse);
  var sched = parsedData.result[0].Schedule;
  if (parsedData.numberOfResults = 0.0) {
    schedAll = "No schedules"
  } else {
    if (sched == '') {
      schedAll = "No schedules"
    } else {
      var schedAll = "";
        for (_idx = 0; _idx < sched.length; _idx++) {
          _sched = sched[_idx];

          min = _sched.minutes;
          hour = _sched.hours;
          dayofWeek = _sched.daysOfWeek;
          dayofMonth = _sched.daysOfMonth;
          month = _sched.months;
          year = _sched.years;

          schedAll += "Schedule " + _idx + ": " + min + " " + hour + " " + " " + dayofMonth + " " + month + " " + year + " " + dayofWeek + "\n"
        }
    }
  }

  Logger.log("Generating document...")
  const templateId = PropertiesService.getScriptProperties().getProperty('templateId');
  targetDocId = createDoc(templateId)
  
  Logger.log("Processing Connections")
  connInfo(targetDocId);
  
  Logger.log("Processing Maps")
  pUUID = '07d2ef3b-1227-407c-9b5c-cb2c953889eb'
  mapInfo(targetDocId,pUUID);
  
  Logger.log("Generating document")
  _targetDocURL = genDoc(targetDocId,procName,procDescr,procMode,schedAll,fName);

  Logger.log("Generating document done")

  return _targetDocURL;
}
