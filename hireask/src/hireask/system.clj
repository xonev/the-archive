(ns hireask.system
  (:require [clojure.java.io :as io]
            [hireask.db :as db]
            [hireask.query-api :as q]
            [integrant.core :as ig]))

(defmethod ig/init-key :db [_ config]
  (db/init config))

(defmethod ig/init-key :query-api [_ config]
  (q/init config))

(defn system
  []
  (-> "system.edn"
      io/resource
      slurp
      ig/read-string))

(defn start
  [system]
  (ig/init system))

(defn stop
  [system]
  (ig/halt! system))
