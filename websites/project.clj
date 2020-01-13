(defproject websites "0.1.0-SNAPSHOT"
  :description "The Oxley family's websites."
  :url "https://stevenoxley.com/"
  :license {:name "Proprietary"}
  :dependencies [[org.clojure/clojure "1.10.0"]
                 [markdown-clj "1.10.1"]]
  :main ^:skip-aot websites.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}
             :dev {:dependencies [[criterium "0.4.5"]]}})
