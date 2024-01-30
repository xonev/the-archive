#!/usr/bin/env bb

(ns tz
  (:require [babashka.cli :as cli])
  (:import [java.time ZoneId LocalDateTime ZonedDateTime]))

(def tzs {"PT" "US/Pacific"
          "MT" "US/Mountain"
          "CT" "US/Central"
          "ET" "US/Eastern"
          "UTC" "UTC"
          "CET" "Europe/Berlin"
          "JST" "Japan"
          "Sydney" "Australia/Sydney"})

(defn print-available-timezones []
  (let [available-tzs (sort (ZoneId/getAvailableZoneIds))]
    (doall
        (for [tz available-tzs]
          (println tz)))))

(defn nickname->tz [tz]
  "Assume it's an actual timezone for java.time if it's not a nickname"
  (get tzs tz tz))

(defn convert-time
  ([timestamp]
   (convert-time timestamp "PT"))
  ([timestamp timezone]
   (let [local-time (LocalDateTime/parse timestamp)
         tz (ZoneId/of (nickname->tz timezone))
         zoned-time (ZonedDateTime/of local-time tz)]
     (->> tzs
          vals
          (map #(ZoneId/of %))
          (cons tz)
          distinct
          (map #(.withZoneSameInstant zoned-time %))
          (sort-by #(.getOffset %))
          reverse))))

(defn print-converted-datetimes
  [args]
  (doall
   (for [time (apply convert-time args)]
     (println (.toString time)))))

(let [cli-parsed (cli/parse-args *command-line-args* {:coerce {:available-tzs :boolean}})]
  (cond
    (get (:opts cli-parsed) :available-tzs false) (print-available-timezones)
    (= (count (:args cli-parsed)) 0) (print-converted-datetimes [(.toString (LocalDateTime/now))])
    :else (print-converted-datetimes (:args cli-parsed))))

