Cucumber-Style BDD for iOS and Android
========================

### About

This project leverages Behavior Driven Development (BDD) for ios automation testing with Instruments (XCode) and android automation testing with UIAutomator.  Use of this project assumes familiarity with the Instruments UIAutomation tool (https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/UIAutomationRef.pdf) or the Android UIAutomator tool (http://developer.android.com/tools/testing/testing_ui.html).


### How-To

`./run ios APP_NAME` will run the script for all features outlined in the features directory.  The command requires the app name.  Debug access to the app is required.
`./run android APP_NAME` should be used for android.

### Setup

For each feature, create a .feature file in the features directory.  Explain the feature at the top of the file starting with the *Feature:* keyword followed by the feature name.

Each feature should be explained in more detail on the following lines using a behavior-driven explanation for the business value.

     Feature: Crop
          In order to reformat my image
          As someone who has taken a photo or selected a photo from the gallery
          I want to be able to crop my image
          
Once the feature has been explained, write scenarios for that feature.  Start each line with *Given* (preconditions), *When* (user actions), or *Then* (expected results).   Each line should be one of each.  
*And* can be used to avoid repeating any of the other keywords (Given x, Given x, When Y, Then z Given vs. Given x, And x, When Y, Then z ).

          Scenario: Normal crop
               Given I have entered the SDK
               When I select "Normal" crop 2 times
               Then the "Normal" crop button should display a down state
          
          Scenario: Custom crop then normal crop
               Given I have entered the SDK
               When I select "Custom" crop 2 times
               And I select "Normal" crop 2 times
               Then the "Normal" crop button should display a down state
               
For each feature, create a {feature}_steps.rb file in the step_definitions directory [ within the features directory ].

### iOS

Create step definitions that match each line/step in the scenario with the following javascript method:

     Given("{STEP}", function() {
          {JAVASCRIPT}
     });


Here's a real example:

     Given("I have entered the SDK", function() {
          target.frontMostApp().mainWindow().buttons()["Launch SDK"].tap();
     });

*Given*, *When*, and *Then* are all interchangeable with respect to the syntax, though each carry their own literal value.  Step definitions for *And* steps should be created with the *Given*, *When*, or *Then* that they correspond to.

Regular expressions allow for shared use of step definitions.  For instance, the following could be used for a step definition requiring the "Normal" crop button or the "Custom" crop button.

     Then("the (.*) crop button should display a down state", function(wcrop) {
          expect_equal(Number(target.frontMostApp().mainWindow().buttons()[wcrop].value()),1);
     });

Parameters used in the method may be declared within the method declaration.

A couple built in validations exist:

- expect_equal(a,b) - compare the value of two things
- expect_valid(a) - validate whether an object exists or not
- expect_visible(a) - validate whether an object is visible or not

### Android

Create step definitions that mach each line/step in the scenario with the following java format:

    //Given("{STEP}")
    public void methodName() throws UIUiObjectNotFoundException, InterruptedException {
        {JAVA}
    }

Here's a real example:

    //When("I select (.*) crop 2 times")
    public void selectCrop(String wCrop) throws UiObjectNotFoundException, InterruptedException {
  
        String mode = wCrop + " Crop";
    
        UiObject cropMode = new UiObject(new UiSelector().description(mode));
        cropMode.click(); 
      
        screenShot("crop_button_" + mode);
    }

As with iOS, *Given* *When* and *Then* are all interchangeable.  Step definitions with *And* should be created with one of the former keywords.
