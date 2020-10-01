(ns hireask.api-schema
  (:require [clojure.edn :as edn]
            [clojure.java.io :as io]
            [com.walmartlabs.lacinia.util :as util]
            [com.walmartlabs.lacinia.resolve :as resolve]
            [com.walmartlabs.lacinia.schema :as schema]
            [hireask.db :as db]))

(defn questions-by-category
  [category]
  )

(defn load-schema
  []
  (-> (io/resource "hireask-schema.edn")
      slurp
      edn/read-string
      (util/attach-resolvers {:query/questions-by-category questions-by-category})
      schema/compile))
