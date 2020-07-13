(ns finances.amazon
  (:require [clojure.data.csv :as csv]
            [clojure.java.io :as io]
            [clojure.string :as string]))

(def ^:const amazon-directory "/Users/soxley/Google Drive/amazon")

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

(def orders-file-path (partial file-type-path "orders"))
(def items-file-path (partial file-type-path "items"))
(def refunds-file-path (partial file-type-path "refunds"))

(defn join-items
  [items charge]
  (->> items
       (filter #(= (:Order-ID charge) (:Order-ID %)))
       (assoc charge :Items)))

(defn latest-order-categories
  []
  (let [files (latest-csv-files amazon-directory)
        items (read-csv (items-file-path files))
        orders (read-csv (orders-file-path files))]
    (->> orders
        (map (partial join-items items)))))

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
  (latest-order-categories)
  (re-find #"/\d{4}-\w+$" "/a/b/c/2020text")

   (def prices [{:price 10} {:price 15} {:price 25}])
   (def cart-product-args [prices prices])
   (unique-combos prices)
  )
