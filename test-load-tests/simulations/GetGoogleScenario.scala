package Test

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

object GetGoogleScenario {
	val browse = scenario("Google").exec(http("home_page_request").get("/"))
}