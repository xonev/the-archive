(defn test-func [] (println "modified"))

(def func (atom test-func))

(comment
  (@func)
  )
