(ns hireask.core
  (:gen-class)
  (:require [clojure.java.io :as io]
            [hireask.system :as system]))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (system/start (system/system)))

(comment
  (-main)
  )
