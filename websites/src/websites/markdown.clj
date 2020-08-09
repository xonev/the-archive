(ns websites.markdown
  (:require [markdown.core :as md]
            [clojure.java.io :as io]
            [clojure.string :as string])
  (:import [java.io StringWriter]))

(defn parse-post
  [file-name]
  (let [writer (new StringWriter)
        metadata (md/md-to-html file-name writer :parse-meta? true :reference-links? true)]
    {:metadata metadata
     :post (.toString writer)}))

(comment
  (use 'criterium.core)
  (string/join "/" ["abc" "def"])
  (bench (parse-post "posts/2020-07-13-clojure-markdown-parsing-benchmarks.markdown"))
  (bench (md/md-to-html "posts/2011-09-30-first.markdown" "posts/2011-09-30-first.html"))
)
