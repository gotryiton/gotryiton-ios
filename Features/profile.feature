Feature: 
  As a user
  I want to be able to see the profile screen
  So I can edit my own profile or add other people as stylists

Scenario: 
    Viewing my profile
Given I launch the app
And I am logged in
And I am on the "Profile Screen"
Then I should see the "about me label"
And I should see the "profile header view"
And I should see the "name label"
And I should see the "location label"
And I should see the "edit profile button"
And I should see the "profile picture view"

Scenario: 
    Editing my profile
Given I launch the app
And I am logged in
And I am on the "Profile Screen"
And I press the "edit profile button" button
And I should see the "edit profile"

Scenario: 
    Editing my profile
Given I launch the app
And I am logged in
And I am on the "Profile Screen"
And I press the "edit profile picture" button
And I should see the "edit profile picture"





