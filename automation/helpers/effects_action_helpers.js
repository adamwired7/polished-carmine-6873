var target = UIATarget.localTarget();

function givenWhenThen(title,commands){
  UIALogger.logMessage(title);
  commands();
  var revisedTitle = title.replace(/ /g,"_");
  target.captureScreenWithName(date_capture()+revisedTitle);
}

function Given(title,commands){
  givenWhenThen(title,commands);
}
function When(title,commands){
  givenWhenThen(title,commands);
}
function Then(title,commands){
  givenWhenThen(title,commands);
}
function And(title,commands){
  givenWhenThen(title,commands);
}

function date_capture(){

  var d = new Date();
  var dd = d.getTime();
  return dd+"_";
}

function expect_equal(a,b){
  if(a==b){
    UIALogger.logPass("EXPECT_EQUAL");
  }
  else {
    UIALogger.logFail("EXPECT_EQUAL");
  }
}

function expect_valid(a){
  if(a.checkIsValid()){
    UIALogger.logPass("EXPECT_VALID");
  }
  else {
    UIALogger.logFail("EXPECT_VALID");
  }
}
