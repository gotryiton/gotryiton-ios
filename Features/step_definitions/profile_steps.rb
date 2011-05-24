
Then /^"([^"]*)" should have a url "([^"]*)"$/ do |label, url|
  check_element_exists("view accessibilityLabel:'#{label}'")
  value = frankly_map("view accessibilityLabel:'#{label}'", 'urlPath')
  value.should include(url)
end