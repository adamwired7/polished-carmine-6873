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

//When("I select (.*) crop (.*) times")
//When("I select (.*) crop (.*) times")
public void selectCrop2() throws UiObjectNotFoundException, InterruptedException {

  String wCrop = "Normal";
   int times = 1;

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

//When("I select the (.*) (.*) option")
//When("I select the (.*) (.*) option")
public void filtersb4() throws UiObjectNotFoundException, InterruptedException {

  String wOption_word = "Filter";
   String wOption_word_b = "Effects";
  UiObject effectMode = new UiObject(new UiSelector().description(wOption_word+" "+wOption_word_b));
  effectMode.click();
}

//When("I select the (.*) effect")
//When("I select the (.*) (.*) option")
public void filtersb5() throws UiObjectNotFoundException, InterruptedException {

  String wOption_word = "Fun";
   String wOption_word_b = "House";
  UiObject effectMode = new UiObject(new UiSelector().description(wOption_word+" "+wOption_word_b));
  effectMode.click();
}

//When("I select the (.*) effect")
//When("I select the (.*) effect")
public void filtersc6() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Toon";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select the (.*) effect")
public void filtersc7() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Sketch";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select the (.*) effect")
public void filtersc8() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Buldge";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select the (.*) effect")
public void filtersc9() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Swirl";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select the (.*) effect")
public void filtersc10() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Emboss";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select the (.*) effect")
public void filtersc11() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Pinch";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select the (.*) effect")
public void filtersc12() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Stretch";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select the (.*) effect")
public void filtersc13() throws UiObjectNotFoundException, InterruptedException {

  String wEffect = "Chalk";
UiScrollable allItems = new UiScrollable(new UiSelector().scrollable(true));
allItems.setAsHorizontalList(); 
  allItems.scrollIntoView(new UiSelector().description(wEffect));
  UiObject effectMode = new UiObject(new UiSelector().description(wEffect));
 effectMode.click();
}
//Given("I have entered the SDK")
//When("I select next")
public void moveOn14() throws UiObjectNotFoundException, InterruptedException {

  UiObject nextFromCrop = new UiObject(new UiSelector().text("Next"));
   nextFromCrop.click();
}

//When("I select the (.*) (.*) option")
public void runAll() throws UiObjectNotFoundException, InterruptedException, IOException {
 enterSDK1(); screenShot("Given_I_have_entered_the_SDK"); selectCrop2(); screenShot("And_I_select__Normal__crop_1_times"); moveOn3(); screenShot("And_I_select_next"); filtersb4(); screenShot("And_I_select_the__Filter___Effects__option"); filtersb5(); screenShot("And_I_select_the__Fun___House__option"); filtersc6(); screenShot("And_I_select_the__Toon__effect"); filtersc7(); screenShot("And_I_select_the__Sketch__effect"); filtersc8(); screenShot("And_I_select_the__Buldge__effect"); filtersc9(); screenShot("And_I_select_the__Swirl__effect"); filtersc10(); screenShot("And_I_select_the__Emboss__effect"); filtersc11(); screenShot("And_I_select_the__Pinch__effect"); filtersc12(); screenShot("And_I_select_the__Stretch__effect"); filtersc13(); screenShot("And_I_select_the__Chalk__effect"); moveOn14(); screenShot("And_I_select_next");
}}
