package com.example.qa_demo;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.RemoteException;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class Testing extends UiAutomatorTestCase {

  public void screenShot(String ofwhat) {
    long currentTime = System.currentTimeMillis() / 1000L;
    ofwhat = ofwhat.replaceAll("\\s","");
    System.out.println("/mnt/sdcard/Pictures/automation/" + currentTime + "_" + ofwhat + ".png");
    File storePath = new File("/mnt/sdcard/Pictures/automation/" + currentTime + "_" + ofwhat + ".png");
    getUiDevice().takeScreenshot(storePath);
  }
//Given("I have entered the SDK")
public void enterSDK1() throws UiObjectNotFoundException, IOException {

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


//When("I select (.*) crop 2 times")
//When("I select (.*) crop 2 times")
public void selectCrop2() throws UiObjectNotFoundException, InterruptedException {

  String wCrop = "Normal";

  String mode = wCrop + " Crop";

  UiObject cropMode = new UiObject(new UiSelector().description(mode));
  cropMode.click();

}

//When("I select next")
//When("I select next")
public void moveOn3() throws UiObjectNotFoundException, InterruptedException {

  UiObject nextFromCrop = new UiObject(new UiSelector().text("Next"));
   nextFromCrop.click();
}

//When("I select the Filter Effects option")
//When("I select the Filter Effects option")
public void filters4() throws UiObjectNotFoundException, InterruptedException {

  UiObject effectMode = new UiObject(new UiSelector().description("Filter Effects"));
  effectMode.click();
}

//When("I select the Fun House option")
//When("I select the Fun House option")
public void filtersb5() throws UiObjectNotFoundException, InterruptedException {

  UiObject effectMode = new UiObject(new UiSelector().description("Fun House"));
  effectMode.click();
}

//When("I select the (.*) effect")
//When("I select the (.*) effect")
public void filtersc6() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Toon";
 UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select next")
public void moveOn7() throws UiObjectNotFoundException, InterruptedException {

  UiObject nextFromCrop = new UiObject(new UiSelector().text("Next"));
   nextFromCrop.click();
}

//When("I select the Filter Effects option")
public void runAll() throws UiObjectNotFoundException, InterruptedException, IOException {
 enterSDK1(); screenShot("Given_I_have_entered_the_SDK"); selectCrop2(); screenShot("And_I_select__Normal__crop_2_times"); moveOn3(); screenShot("And_I_select_next"); filters4(); screenShot("And_I_select_the_Filter_Effects_option"); filtersb5(); screenShot("And_I_select_the_Fun_House_option"); filtersc6(); screenShot("And_I_select_the__Toon__effect"); moveOn7(); screenShot("And_I_select_next");
}}
