(ns hireask.system
  (:require [clojure.java.io :as io]
            [hireask.db :as db]
            [hireask.query-api :as q]
            [integrant.core :as ig]))

(defmethod ig/init-key :the-db [_ config]
  (db/init config))

(defmethod ig/init-key :query-api [_ config]
  (q/init config))

(defn system
  []
  (-> "system.edn"
      io/resource
      slurp
      ig/read-string))

(ig/read-string (slurp (io/resource "system.edn")))

(defn start
  [system]
  (ig/init system))

(defn stop
  [system]
  (ig/halt! system))
