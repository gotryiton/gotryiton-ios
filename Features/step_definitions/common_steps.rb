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
  when "Home Screen"
    open_url("gtio://home")
  when "Outfit Screen"
    open_url("gtio://looks/E6B67F6")    
  end
  
end

Given /^I touch the "([^\"]*)" bar button$/ do |button_name|
  check_element_exists("view accessibilityLabel:'#{button_name}'")
  touch("view accessibilityLabel:'#{button_name}'")
end

Given /^I touch the "([^\"]*)" button$/ do |button_name|
  Given "I press the \"#{button_name}\" button"
end

Given /^I press the "([^\"]*)" button$/ do |button_name|
  check_element_exists("button accessibilityLabel:'#{button_name}'")
  touch("button accessibilityLabel:'#{button_name}'")
end

When /^I type "([^\"]*)" into "([^\"]*)"$/ do |text_to_type, field_name|
  text_fields_modified = frankly_map( "textField accessibilityLabel:'#{field_name}'", "setText:", text_to_type )
  raise "could not find text fields with placeholder '#{field_name}'" if text_fields_modified.empty?
  #TODO raise warning if text_fields_modified.count > 1
end

