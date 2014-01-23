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
Given("I have entered the SDK", function() {
  target.frontMostApp().mainWindow().buttons()["Launch SDK"].tap();

});
Then("I should see Launch SDK", function() {
  expect_visible(target.frontMostApp().mainWindow().buttons()["Launch SDK"]);
});

When("I select apply", function(){
  target.frontMostApp().toolbar().buttons()["Apply"].tap();

});

When("I select next", function() {
  target.frontMostApp().mainWindow().buttons()["btn next"].tap();
});

Given("I have entered the SDK", function() {
  target.frontMostApp().mainWindow().buttons()["Launch SDK"].tap();
});
Then("I should see Launch SDK", function() {
  expect_visible(target.frontMostApp().mainWindow().buttons()["Launch SDK"]);
});

When("I select apply", function(){
  target.frontMostApp().toolbar().buttons()["Apply"].tap();
});

When("I select next", function() {
  target.frontMostApp().mainWindow().buttons()["btn next"].tap();

});

Given("I have entered the SDK", function() {
  target.frontMostApp().mainWindow().buttons()["Launch SDK"].tap();
});
Then("I should see Launch SDK", function() {
  expect_visible(target.frontMostApp().mainWindow().buttons()["Launch SDK"]);

});

When("I select apply", function(){
  target.frontMostApp().toolbar().buttons()["Apply"].tap();
});

When("I select next", function() {
  target.frontMostApp().mainWindow().buttons()["btn next"].tap();
});

Given("I have entered the SDK", function() {
  target.frontMostApp().mainWindow().buttons()["Launch SDK"].tap();
});
public void runAll() throws UiObjectNotFoundException, InterruptedException, IOException {

}}
