Feature: Crop
  In order to reformat my image 
  As someone who has taken a photo or selected a photo from the gallery
  I want to be able to crop my image

  Scenario: All crop and all effects
    Given I have entered the SDK
    And I select "Normal" crop 2 times
    And I select next
    And I select the Filter Effects option
    And I select the Fun House option
    And I select the "Toon" effect
    And I select next
