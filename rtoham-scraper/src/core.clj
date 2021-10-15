(ns core
  [:require
   [net.cgrand.enlive-html :as html]
   [clojure.string :as string]])

(defn parse-currency [str-price]
  (if str-price
    (let [matches (re-find #"\$(\d+\.\d+)" str-price)]
      (if matches
        (second matches)
        nil))
    nil))

(defn handleize [handle]
  (string/replace handle #"[^A-Za-z0-9-]" "-"))

(def base-url "http://rtoham.com")

(def product-types
  [{:url "http://rtoham.com/products/used_equipment/" :standard-product-type 1375}
   {:url "http://rtoham.com/products/manuals/" :standard-product-type 4154}
   {:url "http://rtoham.com/products/parts/" :standard-product-type 1404}
   {:url "http://rtoham.com/products/accessories/" :standard-product-type 1374}])

(defn empty-str-nil [subject]
  (if (= subject "")
    nil
    subject))

(def product-parsers {:handle {:selector [:div#proddesc :h1]
                              :transformer (comp handleize first :content first)}
                     :variant-price {:selector [:div#proddesc :p.price [:span (html/nth-child 2)]]
                                     :transformer (comp parse-currency first :content first)}
                     :title {:selector [:div#proddesc :h1]
                             :transformer (comp first :content first)}
                     :body-html {:selector [:div#proddesc :p]
                                 :transformer (comp #(string/replace % #"\n+" "<br />") first :content first #(filter (comp not :attrs) %))}
                      :image-src {:selector [:div#prodimgs :img.mainprodimg]
                                  :transformer (comp #(str base-url %) :src :attrs first)}
                      :image-alt-text {:selector [:div#prodimgs :img.mainprodimg]
                                       :transformer #(or (-> % first :attrs :alt empty-str-nil) "placeholder product image")}})

(def product-field-metadata [{:key :handle :header "Handle"}
                             {:key :title :header "Title"}
                             {:key :body-html :header "Body (HTML)"}
                             {:header "Vendor" :value ""}
                             {:header "Tags" :value ""}
                             {:header "Published" :value "TRUE"}
                             {:header "Option1 Name" :value "Title"}
                             {:header "Option1 Value" :value "Default Title"}
                             {:header "Option2 Name" :value ""}
                             {:header "Option2 Value" :value ""}
                             {:header "Option3 Name" :value ""}
                             {:header "Option3 Value" :value ""}
                             {:header "Variant SKU" :value ""}
                             {:header "Variant Grams" :value 0}
                             {:header "Variant Inventory Tracker" :value ""}
                             {:header "Variant Inventory Qty" :value ""}
                             {:header "Variant Inventory Policy" :value "deny"}
                             {:header "Variant Fulfillment Service" :value "manual"}
                             {:key :variant-price :header "Variant Price"}
                             {:header "Variant Compare at Price" :value ""}
                             {:header "Variant Requires Shipping" :value "FALSE"}
                             {:header "Variant Taxable" :value "TRUE"}
                             {:header "Variant Barcode" :value ""}
                             {:key :image-src :header "Image Src"}
                             {:header "Image Position" :value 1}
                             {:key :image-alt-text :header "Image Alt Text"}
                             {:header "Gift Card" :value "FALSE"}
                             {:header "SEO Title" :value ""}
                             {:header "SEO Description" :value ""}
                             {:header "Google Shopping / Google Product Category" :value ""}
                             {:header "Google Shopping / Gender" :value ""}
                             {:header "Google Shopping / Age Group" :value ""}
                             {:header "Google Shopping / MPN" :value ""}
                             {:header "Google Shopping / AdWords Grouping" :value ""}
                             {:header "Google Shopping / AdWords Labels" :value ""}
                             {:header "Google Shopping / Condition" :value ""}
                             {:header "Google Shopping / Custom Product" :value ""}
                             {:header "Google Shopping / Custom Label 0" :value ""}
                             {:header "Google Shopping / Custom Label 1" :value ""}
                             {:header "Google Shopping / Custom Label 2" :value ""}
                             {:header "Google Shopping / Custom Label 3" :value ""}
                             {:header "Google Shopping / Custom Label 4" :value ""}
                             {:header "Variant Image" :value ""}
                             {:header "Variant Weight Unit" :value ""}
                             {:header "Variant Tax Code" :value ""}
                             {:header "Cost per item" :value ""}
                             {:header "Status" :value "draft"}
                             {:key :standard-product-type :header "Standard Product Type"}
                             {:header "Custom Product Type" :value ""}])

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

(defn scrape-product-type [{:keys [url standard-product-type]}]
  (let [links (product-links (url->html-resource url))]
    (->> links
         (map (partial scrape-product standard-product-type))
         (filter #(get % "Variant Price")))))

(defn quote-string-if-needed [subject]
  (if (and (string? subject) (re-find #"," subject))
    (str \" (string/replace subject "\"" "\"\"") \")
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
       (products->csv product-field-metadata)
       print))

(comment
  (def test-product (nth (product-links (url->html-resource (nth product-urls 0))) 0))
  (def test-product-html (url->html-resource test-product))
  (:content (first (html/select test-product-html [:div#proddesc :h1])))
  (assoc-selected-product-field {} :val test-product-html (-> product-parsers :image-alt-text :selector) (-> product-parsers :image-alt-text :transformer))
  (reduce (fn [product [field {:keys [selector transformer]}]] (assoc-selected-product-field product field test-product-html selector transformer)) {} product-fields)
  (scrape-product-type (nth product-types 3))
  (quote-string-if-needed "This is a test \"string\" that contains some quotes already")
  (products->csv product-field-metadata (scrape-product-type (nth product-types 2)))
  (re-find #"," "this has , comma")
  (parse-currency "$150.00")
  )
