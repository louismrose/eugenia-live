Feature: Create a drawing

  Scenario: Create a blank drawing from a built-in palette
    When I go to the homepage
    And I fill in "name" with "test machine"
    And I select "State Machine" from "palette"
    And I press "Go"
    Then I should be on the drawing editor page
  
  Scenario: Attempt to create a drawing without specifying a name
    When I go to the homepage
    And I select "State Machine" from "palette"
    And I press "Go"
    Then I should be on the homepage
