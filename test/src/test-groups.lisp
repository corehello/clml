(in-package :test)

(defparameter *statistics-group* '(
                                   test-sample-stat
                                   ))

(defparameter *decision-tree-group* '(
                                      test-decision-tree
                                      test-random-forest
                                      ))

(defparameter *clustering-test-group* '(
                                        test-sample-cluster-validation
                                        test-sample-spectral-clustering
                                        test-sample-w
                                        test-random-w
                                        test-sample-optics
                                        test-nmf
                                        test-hc
                                        
                                        ))

; disabled tests due to blass:dgemm not handling multi-dimensional arrays
(defparameter *time-series-test-group* '(;test-ts-anomaly-detection
                                         test-sample-ts-ar
                                         test-ts-burst-detection
                                         test-sample-ts-read-data
                                         ;test-sample-ts-stat
                                         test-sample-ts-stsp
                                         ;test-sample-expl-smthing
                                         ;test-changefinder
                                         ))


(defparameter *svm-test-group* '(test-sample-svm
                                 svm.smo.kernels
                                 smo.svm
                                 test-pwss3-kernels
                                 test-pwss3-svm
                                 test-wss3-kernels
                                 test-wss3-svm
                                 test-one-class-svm
                                 ))

(defparameter *classifiers-test-group* '(test-sample-linear-regression
                                         simple-linear-regression-case
                                         multi-linear-regression-case))
