Feature: Effects
  In order to reformat my image 
  As someone who has taken a photo or selected a photo from the gallery and cropped
  I want to be able to add effects

  Scenario: Filters
    Given I have entered the SDK
    And I select the "Apply" option
    When I select effect button 7 for "filters"
    And I select effect button 8 for "borders"
    And I select effect button 9 for "stickers"
    And I select effect button 10 for "text"
    And I select effect button 11 for "draw"
    Then the "Filters" button should not display a down state
