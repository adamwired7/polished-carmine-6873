here2
Feature: Build Regression
  In order to ensure that the app does not crash when upgrading from an older build
  As someone who is responsible for the app
  I want to be able to quickly run through the core views

  Scenario: Proceed through views
    Given I have entered the SDK
    When I select apply
    And I select next
    Then I should see Launch SDK

here1
