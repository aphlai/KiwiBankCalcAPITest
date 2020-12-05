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

	@Regression
	Scenario Outline: Negative value handling
	  # Negative alue appears in either left of right side of input together with both input sides 
	  When User requests a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status OK with value <ExpectedResult>
	Examples:
		| LeftNumber | Operator | RightNumber | ExpectedResult |
		| 20         | +        | -5          | 15             |
		| -20        | +        | 5           | -15            |
		| -20        | +        | -5          | -25            |
		| 20         | -        | -5          | 25             |
		| -20        | -        | 5           | -25            |
		| -20        | -        | -5          | -15            |
		| 5          | -        | 20          | -15            |
		| 20         | *        | -5          | -100           |
		| -20        | *        | 5           | -100           |
		| -20        | *        | -5          | 100            |
		| 20         | /        | -5          | -4             |
		| -20        | /        | 5           | -4             |
		| -20        | /        | -5          | 4              |
	
	@Regression	
	Scenario Outline: Rounding for division
		When User requests a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status OK with value <ExpectedResult>
	Examples:
	  # Issue: The calculator is not rounding division result to the nearest integer, but simply remove decimal part instead (e.g. 50/3 = 16.667 ~=17)
		| LeftNumber | Operator | RightNumber | ExpectedResult |
		| 50         | /        | 3           | 17             |
		| 65         | /        | 16          | 4              |
		| 0          | /        | 17          | 0              |
		
  @Regression	
	Scenario Outline: Operator on large postive/ negative numbers in supported INT32 range
		When User requests a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status OK with value <ExpectedResult>
	Examples: 
		| LeftNumber  | Operator | RightNumber | ExpectedResult |
		| 1           | +        | 2147483646  | 2147483647     |
		| 1           | +        | -2147483648 | -2147483647    |
		| 2147483646  | +        | 1           | 2147483647     |
		| -2147483646 | +        | -2          | -2147483648    |
		| 1073741823  | +        | 1073741824  | 2147483647     |
		| -1073741824 | +        | -1073741824 | -2147483648    |
		| 2147483647  | -        | 1           | 2147483646     |
		| -2147483647 | -        | 1           | -2147483648    |
		| 1           | -        | 2147483647  | -2147483646    |
		| 1           | -        | -2147483646 | 2147483647     |
		| 1073741823  | -        | -1073741824 | 2147483647     |
		| -1073741823 | -        | 1073741824  | -2147483647    |
		| 2147483647  | -        | 2147483647  | 0              |
		| 1073741823  | *        | 2           | 2147483646     |
		| -1073741824 | *        | 2           | -2147483648    |
		| 2           | *        | 1073741823  | 2147483646     |
		| 2           | *        | -1073741824 | -2147483648    |
		| 2147483646  | /        | 2           | 1073741823     |
		| -2147483648 | /        | 2           | -1073741824    |
		| 2147483646  | /        | 1073741823  | 2              |
		| 2147483646  | /        | -1073741823 | -2             |
		| -2147483648 | /        | 1073741824  | -2             |
		| -2147483648 | /        | -1073741824 | 2              |
		