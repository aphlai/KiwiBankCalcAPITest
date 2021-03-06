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

  @Regression	
	Scenario Outline: Scientific notation input support
		When User requests a calculcation with unsupported input value format of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status OK with value <ExpectedResult>
	Examples:
		# Test includes scentific notataion only on left side, only on right side, and on both sides of input for all operators
		# Skipped test cases with scentific notation input value with more than 3 digits due to issue found above (e.g. 2.5e3) 
		| LeftNumber | Operator | RightNumber | ExpectedResult |
		| 3E0        | +        | 200         | 203            |
		| 100        | +        | 2e3         | 2100           |
		| 1e2        | +        | 2E3         | 2100           |
		| 3e3        | -        | 5           | 2995           |
		| 300        | -        | 5E0         | 295            |
		| 3E3        | -        | 5e1         | 2950           |
		| 4e3        | *        | 100         | 40000          |
		| 400        | *        | 1E2         | 40000          |
		| 4E3        | *        | 1e2         | 40000          |
		| 25         | /        | 5e0         | 5              |
		| 1e2        | /        | 25          | 4              |
		| 1e3        | /        | 5E2         | 2              |		

  @Advanced @NonFunc	
	Scenario Outline: Input underflow and overflow handling
		When User requests a calculcation with unsupported input value format of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status Error with value N/A
	Examples:
		| LeftNumber   | Operator | RightNumber  | ExpectedResult |
		| 3            | +        | -2147483650  | -2147483647    |
		| 2147483650   | +        | -3           | 2147483647     |
		| 2147483650   | +        | -2147483650  | 0              |
		| 3            | -        | 2147483650   | -2147483647    |
		| -2147483650  | -        | -3           | -2147483647    |
		| 2147483650   | -        | 2147483649   | 1              |
	
	@Advanced @NonFunc	
	Scenario Outline: Output underflow and overflow handling
	# Issue: Returns wrong value once output is overflow with status OK (200).  Expecting either
	# * Response proper error status code
	# * Return correct value if response statud code is OK (200)
		When User requests a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status OK with value <ExpectedResult>
	Examples:
		| LeftNumber   | Operator | RightNumber  | ExpectedResult |
		| 3            | +        | 2147483647   | 2147483650     |
		| -2147483647  | +        | -3           | -2147483650    |
		| -3           | -        | 2147483647   | -2147483650    |
		| 3            | -        | -2147483647  | 2147483650     |
		| 2147483647   | *        | 2            | 4294967294     |
		| -2           | *        | 2147483647   | -4294967294    |
	
	@Advanced @NonFunc	
	Scenario Outline: Request with wrong auth. secret
		When User requests a calculcation of 1 + 1 using wrong authentication secret
	  Then Response with status Unauthorized with value N/A
	  
	@Advanced @NonFunc	
	Scenario Outline: Request with wrong auth. header
		When User requests a calculcation of 1 + 1 using wrong authentication header
	  Then Response with status Unauthorized with value N/A
	  
	@Advanced @NonFunc	
	Scenario Outline: Request without auth. header at all
		When User requests a calculcation of 1 + 1  without authentication header
	  Then Response with status Unauthorized with value N/A

	@Advanced @NonFunc	
	Scenario Outline: Hex. number support
	  # Limitation: JSON does not officially support hex. number.  JSONObject library cannot pass hex. number as integer, but as string with quote (')
		When User requests a calculcation with unsupported input value format of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status OK with value <ExpectedResult>
	Examples:
		| LeftNumber | Operator | RightNumber   | ExpectedResult |
		| 0xF        | +        | 0xe           | 29             |
		| 0xd        | -        | 0xf           | -2             |
		| 0xf        | *        | 0xd           | 195            |
		| 0x12       | /        | 0x2           | 9              |
	
	@Advanced @NonFunc	
	Scenario Outline: Calculation using unsupported operators
	# Issue: API response status code wrongly returns not found (404) insteaad of a proper error (500)
	  When User requests a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status Error with value N/A
	Examples:
		| LeftNumber | Operator | RightNumber |
		| 1          | plus     | 2           |
		| 9          | subtract | 5           |
		| 4          | times    | 5           |
		| 18         | divide   | 3           |
		| 4          | x        | 5           |
		
	@Advanced @NonFunc	
	Scenario Outline: Calculation using unsupported request method GET
	# Issue: API response status code wrongly returns not found (404) insteaad of a proper error (500)
	  When User requests by GET method for a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status Error with value N/A
	Examples:
		| LeftNumber | Operator | RightNumber |
		| 1          | +        | 2           |
		| 9          | -        | 5           |
		| 4          | *        | 5           |
		| 18         | /        | 3           |
		
	@Advanced @NonFunc	
	Scenario Outline: Calculation using unsupported request body
	# Issue: API response status code wrongly returns not found (404) insteaad of a proper error (500)
	  When User requests by an unsupported body for a calculcation of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status Error with value N/A
	Examples:
		| LeftNumber | Operator | RightNumber |
		| 1          | +        | 2           |
		| 9          | -        | 5           |
		| 4          | *        | 5           |
		| 18         | /        | 3           |
		
	@Advanced @NonFunc
	Scenario Outline: Proper error handling using unsupported non-integer number as input
	  When User requests a calculcation with unsupported input value format of <LeftNumber> <Operator> <RightNumber>
	  Then Response with status Error with value N/A
	Examples:
		| LeftNumber | Operator | RightNumber |
		| 1.3        | +        | 2           |
		| 1          | +        | 2.3         |
		| 1.3        | +        | 2.3         |
		| 9.1        | -        | 5           |
		| 9          | -        | 5.1         |
		| 9.1        | -        | 5.1         |
		| 4.4        | *        | 5           |
		| 4          | *        | 5.4         |
		| 4.4        | *        | 5.4         |
		| 18         | /        | 3.5         |
		| 18.5       | /        | 3           |
		| 18.5       | /        | 3.5         |