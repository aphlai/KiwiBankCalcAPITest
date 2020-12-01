$(document).ready(function() {var formatter = new CucumberHTML.DOMFormatter($('.cucumber-report'));formatter.uri("kbCalcAPITest.feature");
formatter.feature({
  "comments": [
    {
      "line": 1,
      "value": "#Author: anthony0lai@gmail.com"
    },
    {
      "line": 2,
      "value": "#Keywords Summary :"
    },
    {
      "line": 3,
      "value": "#Feature: KiwiBank Calculator API test"
    }
  ],
  "line": 6,
  "name": "Kiwibank Calculator API test",
  "description": "",
  "id": "kiwibank-calculator-api-test",
  "keyword": "Feature",
  "tags": [
    {
      "line": 5,
      "name": "@KiwiSaverCalcTest"
    }
  ]
});
formatter.before({
  "duration": 345000,
  "status": "passed"
});
formatter.scenario({
  "line": 9,
  "name": "Basic Calculation using different operators",
  "description": "",
  "id": "kiwibank-calculator-api-test;basic-calculation-using-different-operators",
  "type": "scenario",
  "keyword": "Scenario",
  "tags": [
    {
      "line": 8,
      "name": "@Sanity"
    }
  ]
});
formatter.step({
  "line": 10,
  "name": "User requests a calculcation of 4 + 3",
  "keyword": "When "
});
formatter.step({
  "line": 11,
  "name": "Response with status OK with value 7",
  "keyword": "Then "
});
formatter.match({
  "arguments": [
    {
      "val": "4",
      "offset": 32
    },
    {
      "val": "+",
      "offset": 34
    },
    {
      "val": "3",
      "offset": 36
    }
  ],
  "location": "kbCalcAPITestStepDefinition.userRequest(String,String,String)"
});
formatter.result({
  "duration": 2188151100,
  "status": "passed"
});
formatter.match({
  "arguments": [
    {
      "val": "OK",
      "offset": 21
    },
    {
      "val": "7",
      "offset": 35
    }
  ],
  "location": "kbCalcAPITestStepDefinition.validateResponse(String,String)"
});
formatter.result({
  "duration": 408936000,
  "status": "passed"
});
formatter.after({
  "duration": 57200,
  "status": "passed"
});
});