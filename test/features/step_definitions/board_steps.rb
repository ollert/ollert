Then(/^I should see the following boards:$/) do |table|
  rows = table.rows.group_by {|r| r[0].gsub("\"", "")}
  # table is a Cucumber::Ast::Table
  all(".organization").each do |org|
    actual = org.all(".boards-list-item").map {|x| x.text}
    expected = rows[org.find(".h4").text].map {|r| r[1].gsub("\"", "")}

    expect(expected).to match_array actual
  end
end
