(ns websites.core
  (:gen-class)
  (:require [criterium.core :as crit]
            [integrant.core :as ig]
            [ring.adapter.jetty :as jetty]

            [websites.markdown :as md]
            [websites.renderer :as renderer]))

(defn create-handler [parse]
  (fn [request]
    {:status 200
     :headers {"Content-Type" "text/html"}
     :body (:post (parse "posts/2020-07-13-clojure-markdown-parsing-benchmarks.markdown"))}))

(def system-config
  {:parser/posts {}
   :handler/posts {:parser (ig/ref :parser/posts)}
   :server {:handler (ig/ref :handler/posts) :port 8821}})

(defmethod ig/init-key :parser/posts [_ _] md/parse-post)

(defmethod ig/init-key :handler/posts
  [_ {:keys [parser]}]
  (create-handler parser))

(defmethod ig/init-key :server
  [_ {:keys [handler port]}]
  (jetty/run-jetty handler {:port port :join? true}))

(defmethod ig/halt-key! :server
  [_ server]
  (.stop server))

(defn -main
  "Start the HTTP server"
  [& args]
  (ig/init system-config))
