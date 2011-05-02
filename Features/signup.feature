Feature: 
  As a user
  I want to signup for an account
  So I can use all the cool features of GTIO

Scenario: 
    Launching the app for the first time
Given I launch the app
And I am not logged in
And I launch the app
Then I should see the "Welcome Screen"

Scenario:
  Logging in from the Welcome Screen
Given I am on the "Welcome Screen"
And I press the "LOG IN / SIGN UP" button
Then I should see the "Login Screen"
