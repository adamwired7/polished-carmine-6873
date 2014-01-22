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
