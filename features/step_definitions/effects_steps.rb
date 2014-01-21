//Given("I have entered the SDK")
public void enterSDK() throws UiObjectNotFoundException, IOException {
  //use to access SDK app

  try {
    getUiDevice().wakeUp();
  } catch (RemoteException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }


  getUiDevice().pressHome();

  UiObject allAppsButton = new UiObject(new UiSelector().description("Apps"));

  allAppsButton.clickAndWaitForNewWindow();

  UiObject appsTab = new UiObject(new UiSelector().text("Apps"));

  appsTab.click();

  UiScrollable appViews = new UiScrollable(new UiSelector().scrollable(true));

  appViews.setAsHorizontalList();

  UiObject settingsApp = appViews.getChildByText(new UiSelector().className(android.widget.TextView.class.getName()),"Photo Effects Demo");
  settingsApp.clickAndWaitForNewWindow();


  UiObject nextImage = new UiObject(new UiSelector().text("Next Image"));

  nextImage.click();

  UiObject useImage = new UiObject(new UiSelector().text("Use Image"));

  useImage.click();

}


//When("I select (.*) crop (.*) times")
public void selectCrop(String wCrop, int times) throws UiObjectNotFoundException, InterruptedException {

  String mode = wCrop + " Crop";

  UiObject cropMode = new UiObject(new UiSelector().description(mode));
  cropMode.click();

}

//When("I select next")
public void moveOn() throws UiObjectNotFoundException, InterruptedException {
  UiObject nextFromCrop = new UiObject(new UiSelector().text("Next"));
   nextFromCrop.click();
}

//When("I select the Filter Effects tab")
public void filters() throws UiObjectNotFoundException, InterruptedException {
  UiObject effectMode = new UiObject(new UiSelector().description("Filter Effects"));
  effectMode.click();
}

//When("I select the (.*) (.*) option")
public void filtersb(String wOption_word, String wOption_word_b) throws UiObjectNotFoundException, InterruptedException {
  UiObject effectMode = new UiObject(new UiSelector().description(wOption_word+" "+wOption_word_b));
  effectMode.click();
}

//When("I select the (.*) effect")
public void filtersc(String wEffect) throws UiObjectNotFoundException, InterruptedException {
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
