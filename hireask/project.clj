(defproject hireask "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[com.walmartlabs/lacinia "0.37.0"]
                 [integrant "0.8.0"]
                 [io.replikativ/datahike "0.3.1"]
                 [org.apache.logging.log4j/log4j-api "2.14.1"]
                 [org.apache.logging.log4j/log4j-core "2.14.1"]
                 [org.clojure/clojure "1.10.2-alpha1"]
                 [org.clojure/tools.logging "1.1.0"]]
  :main hireask.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}
             :dev {:source-paths ["dev"]
                   :dependencies [[org.clojure/tools.namespace "1.1.0"]]
                   :repl-options {:init-ns user}}})
