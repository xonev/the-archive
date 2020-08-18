(ns websites.renderer)

(defn parse [parser path]
  (slurp path))

(defn render-path
  "Renders the given path. Looks for files at the given path which have a known extension."
  [parsers path]
  (let [markdown-paths (map #(str path "." %) ["markdown" "md"])]
    (loop [remaining-markdown-paths markdown-paths]
      (let [markdown-path (first remaining-markdown-paths)
            next-markdown-paths (rest remaining-markdown-paths)
            parsed (try
                     (parse (:markdown parsers) markdown-path)
                     (catch java.io.FileNotFoundException not-found
                       (if (empty? next-markdown-paths)
                         (throw not-found)
                         nil)))]
        (or parsed (recur next-markdown-paths))))))

(defn create-path-renderer
  [parsers]
  (partial render-path parsers))

(comment
  (str "test/path" "." "markdown")
  (render-path {} "posts/2020-07-13-clojure-markdown-parsing-benchmarks"))
