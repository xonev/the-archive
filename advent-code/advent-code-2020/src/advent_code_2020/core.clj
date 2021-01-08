(ns advent-code-2020.core
  (:require [clojure.java.io :as io]
            [clojure.string :as string]))

(defn read-input
  [filename]
  (->> filename
       io/resource
       slurp))

(defn day-1-problem-1 []
  (let [input (->> "day-1-problem-1-input.txt"
                   read-input
                   string/split-lines
                   (map #(Integer/parseInt %)))
        pairs (for [x input y input]
                (list x y))]
    (->> pairs
         (filter #(= 2020 (apply + %)))
         (map #(apply * %)))))

(defn day-1-problem-2 []
  (let [input (->> "day-1-problem-1-input.txt"
                   read-input
                   string/split-lines
                   (map #(Integer/parseInt %)))
        pairs (for [x input y input z input]
                (list x y z))]
    (->> pairs
         (filter #(= 2020 (apply + %)))
         (map #(apply * %)))))

(defn in-range
  [range num]
  (and
   (>= num (first range))
   (<= num (second range))))

(defn is-valid-password
  [policy password]
  (in-range (:range policy) (get (frequencies password) (:char policy))))

(defn day-2-problem-1 []
  (let [password-info (->> "day-2-input.txt"
                           read-input
                           string/split-lines
                           (map #(string/split % #":")))
        invalid-passwords (->> password-info
                               (map (fn [info] ())))]
    invalid-passwords))

(comment
  (apply + '(1 2))
  (day-1-problem-1)
  (day-1-problem-2)
  (day-2-problem-1)
  (filter #(= % (char "a")) "aabababbaaa")
  (get (frequencies "aabababaababaaa") \a)
  (first "a")
  )
