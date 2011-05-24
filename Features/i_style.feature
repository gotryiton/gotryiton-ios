Feature: 
  As a user
  I want to look at the people I style
  So I can silence/remove them

Scenario:
  I want to view my I Style list from the TODOs page
Given I launch the app
When the user logs in
When I touch the "todos" button
Then I should see "To-Do's"
When I touch the "who i style" button
Then I should see "who i style"
  
Scenario:
  I want to view my I Style list from my profile
  
Scenario:
  I want to activate a stylist request

Scenario:
  I want to ignore a stylist request

Scenario:
  I want to silence a styling requests from someone I style

Scenario:
  I want to un-silence a person I style