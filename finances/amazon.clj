(ns finances.amazon
  (:require [clojure.data.csv :as csv]
            [clojure.java.io :as io]))

(defn latest-csv-files
  [dir]
  (let [dir-file (io/file dir)]
    (->> dir-file
         file-seq
         #_(filter #(not (nil? (re-find #"/\d{4}-\d{2}-\d{2}-amazon-\w+.*\.csv$" (.getPath %)))))
         (map #(.getPath %))
         (take 3))))

(comment
  (let [amazon-dir "/Users/soxley/Google Drive/amazon"]
    (latest-csv-files amazon-dir))
  (re-find #"/\d{4}-\w+$" "/a/b/c/2020text")
  )
