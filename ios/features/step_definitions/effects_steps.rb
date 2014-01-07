Then("the (.*) button should not display a down state", function() {
  expect_equal(Number(target.frontMostApp().mainWindow().buttons()[7].value()),0);
});

When("I select the (.*) option", function(wbutton) {
  target.frontMostApp().toolbar().buttons()[wbutton].tap();
});

When("I select effect button (.*) for (.*)", function(buttonVal,buttonName) {
  target.frontMostApp().mainWindow().buttons()[buttonVal].tap();
});

Given("I have entered the SDK", function() {
  target.frontMostApp().mainWindow().buttons()["Launch SDK"].tap();
});
