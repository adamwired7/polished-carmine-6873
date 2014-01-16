var currentimage = 0;
var pingTimer;
var metaTimer;
var errorCount = 0;
var firstCall = true;
var records = new Array();
var needsReset = false;

function checkForNew(){
  var currentimageposition = records.indexOf(currentimage);
  var nextimage = currentimageposition+1;
  if(records[nextimage]){
    needsReset = false;
    currentimage = records[nextimage];
    metaTimer = setTimeout("loadTests(false);",1000);
  }
  else {
    needsReset = true;
  }
}

function loadTests(ping){
  var xmlhttp;
  var log;
  var testdata;

  if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp=new XMLHttpRequest();
  }
  else{// code for IE6, IE5
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }


  // if(ping) {
  //   clearTimeout(pingTimer);
  //   $(xData.responseXML).find("z\\:row")
  // } else {
  //   pingTimer = setTimeout("loadTests(true)",2000);
  // }
  
  xmlhttp.onreadystatechange=function(){

    if(xmlhttp.readyState==4){
      if(ping){        
        clearTimeout(pingTimer);
        log = xmlhttp.responseXML;
        // alert(log.getElementsByTagName('test'));
        var recordcount = log.getElementsByTagName("test");
        if(recordcount.length < records.length){
          clearHistory();
        }
        records = new Array();
        if(recordcount.length > 0){
          for(var a=0; a<recordcount.length; a++){
            records[records.length] = recordcount[a].getAttribute("reference");
          }
          if(firstCall){
            //request actual data / image call
            currentimage = records[0];
            loadTests(false);
            firstCall = false;
          }
          else if(needsReset){
            checkForNew();
          }	
        }

        //if nothing... or something... check 5 seconds later...
        pingTimer = setTimeout("loadTests(true)",20000);
      }
      else {
        clearTimeout(metaTimer);
        testdata = xmlhttp.responseXML;
        pullTest(testdata,currentimage);
      }
    }
    else {
      if(!ping){
        pingTimer = setTimeout("loadTests(true)",2000);
      }
    }
  
  
  
  }

  if(ping){
    xmlhttp.open("GET","current.php?udid="+udid,false);
  }
  else {
    xmlhttp.open("GET","mobile/runs/"+udid+"/"+currentimage+"/meta.xml",false);
  }
  xmlhttp.send();
}

var testname;
var testdate;
var testerrors;
var images = new Array();
var inc = 0;
function pullTest(testrun,u){

  var allHistory = document.getElementById("temphistory");

  var tests = document.createElement('div');
  tests.setAttribute('class','tests');
  tests.setAttribute('id','tests'+inc);
  tests.setAttribute('onmousedown','repeat('+inc+');scrollTo(0,0);');

  allHistory.appendChild(tests);

  var testresult = testrun.getElementsByTagName("test")[0];
  var testname = testresult.getAttribute("name");
  var testdate = testresult.getAttribute("date");
  var testerrors = testresult.getAttribute("errors");

  testdate = new Date(testdate*1000);
  var ntestdate = testdate.getHours()+":"+testdate.getMinutes()+" on "+(testdate.getMonth()+1)+"/"+testdate.getDate()+"/"+testdate.getFullYear();

  var imagecount = testrun.getElementsByTagName("screen");
  var tname = document.createElement('div');
  tname.setAttribute('class','tname_small');
  tname.innerHTML = testname+" @ "+ntestdate+" - "+records.length+" total";
  tests.appendChild(tname);

  if(testerrors.length > 0){
    var fail = document.createElement('div');
    fail.setAttribute('class','fail');
    fail.innerHTML = " Failures >> "+testerrors;
    tests.appendChild(fail);
  }

  load = 0;
  for(var a=0; a<imagecount.length; a++){
    images[images.length] = imagecount[a].getAttribute("name");

    var ss = document.createElement('div');
    ss.setAttribute('class','screenshots_small');
    ss.setAttribute('id',"i"+inc+"_"+a);
    ss.style.visibility = "hidden";
    tests.appendChild(ss);

    var image = document.createElement('img');
    image.setAttribute('class','images_small');
    image.setAttribute('src',"runs/"+udid+"/"+u+"/"+images[images.length-1]);
    var ival = (images[images.length-1].substr(images[images.length-1].indexOf("_")).replace(/_/g," "));

    image.setAttribute('alt',ival.substr(0,ival.length-4));
    image.setAttribute("onload","loaded("+a+","+imagecount.length+","+inc+")");
    ss.appendChild(image);
  }
  inc++;
}
var load = 0;
var refresh;
function loaded(wn,t,rid){
  load++;

  if(load == t-1){		
    for(var a = 0; a<= load; a++){
      var image = document.getElementById("i"+rid+"_"+a);
      image.style.visibility = "visible";
      image.childNodes[0].setAttribute("onload","");
    }
    load = 0;	

    var tempHistory = document.getElementById("temphistory");

    var allHistory = document.getElementById("allhistory");
    var atZero = allHistory.childNodes[0];
    if(atZero){
      allHistory.insertBefore(tempHistory.childNodes[0],allHistory.childNodes[0]);
    }
    else {
      allHistory.appendChild(tempHistory.childNodes[0]);
    }

    if(rid == 0){
      play = setTimeout("repeat(-1)",2000);
    }
    //don't check until all images have loaded in
    checkForNew();
  }
}


var play;
function cancelRepeat(){
  clearTimeout(play);
}

function repeat(wid){

  cancelRepeat();


  //do we have something there already?
  var th = document.getElementById("testhold");
  if(wid == -1){
    if(th.childNodes[0]){
      wid = th.childNodes[0].getAttribute("id").split("tests")[1];
      wid = Number(wid)+1;
      if(!document.getElementById("tests"+wid)){
        wid = 0;
      }
    }
    else {
      wid = 0;
    }
  }

  var notReady = false;
  var testholdchild = document.getElementById("testhold").childNodes[0];
  if(testholdchild){
    if(testholdchild.getAttribute("id") == "tests"+wid){
      notReady = true;
    }
  }

  if(!notReady){

    var original = document.getElementById("tests"+wid).cloneNode(true);

    if(th.childNodes.length > 0){
      th.removeChild(th.childNodes[0]);
    }

    for(var oc = 0; oc < original.childNodes.length; oc++){
      if(oc == 0){	
        original.childNodes[oc].setAttribute("class","tname");
      }
      else {
        if(original.childNodes[oc].getAttribute("class") != "fail"){
          original.childNodes[oc].setAttribute("class","screenshots");
          original.childNodes[oc].childNodes[0].setAttribute("class","images");
          var detail = document.createElement("div");
          detail.setAttribute("class","detail");
          detail.innerHTML = original.childNodes[oc].childNodes[0].alt;
          original.childNodes[oc].appendChild(detail);
        }
      }
    }
    original.setAttribute("onmousedown","");
    th.appendChild(original);

  }

  var next = document.getElementById("tests"+(wid+1));
  var nextid = 0;
  if(next){
    nextid = wid + 1;
  }
  else {
    nextid = 0;
  }
  play = setTimeout("repeat("+nextid+")",15000);
}

function clearHistory(){
  cancelRepeat();
  var history = document.getElementById("history");
  var allHistory = document.getElementById("allhistory");
  history.removeChild(allHistory);
  allHistory = document.createElement("div");
  allHistory.setAttribute("class","allhistory");
  allHistory.setAttribute("id","allhistory");
  history.appendChild(allHistory);

  var testhold = document.getElementById("testhold");
  if(testhold.childNodes[0]){
    testhold.removeChild(testhold.childNodes[0]);
  }
  needsReset = false;
  currentimage = 0;
  firstCall = true;
  inc = 0;
}
