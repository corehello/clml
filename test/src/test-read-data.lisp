
(in-package :clml.test)

(defun assert-dimensions-equal (expected target &key (name-test #'eq))
  (let ((e-names (map 'list #'dimension-name expected))
        (t-names (map 'list #'dimension-name target))
        (e-types (map 'list #'dimension-type expected))
        (t-types (map 'list #'dimension-type target))
        (e-index (map 'list #'dimension-index expected))
        (t-index (map 'list #'dimension-index target)))
    (assert-equality (lambda (l1 l2) (set-equal l1 l2 :test name-test)) e-names t-names)
    (assert-equality (lambda (l1 l2) (set-equal l1 l2 :test #'eq)) e-types t-types)
    (assert-equality (lambda (l1 l2) (set-equal l1 l2 :test #'eql)) e-index t-index)))

(define-test test-sample-read-data
    (let (dataset n-pts c-pts
          (expected-pts1 #(#(1 41 190 7.4d0 67 5 1) #(2 36 118 8.0d0 72 5 2) #(3 12 149 :NA 74 5 3)
                           #(4 18 313 11.5d0 62 :NA :NA) #(5 :NA :NA 14.3d0 56 5 5)
                           #(6 28 :NA 14.9d0 66 5 6) #(7 23 299 8.6d0 65 5 7)
                           #(8 19 99 13.8d0 :NA 5 8) #(9 8 19 :NA :NA 5 9)
                           #(10 :NA 194 8.6d0 69 5 10)))
          (expected-pts2 #(#(41.0d0 190.0d0 7.4d0 67.0d0) #(36.0d0 118.0d0 8.0d0 72.0d0)
                           #(12.0d0 149.0d0 20.7d0 74.0d0) #(18.0d0 313.0d0 11.5d0 62.0d0)
                           #(27.093168555852095d0 36.0d0 14.3d0 56.0d0)
                           #(28.0d0 36.0d0 14.9d0 66.0d0) #(23.0d0 299.0d0 8.6d0 65.0d0)
                           #(19.0d0 99.0d0 13.8d0 79.0d0) #(8.0d0 36.0d0 20.7d0 79.0d0)
                           #(2.4104000463381468d0 194.0d0 8.6d0 69.0d0)
                           #(7.0d0 36.0d0 6.9d0 74.0d0) #(16.0d0 256.0d0 9.7d0 69.0d0)
                           #(11.0d0 290.0d0 9.2d0 66.0d0) #(14.0d0 274.0d0 10.9d0 68.0d0)
                           #(18.0d0 65.0d0 13.2d0 58.0d0) #(14.0d0 334.0d0 11.5d0 64.0d0)
                           #(34.0d0 307.0d0 12.0d0 66.0d0) #(6.0d0 78.0d0 18.4d0 57.0d0)
                           #(30.0d0 322.0d0 11.5d0 68.0d0) #(11.0d0 44.0d0 9.7d0 62.0d0)
                           #(1.0d0 36.0d0 9.7d0 59.0d0) #(11.0d0 320.0d0 16.6d0 73.0d0)
                           #(4.0d0 36.0d0 9.7d0 61.0d0) #(32.0d0 92.0d0 12.0d0 61.0d0)
                           #(43.0967623733407d0 66.0d0 16.6d0 57.0d0)
                           #(33.25007626412856d0 266.0d0 14.9d0 58.0d0)
                           #(20.528352022852136d0 36.0d0 8.0d0 57.0d0)
                           #(23.0d0 36.0d0 12.0d0 67.0d0) #(45.0d0 252.0d0 14.9d0 81.0d0)
                           #(49.12252764263266d0 223.0d0 5.7d0 79.0d0)
                           #(37.0d0 279.0d0 7.4d0 76.0d0)
                           #(21.37725971074787d0 286.0d0 8.6d0 78.0d0)
                           #(6.677179681315291d0 287.0d0 9.7d0 74.0d0)
                           #(-4.757859614910494d0 242.0d0 16.1d0 67.0d0)
                           #(-10.585477704542193d0 186.0d0 9.2d0 84.0d0)
                           #(-8.463294114192522d0 220.0d0 8.6d0 85.0d0)
                           #(3.9510716295257744d0 264.0d0 14.3d0 79.0d0)
                           #(29.0d0 127.0d0 9.7d0 82.0d0)
                           #(62.10448815627175d0 273.0d0 6.9d0 87.0d0)
                           #(71.0d0 291.0d0 13.8d0 90.0d0) #(39.0d0 323.0d0 11.5d0 87.0d0)
                           #(20.980878358062554d0 259.0d0 10.9d0 93.0d0)
                           #(20.579969985351873d0 250.0d0 9.2d0 92.0d0)
                           #(23.0d0 148.0d0 8.0d0 82.0d0)
                           #(17.95432420349389d0 332.0d0 13.8d0 80.0d0)
                           #(13.198821130740075d0 322.0d0 11.5d0 79.0d0)
                           #(21.0d0 191.0d0 14.9d0 77.0d0) #(37.0d0 284.0d0 20.7d0 72.0d0)
                           #(20.0d0 37.0d0 9.2d0 65.0d0) #(12.0d0 120.0d0 11.5d0 73.0d0)
                           #(13.0d0 137.0d0 10.3d0 76.0d0)
                           #(18.401839070440285d0 150.0d0 6.3d0 77.0d0)
                           #(27.100779616087166d0 59.0d0 1.7d0 76.0d0)
                           #(37.97668179053644d0 91.0d0 4.6d0 76.0d0)
                           #(49.90940574738394d0 250.0d0 6.3d0 76.0d0)
                           #(61.77881164022552d0 135.0d0 8.0d0 75.0d0)
                           #(72.46475962265698d0 127.0d0 8.0d0 78.0d0)
                           #(80.84710984827416d0 47.0d0 10.3d0 73.0d0)
                           #(85.80572247067292d0 98.0d0 11.5d0 80.0d0)
                           #(86.22045764344904d0 36.0d0 14.9d0 77.0d0)
                           #(80.97117552019836d0 138.0d0 8.0d0 83.0d0)
                           #(68.93773625451676d0 269.0d0 4.1d0 84.0d0)
                           #(49.0d0 248.0d0 9.2d0 85.0d0) #(32.0d0 236.0d0 9.2d0 81.0d0)
                           #(52.936176324041504d0 101.0d0 10.9d0 84.0d0)
                           #(64.0d0 175.0d0 4.6d0 83.0d0) #(40.0d0 314.0d0 10.9d0 83.0d0)
                           #(77.0d0 276.0d0 5.1d0 88.0d0) #(97.0d0 267.0d0 6.3d0 92.0d0)
                           #(97.0d0 272.0d0 5.7d0 92.0d0) #(85.0d0 175.0d0 7.4d0 89.0d0)
                           #(39.75373057166939d0 139.0d0 8.6d0 82.0d0)
                           #(10.0d0 264.0d0 14.3d0 73.0d0) #(27.0d0 175.0d0 14.9d0 81.0d0)
                           #(11.087638792910138d0 291.0d0 14.9d0 91.0d0)
                           #(7.0d0 48.0d0 14.3d0 80.0d0) #(48.0d0 260.0d0 6.9d0 81.0d0)
                           #(35.0d0 274.0d0 10.3d0 82.0d0) #(61.0d0 285.0d0 6.3d0 84.0d0)
                           #(79.0d0 187.0d0 5.1d0 87.0d0) #(63.0d0 220.0d0 11.5d0 85.0d0)
                           #(16.0d0 36.0d0 6.9d0 74.0d0)
                           #(1.5888196527518375d0 258.0d0 9.7d0 81.0d0)
                           #(26.95546006256839d0 295.0d0 11.5d0 82.0d0)
                           #(80.0d0 294.0d0 8.6d0 86.0d0) #(108.0d0 223.0d0 8.0d0 85.0d0)
                           #(20.0d0 81.0d0 8.6d0 82.0d0) #(52.0d0 82.0d0 12.0d0 86.0d0)
                           #(82.0d0 213.0d0 7.4d0 88.0d0) #(50.0d0 275.0d0 7.4d0 86.0d0)
                           #(64.0d0 253.0d0 7.4d0 83.0d0) #(59.0d0 254.0d0 9.2d0 81.0d0)
                           #(39.0d0 83.0d0 6.9d0 81.0d0) #(9.0d0 36.0d0 13.8d0 81.0d0)
                           #(16.0d0 77.0d0 7.4d0 82.0d0) #(78.0d0 36.0d0 6.9d0 86.0d0)
                           #(35.0d0 36.0d0 7.4d0 85.0d0) #(66.0d0 36.0d0 4.6d0 87.0d0)
                           #(89.65189076185109d0 255.0d0 4.0d0 89.0d0)
                           #(89.0d0 229.0d0 10.3d0 90.0d0)
                           #(85.3093252092783d0 207.0d0 8.0d0 90.0d0)
                           #(79.4217210106807d0 222.0d0 8.6d0 92.0d0)
                           #(67.07325630674276d0 137.0d0 11.5d0 86.0d0)
                           #(44.0d0 192.0d0 11.5d0 86.0d0) #(28.0d0 273.0d0 11.5d0 82.0d0)
                           #(65.0d0 157.0d0 9.7d0 80.0d0)
                           #(41.77082339199987d0 64.0d0 11.5d0 79.0d0)
                           #(22.0d0 71.0d0 10.3d0 77.0d0) #(59.0d0 51.0d0 6.3d0 79.0d0)
                           #(23.0d0 115.0d0 7.4d0 76.0d0) #(31.0d0 244.0d0 10.9d0 78.0d0)
                           #(44.0d0 190.0d0 10.3d0 78.0d0) #(21.0d0 259.0d0 15.5d0 77.0d0)
                           #(9.0d0 36.0d0 14.3d0 72.0d0)
                           #(21.81438082638426d0 255.0d0 12.6d0 75.0d0)
                           #(45.0d0 212.0d0 9.7d0 79.0d0)
                           #(63.24525648660695d0 238.0d0 3.4d0 81.0d0)
                           #(73.0d0 215.0d0 8.0d0 86.0d0)
                           #(75.07959322718793d0 153.0d0 5.7d0 88.0d0)
                           #(76.0d0 203.0d0 9.7d0 97.0d0)
                           #(80.93637060464131d0 225.0d0 2.3d0 94.0d0)
                           #(84.0d0 237.0d0 6.3d0 96.0d0) #(85.0d0 188.0d0 6.3d0 94.0d0)
                           #(96.0d0 167.0d0 6.9d0 91.0d0) #(78.0d0 197.0d0 5.1d0 92.0d0)
                           #(73.0d0 183.0d0 2.8d0 93.0d0) #(91.0d0 189.0d0 4.6d0 93.0d0)
                           #(47.0d0 95.0d0 7.4d0 87.0d0) #(32.0d0 92.0d0 15.5d0 84.0d0)
                           #(20.0d0 252.0d0 10.9d0 80.0d0) #(23.0d0 220.0d0 10.3d0 78.0d0)
                           #(21.0d0 230.0d0 10.9d0 75.0d0) #(24.0d0 259.0d0 9.7d0 73.0d0)
                           #(44.0d0 236.0d0 14.9d0 81.0d0) #(21.0d0 259.0d0 15.5d0 76.0d0)
                           #(28.0d0 238.0d0 6.3d0 77.0d0) #(9.0d0 36.0d0 10.9d0 71.0d0)
                           #(13.0d0 112.0d0 11.5d0 71.0d0) #(46.0d0 237.0d0 6.9d0 78.0d0)
                           #(18.0d0 224.0d0 13.8d0 67.0d0) #(13.0d0 36.0d0 10.3d0 76.0d0)
                           #(24.0d0 238.0d0 10.3d0 68.0d0) #(16.0d0 201.0d0 8.0d0 82.0d0)
                           #(13.0d0 238.0d0 12.6d0 64.0d0) #(23.0d0 36.0d0 9.2d0 71.0d0)
                           #(36.0d0 139.0d0 10.3d0 81.0d0) #(7.0d0 49.0d0 10.3d0 69.0d0)
                           #(14.0d0 36.0d0 16.6d0 63.0d0) #(30.0d0 193.0d0 6.9d0 70.0d0)
                           #(24.054519423374423d0 145.0d0 13.2d0 77.0d0)
                           #(14.0d0 191.0d0 14.3d0 75.0d0) #(18.0d0 131.0d0 8.0d0 76.0d0)
                           #(20.0d0 223.0d0 11.5d0 68.0d0)))
          (expected-pts3 #(#(1 7 1) #(2 7 2) #(3 7 3) #(4 7 1) #(5 7 5) #(6 7 6) #(7 7 7) #(8 7 8)
                           #(9 7 9) #(10 7 10) #(11 7 11) #(12 7 1) #(13 7 1) #(14 7 14) #(15 7 15)
                           #(16 7 16) #(17 7 17) #(18 7 18) #(19 7 19) #(20 7 20) #(0 7 21) #(22 7 22)
                           #(23 7 23) #(0 7 24) #(25 7 25) #(26 7 26) #(27 7 27) #(28 7 28) #(29 7 29)
                           #(30 7 30) #(31 7 31) #(32 6 1) #(33 6 2) #(34 6 3) #(35 6 4) #(36 6 5)
                           #(37 6 6) #(38 6 7) #(39 6 8) #(40 6 9) #(41 6 10) #(42 6 11) #(43 6 12)
                           #(44 6 13) #(45 6 14) #(46 6 15) #(47 6 16) #(48 6 17) #(49 6 18) #(50 6 19)
                           #(51 6 20) #(52 6 21) #(53 6 22) #(54 6 23) #(55 6 24) #(56 6 25) #(57 6 26)
                           #(58 6 27) #(59 6 28) #(60 6 29) #(61 6 30) #(62 7 1) #(63 7 2) #(64 7 3)
                           #(65 7 4) #(66 7 5) #(67 7 6) #(68 7 7) #(69 7 8) #(70 7 9) #(71 7 10)
                           #(72 7 11) #(73 7 12) #(74 7 13) #(75 7 14) #(76 7 15) #(77 7 16) #(78 7 17)
                           #(79 7 18) #(80 7 19) #(81 7 20) #(82 7 21) #(83 7 22) #(84 7 23) #(85 7 24)
                           #(86 7 25) #(87 7 26) #(88 7 27) #(89 7 28) #(90 7 29) #(91 7 30) #(92 7 31)
                           #(93 8 1) #(94 8 2) #(95 8 3) #(96 8 4) #(97 8 5) #(98 8 6) #(99 8 7)
                           #(100 8 8) #(101 8 9) #(102 8 10) #(103 8 11) #(104 8 12) #(105 8 13)
                           #(106 8 14) #(107 8 15) #(108 8 16) #(109 8 17) #(110 8 18) #(111 8 19)
                           #(112 8 20) #(113 8 21) #(114 8 22) #(115 8 23) #(116 8 24) #(117 8 25)
                           #(118 8 26) #(119 8 27) #(120 8 28) #(121 8 29) #(122 8 30) #(123 8 31)
                           #(124 9 1) #(125 9 2) #(126 9 3) #(127 9 4) #(128 9 5) #(129 9 6) #(130 9 7)
                           #(131 9 8) #(132 9 9) #(133 9 10) #(134 9 11) #(135 9 12) #(136 9 13)
                           #(137 9 14) #(138 9 15) #(139 9 16) #(140 9 17) #(141 9 18) #(142 9 19)
                           #(143 9 20) #(144 9 21) #(145 9 22) #(146 9 23) #(147 9 24) #(148 9 25)
                           #(149 9 26) #(150 9 27) #(151 9 28) #(152 9 29) #(153 9 30))


                         ))
      (assert (setf dataset (read-data-from-file (clml.utility.data:fetch "https://mmaul.github.io/clml.data/sample/original-airquality.sexp"))))
      (assert-true (typep dataset 'UNSPECIALIZED-DATASET))
      (assert-points-equal expected-pts1 (dataset-points dataset) :test #'equalp)

      (assert (setf dataset (pick-and-specialize-data
                                  dataset :range :all
                                  :data-types '(:category :numeric :numeric :numeric :numeric
                                                :category :category))))
      (assert-true (typep dataset 'NUMERIC-AND-CATEGORY-DATASET))
      (assert-true
       (assert-dimensions-equal
        (map 'vector (lambda (name type index) (make-dimension name type index))
             '("id" "Ozone" "Solar.R" "Wind" "Temp" "Month" "Day")
             '(:category :numeric :numeric :numeric :numeric :category :category)
             '(0 0 1 2 3 1 2))
        (dataset-dimensions dataset)
        :name-test #'string=))

      (assert (setf n-pts (dataset-numeric-points dataset)))
      (assert-true (typep n-pts 'vector))
      (loop for pts across n-pts 
          for count from 1
         do ;(assert-true (typep pts 'dvec))
           (assert-eql 4 (length pts))
             (loop for val across pts
                 do (assert (or (numberp val) (nan-p val))))
          finally (assert-eql 153 count))

      (assert (setf c-pts (dataset-category-points dataset)))
      (assert-true (typep c-pts 'vector))
      (loop for pts across c-pts 
          for count from 1
          do (assert-true (typep pts 'vector))
             (assert-eql 3 (length pts))
             (loop for val across pts
                 do (assert (or (c-nan-p val) (integerp val))))
          finally (assert-eql 153 count))
      
      (assert
       (setf dataset 
         (dataset-cleaning dataset 
                           :interp-types-alist (pairlis '("Ozone" "Solar.R" "Wind" "Temp" "Month" "Day")
                                                        '(:spline :min :max :median :mode :mode))
                           :outlier-types-alist (pairlis '("Ozone" "Solar.R" "Wind" "Month" "Day") 
                                                         '(:std-dev :mean-dev :smirnov-grubbs :user :freq))
                           :outlier-values-alist (pairlis '(:std-dev :mean-dev :smirnov-grubbs :user)
                                                          '(2d0 2d0 0.05d0 5)))))
      (assert (setf n-pts (dataset-numeric-points dataset)))
      (assert-points-equal expected-pts2 n-pts :test #'epsilon>)
      (assert (setf c-pts (dataset-category-points dataset)))
      (assert-points-equal expected-pts3 c-pts :test #'=)

      
      (let (d1 d2)
        (assert (multiple-value-setq (d1 d2)
                       (divide-dataset dataset :divide-ratio '(3 2) :except '(2 3 4))))
        (assert (and d1 d2))
        (assert-eql 91 (length (dataset-points d1)))
        (assert-eql 62 (length (dataset-points d2)))
        (let ((e-dim (map 'vector
                       (lambda (pos) (svref (dataset-dimensions dataset) pos))
                       '(0 1 5 6))))
          (assert-dimensions-equal e-dim (dataset-dimensions d1))
          (assert-dimensions-equal e-dim (dataset-dimensions d2))))
      
      (let (choice)
        (assert (setq choice (choice-dimensions '("Day" "Month" "Temp" "Wind") dataset)))
        (let* ((dims (dataset-dimensions dataset))
               (poses (mapcar (lambda (name) (position name dims :key #'dimension-name :test #'string=))
                              '("Day" "Month" "Temp" "Wind")))
               (ozone-pos (position "Ozone" dims :key #'dimension-name :test #'string=)))
          (assert-points-equal (map 'vector
                                 (lambda (vec) (coerce (mapcar (lambda (pos) (aref vec pos)) poses) 'vector))
                                 (dataset-points dataset))
                               choice :test #'=)
          (assert (setq choice (choice-a-dimension "Ozone" dataset)))
          (assert-a-point-equal (map 'vector (lambda (vec) (aref vec ozone-pos)) (dataset-points dataset))
                                choice :test #'=)))
      
      (let (samples)
        (assert (setq samples (make-bootstrap-sample-datasets dataset :number-of-datasets 3)))
        (assert-eql 3 (length samples))
        (flet ((sample-check (sample)
                 (loop for sample-pt across (dataset-points sample)
                     always (loop for pt across (dataset-points dataset)
                                thereis (point-equal sample-pt pt :test #'=)))))
          (assert (loop for sample in samples always (sample-check sample)))))
      ))





