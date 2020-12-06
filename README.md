# Project Title

The project is for demonstrating technical understanding on web automation testing using Twitter page

### Installation
* Install the latest Firefox
* Install the latest Java Runetime Environment
* Install [maven](https://maven.apache.org/install.html) on test clientA step by step series of examples that tell you have to get a development env running
* Copy [Firefox/ Mozilla GeckoDriver plug-in](https://github.com/mozilla/geckodriver/) to sub-folder under this project
* Update `browserDriverPath` in `files/browse.properties` for the above plug-in location (Default -- lib/geckodriver) 
* Update `validTwitterUsername` in `files/page.properites` using your Twitter account username (Not email address)
* Update `validTwitterPassword` in `files/page.properites` using your Twitter account password

## Running the tests
* In project root folder, execute "mvn install" in command line will run the test scenarios
* HTML test report will be generated in target/cucumber-reports/cucumber-pretty/index.html after test finished

## What have been done
* The test execution is triggered by maven surefire (plugin in pom.xml), which points to TestNG test framework
* TestNG contains a single test step to run Cucumber (src/TweetTestMain.java), which scans through BDD feature files for test scenarios
* The test scenarios post Tweets using different GUI methods and contents, and response to these posted Tweets (e.g. Like, Retweet/ reply) 

## How I work on this automation test
* I study Twitter website manually to understand the expected GUI behavior with corresponding HTML change
* With current behaviour as acceptance criteria, BDD test scenarios are then constructed
* Without further input on acceptance criteria,  the current behaviour is regarded as criteria unless behaviour is inconsistent
* The BDD test scenarios are then automated using step definitions and page object models
* To ensure messages used are unique, timestamps are automatically added to Tweet messages 

## What I have learned
* Cost estimation on testing complex web pages with unknown behavior
* Better structuring of test programs by reusing WebElement and workflows of the similar structures (e.g. Tweet searching in main page and my own Tweet page)

## Challenges
* The expected behavior is not well documented.  For example GUI for retweet with and without comment are completely different
* Newly posted Tweets/ counters are not updated in the page immediately.  Waiting for other GUI events/ switching between pages will help a bit.
* GUI is not consistent for Tweet display.  For example quoted message in replies are only shown sometimes
* Long and varied delays are found in GUI actions.  Use web driver explicit wait decouples unnecessary long wait nor hardcoding waiting time

### Result

> > 2 Test scenarios failed.  All other 10 test scenarios passed --

> > In failed test scenario `Post message chain and immediately switch to another page to read the Tweets`
> > * It is expected that all Tweet messages in a newly posted message chain will be displayed
> > * However, if I try to read the Tweets immediately after the post, only part of the newly posted Tweets are found 
> > * Switch to other page attempting refresh the GUI does not help
> > * Further investigation found that only part of the Tweets in the message chain got posted (i.e. some Tweets are lost permanently)
> >
> > In failed test scenario `Reply an existing Tweet`
> > * It is expected that reply counter in tweet messages GUI will increase after reply
> > * However, it is found that the counter does not increase after reply has been made 
> > * Switch to other page attempting refresh the GUI does not help
> > * Further investigation found that update to this counter  can take a few minutes to be done

## Tools and framework used

- [Java](https://www.java.com) - Java programming language
- [Eclipse](https://www.eclipse.org/ide/) - Java project IDE
- [Maven](https://maven.apache.org/) - Dependency Management
- [Cucumber](https://cucumber.io) - BDD framework
- [TestNG](http://testng.org/doc/) - Testing framework
- [Selenium](https://www.seleniumhq.org) - Browser test automation suite
- Selenium Page Factory and Page Object Model

## Authors

* **Anthony Lai**
