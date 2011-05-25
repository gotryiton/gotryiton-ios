Feature: 
  As a user
  I want to be able to see the reviews screen
  So I can see other peoples reviews and add my own

Scenario: 
    Viewing my profile
Given I launch the app
And I am logged in
And I am on the "Outfit Screen"
And I press the "reviews" button
Then I should see the "Reviews Screen"
