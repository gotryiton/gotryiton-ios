Feature: 
  As a user
  I want to be able to see the my looks screen
  So I can check out how cool i look

Scenario: 
    Viewing my looks
Given I launch the app
And I am logged in
And I am on the "Home Screen"
And I press the "my looks" button
Then I should see the "Browse Screen"
When I touch the first table cell
Then I should see the "Outfit Screen"