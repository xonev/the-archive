(ns finances-frontend.views
  (:require
   [re-frame.core :as re-frame]
   [re-com.core :as re-com :refer [at]]
   [finances-frontend.styles :as styles]
   [finances-frontend.events :as events]
   [finances-frontend.routes :as routes]
   [finances-frontend.subs :as subs]
   ["react-plaid-link" :as rpl]))



;; home

(defn display-re-pressed-example []
  (let [re-pressed-example (re-frame/subscribe [::subs/re-pressed-example])]
    [:div

     [:p
      [:span "Re-pressed is listening for keydown events. A message will be displayed when you type "]
      [:strong [:code "hello"]]
      [:span ". So go ahead, try it out!"]]

     (when-let [rpe @re-pressed-example]
       [re-com/alert-box
        :src        (at)
        :alert-type :info
        :body       rpe])]))

(defn home-title []
  (let [name (re-frame/subscribe [::subs/name])]
    [re-com/title
     :src   (at)
     :label (str "Hello from " @name ". This is the Home Page." )
     :level :level1
     :class (styles/level1)]))

(defn link-to-about-page []
  [re-com/hyperlink
   :src      (at)
   :label    "go to About Page"
   :on-click #(re-frame/dispatch [::events/navigate :about])])

(defn link-to-link []
  (let [link (rpl/usePlaidLink (clj->js {"onSuccess" (fn [public-token metadata] (js/console.log public-token metadata))
                                         "onExit" (fn [err metadata] (js/console.log err metadata))
                                         "token" "link-sandbox-46eb0cbc-e938-4c1d-989c-3fb8060ba69d"
                                         }))]
       [re-com/hyperlink
        :src (at)
        :label "Open Link"
        :on-click (.open link)]))

(comment
  (js/console.log (clj->js {:a "a" :b [1 2 3]}))
  (try
    (rpl/usePlaidLink)
    (catch js/Error e
      (println e)))
  (let []
    (.open link))
  )

(defn home-panel []
  [re-com/v-box
   :src      (at)
   :gap      "1em"
   :children [[home-title]
              [link-to-about-page]
              [display-re-pressed-example]
              [:f> link-to-link]
              [:p "This is a test"]]])


(defmethod routes/panels :home-panel [] [home-panel])

;; about

(defn about-title []
  [re-com/title
   :src   (at)
   :label "This is the About Page."
   :level :level1])

(defn link-to-home-page []
  [re-com/hyperlink
   :src      (at)
   :label    "go to Home Page"
   :on-click #(re-frame/dispatch [::events/navigate :home])])

(defn about-panel []
  [re-com/v-box
   :src      (at)
   :gap      "1em"
   :children [[about-title]
              [link-to-home-page]]])

(defmethod routes/panels :about-panel [] [about-panel])

;; main

(defn main-panel []
  (let [active-panel (re-frame/subscribe [::subs/active-panel])]
    [re-com/v-box
     :src      (at)
     :height   "100%"
     :children [(routes/panels @active-panel)]]))
