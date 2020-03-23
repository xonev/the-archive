(defproject finances "0.1.0-SNAPSHOT"
  :description "Automates my personal finances"
  :url "http://stevenoxley.com/finances"
  :license {:name "GPLv3"
            :url "https://www.gnu.org/licenses/gpl-3.0.en.html"}
  :dependencies [[org.clojure/clojure "1.10.0"]
                 [com.google.api-client/google-api-client "1.30.4"]
                 [com.google.oauth-client/google-oauth-client-jetty "1.30.4"]
                 [com.google.apis/google-api-services-sheets "v4-rev581-1.25.0"]]
  :main ^:skip-aot finances.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
