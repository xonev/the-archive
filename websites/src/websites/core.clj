(ns websites.core
  (:gen-class)
  (:require [criterium.core :as crit]
            [websites.markdown :as md]))

(defn -main
  "Benchmark markdown processing"
  [& args]
  (crit/with-progress-reporting (crit/bench (md/parse-post "posts/2012-03-13-on-the-uncertainty-of-everything.md") :verbose))
  (flush))
