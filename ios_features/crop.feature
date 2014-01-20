Feature: Crop
  In order to reformat my image 
  As someone who has taken a photo or selected a photo from the gallery
  I want to be able to crop my image

  Scenario: Normal crop
    Given I have entered the SDK
    When I select "Normal" crop 2 times
    Then the "Normal" crop button should display a down state

  Scenario: Custom crop then normal crop
    Given I have entered the SDK
    When I select "Custom" crop 2 times
    And I select "Normal" crop 2 times
    Then the "Normal" crop button should display a down state
