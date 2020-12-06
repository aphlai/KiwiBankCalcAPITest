package com.kbCalcAPI.StepDefinitions;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import org.json.simple.JSONObject;
import org.testng.Assert;

import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.response.ResponseBody;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import static io.restassured.RestAssured.*;


public class kbCalcAPITestStepDefinition {
	private Properties apiProp;
	private FileInputStream inPropFile;
	private String baseUrl;
	private String apiAuthHeader;
	private String apiWrongAuthHeader;
	private String apiAuthSecret;
	private String apiWrongAuthSecret;
	private int lastRespStatusCode;
	private ResponseBody lastRespBody;
	
	final int statusCodeOK = 200;
	final int statusCodeErr = 500;
	final int statusCodeUnauth = 401;
	final int statusCodeNotFound = 404;
	
	
	
	@When("^User requests a calculcation of (.*) (.*) (.*)$")
	public void userRequest(String leftNumber, String calOperator, String rightNumber)
	{
		String requestBody = this.genRequestBody(leftNumber, calOperator, rightNumber);
		this.genRequest(requestBody);
	}
	
	@When("^User requests by GET method for a calculcation of (.*) (.*) (.*)$")
	public void userRequestWithGETMethod(String leftNumber, String calOperator, String rightNumber)
	{
		String requestBody = this.genRequestBody(leftNumber, calOperator, rightNumber);
		this.genRequestUsingGET(requestBody);
	}
	
	@When("^User requests a calculcation of (.*) (.*) (.*) using wrong authentication secret$")
	public void userRequestWrongSecret(String leftNumber, String calOperator, String rightNumber)
	{
		String requestBody = this.genRequestBody(leftNumber, calOperator, rightNumber);
		this.genRequestWithWrongAuthSecret(requestBody);
	}
	
	@When("^User requests a calculcation of (.*) (.*) (.*) using wrong authentication header$")
	public void userRequestWrongAuthHeader(String leftNumber, String calOperator, String rightNumber)
	{
		String requestBody = this.genRequestBody(leftNumber, calOperator, rightNumber);
		this.genRequestWithWrongAuthHeader(requestBody);
	}
	
	@When("^User requests a calculcation of (.*) (.*) (.*) without authentication header$")
	public void userRequestNoAuthHeader(String leftNumber, String calOperator, String rightNumber)
	{
		String requestBody = this.genRequestBody(leftNumber, calOperator, rightNumber);
		this.genRequestWitNoAuthHeader(requestBody);
	}
	
	private void genRequestWitNoAuthHeader(String requestBody)
	{
		Response resp = given()
				.contentType(ContentType.JSON)
	            .accept(ContentType.JSON)
	            .body(requestBody)
	            .when().post(this.baseUrl)
	            .then().extract().response();
		this.lastRespBody = resp.body();
		this.lastRespStatusCode = resp.statusCode();
	}
	
	private void genRequestUsingGET(String requestBody)
	{
		Response resp = given()
				.contentType(ContentType.JSON)
	            .accept(ContentType.JSON)
	            .header(this.apiAuthHeader, this.apiAuthSecret)
	            .body(requestBody)
	            .when().get(this.baseUrl)
	            .then().extract().response();
		this.lastRespBody = resp.body();
		this.lastRespStatusCode = resp.statusCode();
	}
	
	private void genRequest(String requestBody)
	{
		Response resp = given()
				.contentType(ContentType.JSON)
	            .accept(ContentType.JSON)
	            .header(this.apiAuthHeader, this.apiAuthSecret)
	            .body(requestBody)
	            .when().post(this.baseUrl)
	            .then().extract().response();
		this.lastRespBody = resp.body();
		this.lastRespStatusCode = resp.statusCode();
	}
	
	private void genRequestWithWrongAuthHeader(String requestBody)
	{
		Response resp = given()
				.contentType(ContentType.JSON)
	            .accept(ContentType.JSON)
	            .header(this.apiWrongAuthHeader, this.apiAuthSecret)
	            .body(requestBody)
	            .when().post(this.baseUrl)
	            .then().extract().response();
		this.lastRespBody = resp.body();
		this.lastRespStatusCode = resp.statusCode();
	}
	
	private void genRequestWithWrongAuthSecret(String requestBody)
	{
		Response resp = given()
				.contentType(ContentType.JSON)
	            .accept(ContentType.JSON)
	            .header(this.apiAuthHeader, this.apiWrongAuthSecret)
	            .body(requestBody)
	            .when().post(this.baseUrl)
	            .then().extract().response();
		this.lastRespBody = resp.body();
		this.lastRespStatusCode = resp.statusCode();
	}
	
	@Then("^Response with status (OK|Error|Unauthorized|NotFound) with value (.*)")
	public void validateResponse(String expRespStatus, String expRespValue)
	{
		int expectedStatusCode = 0;
		switch(expRespStatus)
		{
			case "OK":
				expectedStatusCode = statusCodeOK;
				break;
			case "Error":
				expectedStatusCode = statusCodeErr;
				break;
			case "Unauthorized":
				expectedStatusCode = statusCodeUnauth;
				break;
			case "NotFound":
				expectedStatusCode = statusCodeNotFound;
				break;
		}
		Assert.assertEquals(this.lastRespStatusCode, expectedStatusCode, "Response status not as expected -- ");
		
		if (this.lastRespStatusCode == statusCodeOK)
		{
			// Only expect value in response body when status is OK
			Assert.assertEquals(this.lastRespBody.jsonPath().get("value").toString(), expRespValue, "Calculated value is not as expected -- ");
		}
	}
	
	
	private String genRequestBody(Integer leftNumber, String calOperator, Integer rightNumber)
	{
		JSONObject requestJSON = new JSONObject();
		requestJSON.put("LeftNumber", leftNumber);
		requestJSON.put("RightNumber", rightNumber);
		requestJSON.put("Operator", calOperator);
		return requestJSON.toJSONString();
	}
	
	private String genRequestBody(String leftNumber, String calOperator, String rightNumber)
	{
		JSONObject requestJSON = new JSONObject();
		requestJSON.put("LeftNumber", leftNumber);
		requestJSON.put("RightNumber", rightNumber);
		requestJSON.put("Operator", calOperator);
		return requestJSON.toJSONString();
	}
	
	@Before
	public void beforeScenario() throws IOException {
		apiProp = new Properties();
		inPropFile = new FileInputStream("config/apiService.properties");
		apiProp.load(inPropFile);
		this.baseUrl = apiProp.getProperty("baseUri");
		this.apiAuthHeader = apiProp.getProperty("authHeader");
		this.apiAuthSecret = apiProp.getProperty("authSecret");
		this.apiWrongAuthHeader =apiProp.getProperty("falseAuthHeader");
		this.apiWrongAuthSecret = apiProp.getProperty("falseAuthSecret");
	}
	@After
	public void afterScenario() throws IOException {
		inPropFile.close();
	}
}
