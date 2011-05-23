Given /^I am logged in$/ do
  open_url("gtio://login")
  app_exec("franklyLogin")
  sleep 3
end

Then /^I should see the "([^\"]*)" label$/  do |label_name|
  check_element_exists("view accessibilityLabel:'#{label_name}'")
end