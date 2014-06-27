Then /^I should be redirected to (.*)$/ do |page|
  current_path.should eql path_to page
end