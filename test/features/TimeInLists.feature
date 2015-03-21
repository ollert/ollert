@existing_lists @javascript
Feature: Looking at time spent in lists

@wip
Scenario: Time in lists honors the start and end of work
  Given I am viewing the board "Test Board #1"
  When my work begins with "List #2" and ends with "List #3"
  Then my Time Spent in Lists honors my beginning and end of work settings