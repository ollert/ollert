@existing_lists @javascript
Feature: Looking at time spent in lists

Scenario: Time in lists honors the start and end of work
  Given I am viewing the board "Test Board #1"
  When my work begins with "List #2" and ends with "List #4"
  Then my Time Spent in Lists should start with "List #2" and end with "List #3"
