(ns core
  [:require
   [net.cgrand.enlive-html :as html]
   [clojure.string :as string]])

(def base-url "http://rtoham.com")

(def product-types
  [{:url "http://rtoham.com/products/used_equipment/" :standard-product-type 1375}
   {:url "http://rtoham.com/products/manuals/" :standard-product-type 4154}
   {:url "http://rtoham.com/products/parts/" :standard-product-type 1404}
   {:url "http://rtoham.com/products/accessories/" :standard-product-type 1374}])

(def product-parsers {:handle {:selector [:div#proddesc :h1]
                              :transformer (comp first :content first)}
                     :variant-price {:selector [:div#proddesc :p.price [:span (html/nth-child 2)]]
                                     :transformer (comp first :content first)}
                     :title {:selector [:div#proddesc :h1]
                             :transformer (comp first :content first)}
                     :body-html {:selector [:div#proddesc :p]
                                 :transformer (comp #(string/replace % #"\n+" "<br />") first :content first #(filter (comp not :attrs) %))}})

(def product-field-metadata [{:key :handle :header "Handle"}
                             {:key :title :header "Title"}
                             {:key :body-html :header "Body (HTML)"}
                             {:header "Vendor" :value ""}
                             {:key :standard-product-type :header "Standard product type"}])

(defn url->html-resource [url]
  (html/html-resource (java.net.URL. url)))

(defn product-links [html-resource]
  (->> (html/select html-resource [:div#items :h2 :a])
       (map :attrs)
       (map :href)
       (map #(str base-url %))))

(defn scrape-product-field
  [product-html {:keys [selector transformer]}]
  (transformer (html/select product-html selector)))

(defn scrape-product-type [{:keys [url standard-product-type]}]
  (let [links (product-links (url->html-resource url))]
    (map (partial scrape-product standard-product-type) links)))

(defn assoc-product-field [values product-html product field-metadata]
  (let [{:keys [key header]} field-metadata
        fallback-val (get values key)
        product-parser (get product-parsers key)]
    (cond
      product-parser (assoc product header (scrape-product-field product-html product-parser))
      fallback-val (assoc product header fallback-val)
      (:value field-metadata) (assoc product header (:value field-metadata))
      :else (throw (Exception. "no value specificed in assoc-product-field")))))

(defn scrape-product [standard-product-type url]
  (let [product-html (url->html-resource url)
        values {:standard-product-type standard-product-type}]
    (reduce (partial assoc-product-field values product-html) {} product-field-metadata)))

(defn quote-string-if-needed [subject]
  (if (and (string? subject) (re-find #"," subject))
    (str \" (string/replace subject "\"" "\\\"") \")
    subject))

(defn select-fields [item fields transform]
  (map #(transform (get item %)) fields))

(defn products->csv [field-metadata products]
  (let [header-csv [(string/join "," (map #(quote-string-if-needed (:header %)) field-metadata))]
        headers (map :header field-metadata)
        products-csv (->> products
                          (map #(select-fields % headers quote-string-if-needed))
                          (map #(string/join "," %)))]
    (string/join "\n" (concat header-csv products-csv))))

(defn main [args]
  (->> product-types
       (map scrape-product-type)
       (apply concat)
       (products->csv product-field-metadata)))

(comment
  (def test-product (nth (product-links (url->html-resource (nth product-urls 0))) 0))
  (def test-product-html (url->html-resource test-product))
  (:content (first (html/select test-product-html [:div#proddesc :h1])))
  (assoc-selected-product-field {} :handle test-product-html (-> product-parsers :handle :selector) (-> product-parsers :handle :transformer))
  (reduce (fn [product [field {:keys [selector transformer]}]] (assoc-selected-product-field product field test-product-html selector transformer)) {} product-fields)
  (scrape-product-type (nth product-types 3))
  (quote-string-if-needed "This is a test \"string\" that contains some quotes already")
  (products->csv product-field-metadata (scrape-product-type (nth product-types 3)))
  (re-find #"," "this has , comma")
  )
