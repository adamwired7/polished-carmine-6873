Feature: Effects
  In order to customize my image
  As someone who has taken and formatted an image
  I want to be able to add effects to my image

  Scenario: All crop and all effects
    Given I have entered the SDK
    And I select "Normal" crop 1 times
    And I select next
    And I select the "Filter" "Effects" option
    And I select the "Fun" "House" option
    And I select the "Toon" effect
    And I select the "Sketch" effect
    And I select the "Buldge" effect
    And I select the "Swirl" effect
    And I select the "Emboss" effect
    And I select the "Pinch" effect
    And I select the "Stretch" effect
    And I select the "Chalk" effect
    And I select next
