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
    File storePath = new File("/mnt/sdcard/Pictures/automation/" + currentTime + "_" + ofwhat + ".png");
    getUiDevice().takeScreenshot(storePath);
  }

  public int wThen(String testName){
    System.out.println(testName);
    return 0;
  }

/*
  

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

  UiObject demoValidation = new UiObject(new UiSelector().packageName("com.example.qa_demo"));

  assertTrue("Unable to detect Photo Demo App",demoValidation.exists());

  UiObject nextImage = new UiObject(new UiSelector().text("Next Image"));

  nextImage.click();

  UiObject useImage = new UiObject(new UiSelector().text("Use Image"));

  useImage.click();

  screenShot("entered_sdk");

     }



     public void nextButton() throws UiObjectNotFoundException {

     UiObject nextFromCrop = new UiObject(new UiSelector().text("Next"));
     nextFromCrop.click();

     }

     public void backButton() throws UiObjectNotFoundException {
  //for sdk back button (as opposed to device back button)

  UiObject backToCrop = new UiObject(new UiSelector().text("Back"));
  backToCrop.click();
     }

     public void back() {
  //for device back button (as opposed to SDK back button)
  getUiDevice().pressBack();
     }

  // Defined here for command line access (parameters not supported)
  public void noCropOptions() {
  try {
  selectCrop(0,false);
  selectCrop(1,false);
  selectCrop(2,false);
  selectCrop(3,false);
  selectCrop(4,false);
} catch (UiObjectNotFoundException e) {
  // TODO Auto-generated catch block
  e.printStackTrace();
} catch (InterruptedException e) {
  // TODO Auto-generated catch block
  e.printStackTrace();
}
  } 

public void normalCrop() {
  try {
    selectCrop(0,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void squareCrop(){
  try {
    selectCrop(1,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void customCrop(){
  try {
    selectCrop(2,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void threeXTwoCrop(){
  try {
    selectCrop(3,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void threeXFiveCrop(){
  try {
    selectCrop(4,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void selectCrop(int wCrop, boolean shouldShow) throws UiObjectNotFoundException,
       InterruptedException {

         String[] mode;
         mode = new String[5];
         mode[0] = "Normal Crop";
         mode[1] = "Square Crop";
         mode[2] = "Custom Crop";
         mode[3] = "3x2 Crop";
         mode[4] = "3x5 Crop";

         UiObject cropMode = new UiObject(new UiSelector().description(mode[wCrop]));

         if(shouldShow){
           assertTrue("Crop visible "+mode[wCrop],cropMode.exists());
           cropMode.click();
           Thread.sleep(1000);
           screenShot("crop_button_" + mode[wCrop]);
         }
         else {
           assertFalse("Crop not visible "+mode[wCrop],cropMode.exists());
           screenShot("no_crop_button_" + mode[wCrop]);
         }
}

public void noStickers() {
  try {
    selectEffects(0,false);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void noFilters() {
  try {
    selectEffects(1,false);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void noBorders() {
  try {
    selectEffects(2,false);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void noText() {
  try {
    selectEffects(3,false);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void noDraw() {
  try {
    selectEffects(4,false);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void stickers() {
  try {
    selectEffects(0,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void filters() {
  try {
    selectEffects(1,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}
public void borders() {
  try {
    selectEffects(2,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void text() {
  try {
    selectEffects(3,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void draw() {
  try {
    selectEffects(4,true);
  } catch (UiObjectNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void customEffectOrder() throws UiObjectNotFoundException, InterruptedException{
  UiObject allEffects = new UiObject(new UiSelector().description("All Effects"));

  UiObject expectingA = allEffects.getChild(new UiSelector().index(0)).getChild(new UiSelector().index(0));
  UiObject expectingB = allEffects.getChild(new UiSelector().index(1)).getChild(new UiSelector().index(0));
  UiObject expectingC = allEffects.getChild(new UiSelector().index(2)).getChild(new UiSelector().index(0));   

  assertEquals(expectingA.getContentDescription(),"Draw Effects");
  assertEquals(expectingB.getContentDescription(),"Text Effects");
  assertEquals(expectingC.getContentDescription(),"Sticker Effects");
}

public void defaultEffectOrder() throws UiObjectNotFoundException, InterruptedException{
  UiObject allEffects = new UiObject(new UiSelector().description("All Effects"));

  UiObject expectingA = allEffects.getChild(new UiSelector().index(0)).getChild(new UiSelector().index(0));
  UiObject expectingB = allEffects.getChild(new UiSelector().index(1)).getChild(new UiSelector().index(0));
  UiObject expectingC = allEffects.getChild(new UiSelector().index(2)).getChild(new UiSelector().index(0));
  UiObject expectingD = allEffects.getChild(new UiSelector().index(3)).getChild(new UiSelector().index(0));
  UiObject expectingE = allEffects.getChild(new UiSelector().index(4)).getChild(new UiSelector().index(0));

  assertEquals(expectingA.getContentDescription(),"Sticker Effects");
  assertEquals(expectingB.getContentDescription(),"Filter Effects");
  assertEquals(expectingC.getContentDescription(),"Border Effects");
  assertEquals(expectingD.getContentDescription(),"Text Effects");
  assertEquals(expectingE.getContentDescription(),"Draw Effects");
}

public void selectEffects(int wEffect, boolean shouldShow) throws UiObjectNotFoundException,
       InterruptedException {

         String[] mode;
         mode = new String[5];
         mode[0] = "Sticker";
         mode[1] = "Filter";
         mode[2] = "Border";
         mode[3] = "Text";
         mode[4] = "Draw";


         UiObject effectMode = new UiObject(new UiSelector().description(mode[wEffect] + " Effects"));
         if(shouldShow){
           assertTrue("Effect visible "+mode[wEffect],effectMode.exists());
           effectMode.click();
           // Thread.sleep(1000);
           screenShot("effect_button_" + mode[wEffect]);
         }
         else {
           assertFalse("Effect not visible "+mode[wEffect],effectMode.exists());
         }
}



*/








