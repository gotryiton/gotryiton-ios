Feature: 
  As a user
  I want to be able to see the browse screen
  So I can check out other peoples looks and stuff.

Scenario: 
    Viewing my looks
Given I launch the app
And I am logged in
And I am on the "Home Screen"
And I press the "browse" button
Then I should see the "Browse Screen"