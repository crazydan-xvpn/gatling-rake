package Test

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._


object HttpConfiguration {

	val httpConfig = http
						.baseURL("http://meatlust.com/bob")
						.inferHtmlResources()
						.acceptHeader("""text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8""")
						.acceptEncodingHeader("""gzip, deflate""")
						.acceptLanguageHeader("""en-gb,en;q=0.5""")
						.connection("""keep-alive""")
						.userAgentHeader("""Mozilla/5.0 (Windows NT 6.1; WOW64; rv:29.0) Gecko/20100101 Firefox/29.0""")
}