(ns finances.sheets
  (:require [clojure.java.io :as io]
            [clojure.string :as str])
  (:import [com.google.api.client.auth.oauth2 Credential]
           [com.google.api.client.extensions.java6.auth.oauth2 AuthorizationCodeInstalledApp]
           [com.google.api.client.extensions.jetty.auth.oauth2 LocalServerReceiver$Builder]
           [com.google.api.client.googleapis.auth.oauth2 GoogleAuthorizationCodeFlow$Builder GoogleClientSecrets]
           [com.google.api.client.googleapis.javanet GoogleNetHttpTransport]
           [com.google.api.client.json.jackson2 JacksonFactory]
           [com.google.api.client.util.store FileDataStoreFactory]
           [com.google.api.services.sheets.v4 Sheets$Builder SheetsScopes]
           [com.google.api.services.sheets.v4.model ValueRange]
           [java.io InputStreamReader File]))

(defn credentials
  [json-factory http-transport scopes tokens-directory-path]
  (let [file-reader (io/reader (io/resource "client_credentials.json"))
        client-secrets (GoogleClientSecrets/load json-factory file-reader)
        flow (.. (GoogleAuthorizationCodeFlow$Builder. http-transport json-factory client-secrets scopes)
                 (setDataStoreFactory (FileDataStoreFactory. (File. tokens-directory-path)))
                 (setAccessType "offline")
                 (build))
        receiver (.. (LocalServerReceiver$Builder.) (setPort 8888) (build))]
    (.. (AuthorizationCodeInstalledApp. flow receiver) (authorize "user"))))

(comment
  (let [json-factory (JacksonFactory/getDefaultInstance)
        http-transport (GoogleNetHttpTransport/newTrustedTransport)
        spreadsheet-id "1Y94EeqZZ9pNxQy35-vxXO3YQ_FA3Xxhb-v1O2B1gV0Q"
        scopes [SheetsScopes/SPREADSHEETS_READONLY]
        tokens-directory-path "tokens"
        range "Savings Tracker!A1:H"
        credentials (credentials json-factory http-transport scopes tokens-directory-path)
        service (.. (Sheets$Builder. http-transport json-factory credentials)
                    (setApplicationName "Personal Finances")
                    (build))
        values (.. service
                     (spreadsheets)
                     (values)
                     (get spreadsheet-id range)
                     (execute)
                     (getValues))]
    (if (or (nil? values) (.isEmpty values))
      "No Data Found"
      (str/join "\n" (concat (map #(format "%s, %s" (.get % 0) (.get % 1)) values)))))
  (str/join (concat "test" "test2"))
  )
