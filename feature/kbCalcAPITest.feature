#Author: anthony0lai@gmail.com
#Keywords Summary : 
#Feature: KiwiBank Calculator API test

@KiwiSaverCalcTest
Feature: Kiwibank Calculator API test
		
	@Sanity
	Scenario: Basic Calculation using different operators
	  When User requests a calculcation of 4 + 3
	  Then Response with status OK with value 7
