(ns user
  (:require [clojure.tools.namespace.repl :refer (refresh refresh-all)]
            [hireask.system :as system]))

(def system nil)

(defn init
  []
  (alter-var-root #'system (constantly (system/system))))

(defn start
  []
  (alter-var-root #'system system/start))

(defn stop
  []
  (alter-var-root #'system
                  (fn [s] (when s (system/stop s)))))

(defn go
  []
  (init)
  (start))
