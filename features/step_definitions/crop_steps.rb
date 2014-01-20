Then("the (.*) crop button should display a down state", function(wcrop) {
  expect_equal(Number(target.frontMostApp().mainWindow().buttons()[wcrop].value()),1);
});

When("I select (.*) crop (.*) times", function(wcrop,times) {
  for(var t=0; t<times; t++){
    target.frontMostApp().mainWindow().buttons()[wcrop].tap();
  }
});

Given("I have entered the SDK", function() {
  target.frontMostApp().mainWindow().buttons()["Launch SDK"].tap();
});
