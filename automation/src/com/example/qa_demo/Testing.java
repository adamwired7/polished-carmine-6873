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



  screenShot("entered_sdk");



}





//When("I select (.*) crop 2 times")

public void selectCrop2() throws UiObjectNotFoundException, InterruptedException {

  String wCrop = "Custom";


  String mode = wCrop + " Crop";



  UiObject cropMode = new UiObject(new UiSelector().description(mode));

  cropMode.click();



  screenShot("crop_button_" + mode);



}

//Given("I have entered the SDK")

public void selectCrop3() throws UiObjectNotFoundException, InterruptedException {

  String wCrop = "Normal";


  String mode = wCrop + " Crop";



  UiObject cropMode = new UiObject(new UiSelector().description(mode));

  cropMode.click();



  screenShot("crop_button_" + mode);



}

//Given("I have entered the SDK")

}
