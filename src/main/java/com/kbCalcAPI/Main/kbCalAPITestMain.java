package com.kbCalcAPI.Main;

import org.testng.annotations.Test;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;
import cucumber.api.CucumberOptions;
import cucumber.api.testng.TestNGCucumberRunner;

@CucumberOptions(
        features = "feature/",
        glue = {"com.kbCalcAPI.StepDefinitions"},
        tags = {"~@Ignore"},
        format = {
                "pretty",
                "html:target/cucumber-reports/cucumber-pretty",
                "json:target/cucumber-reports/CucumberTestReport.json",
                "rerun:target/cucumber-reports/rerun.txt"
        })


public class kbCalAPITestMain {
	private TestNGCucumberRunner cucumberRunner;
	  
	@Test(groups="cucumber",description="Runs Cucumber Features")
	public void mainTest() {
		this.cucumberRunner.runCukes();
		System.out.println("**** test *****");
	}
	
	@BeforeClass(alwaysRun = true)
	public void beforeClass() {
		this.cucumberRunner = new TestNGCucumberRunner(this.getClass());
	}

	@AfterClass(alwaysRun = true)
	public void afterClass() {
	}
}
