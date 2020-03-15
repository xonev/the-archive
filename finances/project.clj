(defproject finances "0.1.0-SNAPSHOT"
  :description "Automates my personal finances"
  :url "http://stevenoxley.com/finances"
  :license {:name "GPLv3"
            :url "https://www.gnu.org/licenses/gpl-3.0.en.html"}
  :dependencies [[org.clojure/clojure "1.10.0"]]
  :main ^:skip-aot finances.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
