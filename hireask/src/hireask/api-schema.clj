(ns hireask.api-schema
  (:require [clojure.edn :as edn]
            [clojure.java.io :as io]
            [clojure.string :as string]
            [com.walmartlabs.lacinia :as l]
            [com.walmartlabs.lacinia.util :as util]
            [com.walmartlabs.lacinia.resolve :as resolve]
            [com.walmartlabs.lacinia.schema :as schema]
            [com.walmartlabs.lacinia.executor :as executor]
            [hireask.db :as db]))

(defn keys->names
  [m]
  (reduce
   (fn [m' [k v]]
     (assoc m' (keyword (name k)) v))
   {}
   m))

(defn questions-by-category
  [context args _]
  (let [selections (->> context
                        executor/selections-seq2
                        (map :name)
                        (map str)
                        (map rest)
                        (map string/join)
                        (map string/lower-case)
                        (map keyword))]
    (println (executor/selections-seq2 context))
    (println selections)
    (->> selections
         (db/questions-by-category (:category args))
         (map keys->names))))

(defn load-schema
  []
  (-> (io/resource "hireask-schema.edn")
      slurp
      edn/read-string
      (util/attach-resolvers {:query/questions-by-category questions-by-category})
      schema/compile))

(comment
  (def schema (load-schema))
  (l/execute schema "{ questions_by_category(category: \"Basics\") { text answer }}" {} {})
  (db/questions-by-category "Basics" [:question/text :question/answer])
  (keyword (string/lower-case (string/join (rest (str :Question/text)))))
  (reduce (fn [m [k v]] (assoc m (keyword (name k)) v)) {} {:question/test "this" :other "that"})
  )
