#Author: anthony0lai@gmail.com
#Keywords Summary : 
#Feature: KiwiBank Calculator API test

@KiwiSaverCalcTest
Feature: Kiwibank Calculator API test
		
	@Sanity
	Scenario Outline: Basic Calculation using different operators
	  When User requests a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status OK with value <ExpectedResult>
	Examples:
		| LeftNumber | Operator | RightNumber | ExpectedResult |
		| 1          | +        | 2           | 3              |
		| 9          | -        | 5           | 4              |
		| 4          | *        | 5           | 20             |
		| 18         | /        | 3           | 6              |
