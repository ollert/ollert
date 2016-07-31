@existing_lists @javascript
Feature: Looking at time spent in lists

Background:
  Given I am viewing the board "Test Board #1"
  When my work begins with "List #2" and ends with "List #4"

Scenario: Time in lists honors the start and end of work
  Then my Time Spent in Lists should start with "List #2" and end with "List #3"

Scenario: Time in lists ignores archived cards
  Given all of my cards have been archived
  When I refresh my view
  Then my Time Spent in Lists should reflect nothing, since all my cards are archived
