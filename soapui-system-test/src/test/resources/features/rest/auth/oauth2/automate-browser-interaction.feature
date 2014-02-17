@Manual @Acceptance
Feature: As Mark, I can let SoapUI automatically retrieve a new access token for me, if I have added JavaScripts handling the OAuth2 browser interactions, and see information about the interactions in the SoapUI log

  # NOTE: This feature is tested manually because it depends on the Google Tasks API being available.
  # Templates for correct JavaScripts can be found in the file template-scripts-for-google.js

  Scenario: User retrieves an access token using SoapUI and its automation of browser interactions.
    Given Mark has created a REST project with the Google Tasks API
    And has successfully configured his OAuth settings
    And has configured working JavaScripts for both the login screen and the consent screen
    And prompts SoapUI to get an access token
    Then the access token is retrieved automatically, without user interaction with the browser
    And the access token appears in the GUI
    And messages are added to the SoapUI log before and after retrieving a new access token

  Scenario: A new access token is automatically retrieved by SoapUI when the current token has expired.
    Given Mark has created a REST project with the Google Tasks API
    And has successfully configured his OAuth settings
    And has configured working JavaScripts for both the login screen and the consent screen
    And has sent a request to the API successfully
    And has saved the project file
    And has closed SoapUI
    And has edited the project file to change the value of "accessTokenExpirationTime" to 1
    When he opens the project in SoapUI
    And sends a new request to the Google Tasks API
    Then a new access token is retrieved automatically
    And the access token appears in the GUI
    And the request can be sent successfully
    And messages are added to the SoapUI log before and after retrieving a new access token

  Scenario: Access token is automatically retrieved by SoapUI when a test suite is executed.
    Given Mark has created a REST project with the Google Tasks API
    And has successfully configured his OAuth settings
    And has configured working JavaScripts for both the login screen and the consent screen
    And has created a test case
    And has saved the project file
    And has edited the project file to change the value of "accessTokenExpirationTime" to 1 in test step
    When he runs the test case in a test suite using the SoapUI GUI
    Then a new access token is retrieved automatically
    And the request can be sent successfully
    And messages are added to the SoapUI log before and after retrieving a new access token

  Scenario: Access token is automatically retrieved when a test is run from the command line.
    Given Mark has created a REST project with the Google Tasks API
    And has successfully configured his OAuth settings
    And has configured working JavaScripts for both the login screen and the consent screen
    And has created a test case
    And has saved the project file
    And has closed SoapUI
    And has edited the project file to change the value of "accessTokenExpirationTime" to 1 in test step
    When he runs the test case from the command line using testrunner
    Then a new access token is retrieved automatically
    And the request can be sent successfully
    And messages are added to the SoapUI log before and after retrieving a new access token

    # Error flows

  Scenario: User tries to retrieve an access token using automated of browser interactions, but with incorrect automation scripts.
    Given Mark has created a REST project with the Google Tasks API
    And has successfully configured his OAuth settings
    But has configured incorrect JavaScripts
    And prompts SoapUI to get an access token
    Then an error message is displayed in the GUI
    And no access token appears in the GUI
    And an error message is added to the SoapUI log

  Scenario: Access token is not retrieved when a test is run from the command line with incorrect automation scripts.
    Given Mark has created a REST project with the Google Tasks API
    And has successfully configured his OAuth settings
    But has configured incorrect JavaScripts
    And has created a test case
    And has sent a request to the API successfully by running the test case in SoapUI
    And has saved the project file
    And has closed SoapUI
    And has edited the project file to change the value of "accessTokenExpirationTime" to 1 in test step
    When he runs the test case from the command line using testrunner
    Then no new access token is retrieved
    And an error message is added to the SoapUI log

