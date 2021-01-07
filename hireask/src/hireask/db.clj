(ns hireask.db
  (:require [datahike.api :as d]
            [datahike.core :as dh]))

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
              :db/cardinality :db.cardinality/one}

             {:db/ident :question-rating/rating
              :db/valueType :db.type/long
              :db/cardinality :db.cardinality/one}
             {:db/ident :question-rating/created-by
              :db/valueType :db.type/ref
              :db/cardinality :db.cardinality/one}

             {:db/ident :user/username
              :db/valueType :db.type/string
              :db/cardinality :db.cardinality/one}])

(defn questions-by-category
  [{:keys [connection]} category-title question-fields]
  (->>
   (d/q '[:find (pull ?question question-pattern)
          :in $ ?category-title question-pattern
          :where [?category :category/title ?category-title] [?question :question/category ?category]]
        @connection
        category-title
        question-fields)
   (map first)))

(defn init [config]
  (let [exists? (d/database-exists? config)]
    (when-not exists?
      (d/create-database config))
    (let [conn (d/connect config)]
      (when-not exists?
        (d/transact conn schema))
      {:connection conn})))

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

  (d/q '[:find (pull ?question question-pattern) (pull ?category category-pattern)
         :in $ ?category-title question-pattern category-pattern
         :where
         [?category :category/title ?category-title]
         [?question :question/category ?category]]
       @conn
       "Technical"
       [:question/text :question/answer]
       [:category/title])
  (questions-by-category "Basics" [:question/text])
  (def result *1)
  (type (first result))
  (:question/answer (first result))
  )
