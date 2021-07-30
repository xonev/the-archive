(ns hireask.core
  (:gen-class)
  (:require [clojure.java.io :as io]
            #_[hireask.system :as system]
            [clojure.tools.logging :as log]))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (log/info "Starting system")
  #_(system/start (system/system)))

(comment
  (-main)
  )
