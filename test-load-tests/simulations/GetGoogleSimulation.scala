package Test

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import Test._

class GetGoogleSimulation extends Simulation {
	val httpConfig = HttpConfiguration.httpConfig
	val numberOfUsers = 10

	setUp(GetGoogleScenario.browse.inject(atOnceUsers(numberOfUsers)).protocols(httpConfig))
}