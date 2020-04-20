(ns finances.amazon
  (:require [clojure.data.csv :as csv]
            [clojure.java.io :as io]
            [clojure.string :as string]))

(defn latest-csv-files
  [dir]
  (let [dir-file (io/file dir)]
    (->> dir-file
         file-seq
         (map #(.getPath %))
         (filter #(not (nil? (re-find #"/\d{4}-\d{2}-\d{2}-amazon-\w+.*\.csv$" %))))
         sort
         reverse
         (take 3))))

(defn file-type-path
  [file-type file-paths]
  (let [filename-pattern (re-pattern (format "\\d{4}-\\d{2}-\\d{2}-amazon-%s" file-type))]
    (first
     (filter
      #(not (nil? (re-find filename-pattern %)))
      file-paths))))

(defn to-keyword
  [name]
  (keyword (string/replace name #"[^\w]" "-")))

(defn read-csv
  [file-path]
  (with-open [reader (io/reader file-path)]
    (let [rows (doall (csv/read-csv reader))
          header-row (map to-keyword (first rows))
          data-rows (rest rows)]
      (map #(zipmap header-row %) data-rows))))

(defn join-charge-with-items
  [charges items]
  )

(defn- max-val-for-index
  [n r index]
  (+ (- n r) index))

(defn- inc-needed
  [curr-combo n r]
  (reduce (fn [filtered index]
              (if (< (nth curr-combo index) (max-val-for-index n r index))
                (conj filtered index)
                filtered))
            []
            (range (dec r) -1 -1)))

(defn- next-combo
  [curr-combo n]
  (let [r (count curr-combo)
        inc-index (first (inc-needed curr-combo n r))]
    (if (not inc-index)
      nil
      (reduce (fn [new-combo index]
                (cond
                  (= index inc-index)
                  (update new-combo index inc)

                  (and (> index inc-index)
                       (> index 0)
                       (= (get new-combo index)
                          (max-val-for-index n r index)))
                  (assoc new-combo index (inc (get new-combo (dec index))))

                  #_(and (> index inc-index)
                         (< (get new-combo index)
                            (max-val-for-index n r index)))
                  #_(update new-combo index inc)

                  :else
                  new-combo))
              curr-combo
              (range (count curr-combo))))))

(defn cart-product
  ([row-colls] (cart-product (map #(conj [] %) (first row-colls)) (rest row-colls)))
  ([product row-colls]
   (if (empty? row-colls)
     product
     (recur (filter #(not (nil? %))
                    (for [product-row product
                          row (first row-colls)]
                        (conj product-row row)))
            (rest row-colls)))))

(defn unique-combos
  [items]
  (->>
   (fn [] items)
   (repeatedly (count items))
   cart-product
   (map set)
   set))

(comment 5 choose 3
   0 1 2
   0 1 3
   0 1 4
   0 2 3
   0 2 4
   0 3 4
   1 2 3
   1 2 4
   1 3 4
   2 3 4
   (repeatedly 3 (fn [] {:a :b}))
   (range (dec 3) -1 -1)
   (inc-needed [0 3 4] 5 3)
   (next-combo [0 3 5] 6)
   (def prices [{:price 10} {:price 15} {:price 25}])
   (def cart-product-args [prices prices])
   (unique-combos prices)
   (unique-combos (cart-product cart-product-args))
   )

(def orders-file-path (partial file-type-path "orders"))
(def items-file-path (partial file-type-path "items"))
(def refunds-file-path (partial file-type-path "refunds"))

(comment
  (let [amazon-dir "/Users/soxley/Google Drive/amazon"]
    (->> amazon-dir
         latest-csv-files
         items-file-path
         read-csv
         (take 5)))
  (map #(conj [] %) [1 2 3])
  (def charges [{:Subtotal 24.82M} {:Subtotal 29.96M}])
  (def items [{:Category "BABY_PRODUCT" :Item-Subtotal 14.97M} {:Category "BABY_PRODUCT" :Item-Subtotal 14.99M} {:Category "HEALTH_PERSONAL_CARE" :Item-Subtotal 24.82M}])
  (concat [[1 2 3]] [[4 5 6] [7 8 9]] nil [[10 11 12]])
  (all-combos items)
  (re-find #"/\d{4}-\w+$" "/a/b/c/2020text")
  )
