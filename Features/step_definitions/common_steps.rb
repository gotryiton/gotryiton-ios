Given /^I am logged in$/ do
  open_url("gtio://login")
  app_exec("franklyLogin")
  sleep 1
end

Given /^I am not logged in$/ do
  app_exec("franklyLogoutUser")
  relaunch_app
end

Then /^I should see the "([^\"]*)"$/ do |screen_name|
  check_element_exists("view accessibilityLabel:'#{screen_name}'")
end

Given /^I am on the "([^\"]*)"$/ do |screen_name|
  case screen_name
  when "Welcome Screen"
    open_url("gtio://welcome")
  when "Profile Screen"
    open_url("gtio://profile")
  end
end

Given /^I touch the "([^\"]*)" button$/ do |button_name|
  Given "I press the \"#{button_name}\" button"
end

Given /^I press the "([^\"]*)" button$/ do |button_name|
  check_element_exists("button accessibilityLabel:'#{button_name}'")
  touch("button accessibilityLabel:'#{button_name}'")
end