(ns hireask.core
  (:gen-class)
  (:require [clojure.java.io :as io]
            [integrant.core :as ig]))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (-> "system.edn"
      io/resource
      slurp
      ig/read-string))

(comment
  (-main)
  )
