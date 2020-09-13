(ns hireask.db
  (:require [datahike.api :as d]
            [datahike.core :as dh]))

(def cfg {:store {:backend :file :path "question-db"}})
(d/delete-database cfg)
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
              :db/cardinality :db.cardinality/one}
             {:db/ident :question/last-edited-by
              :db/valueType :db.type/ref
              :db/cardinality :db.cardinality/one}
             {:db/ident :question/rating
              :db/valueType :db.type/ref
              :db/cardinality :db.cardinality/many}
             {:db/ident :question/category
              :db/valueType :db.type/ref
              :db/cardinality :db.cardinality/many}

             {:db/ident :category/title
              :db/unique :db.unique/identity
              :db/valueType :db.type/string
              :db/cardinality :db.cardinality/one}
             {:db/ident :category/description
              :db/valueType :db.type/string
              :db/cardinality :db.cardinality/one}
             {:db/ident :category/created-by
              :db/valueType :db.type/ref
              :db/cardinality :db.cardinality/one}
             {:db/ident :category/last-edited-by
              :db/valueType :db.type/ref
              :db/cardinality :db.cardinality/one}])

(d/transact conn schema)

(comment
  (d/transact conn [{:category/title "Technical"
                     :category/description "Sufficiently technical questions"}
                    {:category/title "Basics"
                     :category/description "Sufficiently basic questions"}

                    {:question/text "Is this your resume?"
                     :question/answer "It had better be"
                     :question/category [[:category/title "Basics"]]}
                    {:question/text "Why do you want the job?"
                     :question/answer "Because your company is awesome"
                     :question/category [[:category/title "Basics"]]}
                    {:question/text "How do you squeeb a thlob?"
                     :question/answer "You have to bibidibop it first"
                     :question/category [[:category/title "Technical"]]}])

  (d/q '[:find ?text
         :where
         [?category :category/title "Basics"]
         [?question :question/category ?category]
         [?question :question/text ?text]]
       @conn)
  )
