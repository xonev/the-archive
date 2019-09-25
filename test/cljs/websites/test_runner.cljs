(ns websites.test-runner
  (:require
   [doo.runner :refer-macros [doo-tests]]
   [websites.core-test]
   [websites.common-test]))

(enable-console-print!)

(doo-tests 'websites.core-test
           'websites.common-test)
