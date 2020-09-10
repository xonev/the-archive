(ns hireask.db
  (:require [datahike.api :as d]))

(def cfg {:store {:backend :file :path "question-db"}})
(d/create-database cfg)
(def conn (d/connect cfg))
(def schema [{:db/ident :question/text
              :db/valueType :db.type/string
              :db/cardinality :db.cardinality/one}
             {:db/ident :question/answer
              :db/valueType :db.type/string
              :db/cardinality :db.cardinality/one}
             {:db/ident :question/created-by
              :db/valueType :db.type/ref
              :db/cardinality :db.cardinality/one}])
(d/transact conn [{:db/ident :name
                   :db/valueType :db.type/string
                   :db/cardinality :db.cardinality/one }
                  {:db/ident :age
                   :db/valueType :db.type/long
                   :db/cardinality :db.cardinality/one }])

(comment

  )
