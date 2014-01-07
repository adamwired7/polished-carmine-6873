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

  UiObject demoValidation = new UiObject(new UiSelector().packageName("com.radiumone.r1sdkdemo"));

  assertTrue("Unable to detect Photo Demo App",demoValidation.exists());

  UiObject nextImage = new UiObject(new UiSelector().text("Next Image"));

  nextImage.click();

  UiObject useImage = new UiObject(new UiSelector().text("Use Image"));

  useImage.click();

  screenShot("entered_sdk");

}

