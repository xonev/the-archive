(ns websites.routes
  (:require [clojure.java.io :as io]
            [ring.util.response :refer [resource-response]]
            [bidi.bidi :as bidi]
            [bidi.ring :refer [resources]]
            [ring.util.response :refer [response]]))

(defn index-handler [req]
  (assoc (resource-response "index.html" {:root "public"})
         :headers {"Content-Type" "text/html; charset=UTF-8"}))

(def routes ["/" {""    {:get index-handler}
                  "css" {:get (resources {:prefix "public/css/"})}
                  "js"  {:get (resources {:prefix "public/js/"})}}])

(defn home-routes [endpoint]
  routes)
