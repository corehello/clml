
(in-package :clml.test)

(define-test test-sample-expl-smthing
    (let (ukgas model pred)
      (assert-true 
       (setq ukgas
         (time-series-data
          (read-data-from-file (clml.utility.data:fetch "https://mmaul.github.io/clml.data/sample/UKgas.sexp"))
          :range '(1) :time-label 0
          :frequency 4)))
      (assert-true (setq model (holtwinters ukgas :seasonal :multiplicative)))
      (with-accessors ((seasonal clml.time-series.exponential-smoothing::seasonal)
                       (err-info clml.time-series.exponential-smoothing::err-info)
                       (exp-type clml.time-series.exponential-smoothing::exp-type)
                       (3-params clml.time-series.exponential-smoothing::3-params)) model
        (assert-eq :multiplicative seasonal)
        (assert-eq 'CLML.TIME-SERIES.EXPONENTIAL-SMOOTHING::MSE (first err-info))
        (assert-equality #'epsilon> 1131.3876624098614d0 (second err-info))
        (assert-eq :triple exp-type)
        (assert-true (set-equal '(0.1d0 0.2d0 0.7999999999999999d0) 3-params :test #'epsilon>)))
      
      (assert-true (setq pred (predict model :n-ahead 12)))
      (assert-true
       (set-equal 
        '(1256.8668302235947d0 650.7271978623316d0 357.109252359615d0 847.1323726297013d0
          1335.916980986101d0 691.0208683583539d0 378.884720191268d0 898.0123754388738d0
          1414.9671317486086d0 731.3145388543767d0 400.6601880229212d0 948.8923782480464d0)
        (map 'list (lambda (p) (aref (ts-p-pos p) 0)) (subseq (ts-points pred) 107))
        :test #'epsilon>))
      
      (assert-true 
       (setq pred (holtwinters-prediction ukgas :seasonal :multiplicative
                                          :n-learning 80 :n-ahead 12)))
      (assert-true 
       (set-equal
        '(160.1d0 129.7d0 84.8d0 120.1d0 128.23013695952972d0 128.53391201531772d0 
          125.77470476569742d0
          149.92192865911835d0 123.67992506779508d0 95.58295304480231d0 122.65348477231083d0
          170.5200842957654d0 141.3449608512281d0 93.95197627346832d0 127.56589471248853d0
          188.0145351462848d0 144.95940994104498d0 93.99911221785264d0 122.41390671413276d0
          180.62851914907282d0 149.02754402478263d0 92.6583809263804d0 127.28447894148572d0
          191.69520634589767d0 160.52538556481758d0 101.77931768076627d0 135.3427041223376d0
          205.25477757703595d0 166.7779987629947d0 106.34833836702704d0 142.2010238574181d0
          214.54703585435655d0 183.13634479295283d0 117.08801559283614d0 148.91618984200204d0
          235.18078744642918d0 201.43154941463192d0 121.62150854720092d0 151.40452356790036d0
          255.9299254917321d0 220.8321032813301d0 123.75077712982524d0 168.7963678376347d0
          270.035930794054d0 242.30940529442677d0 185.22630413075197d0 150.64979456631767d0
          324.0243522407124d0 229.55276469059592d0 167.90028332703596d0 264.97428363982823d0
          352.6838531914587d0 257.0456730966584d0 173.55736060937608d0 350.02185702626304d0
          395.4942323832321d0 266.16329101620914d0 179.51202435342776d0 394.89078520171086d0
          485.81469566035787d0 310.26994333174815d0 197.28261797421723d0 435.68785380829894d0
          525.990283624864d0 345.4798138796281d0 196.31154620314035d0 445.6932011076243d0
          622.6250913812652d0 354.17718661200513d0 195.50850747574302d0 512.2630720168844d0
          634.5998109030838d0 413.9894637007075d0 202.3015058572439d0 531.7210805822344d0
          712.9248324994825d0 458.9837261979168d0 232.99565966750285d0 556.1087366745968d0
          858.3366145063915d0 491.88205142974266d0 222.9930956583736d0 565.4290160923725d0
          892.3050214775814d0 457.42183246721294d0 233.03295998261865d0 674.5319930613564d0
          890.9100287278518d0 461.41388242317583d0 224.96033190714533d0 725.6368541806511d0
          946.1203913630569d0 458.44599774816186d0 225.77896634977932d0 724.9436788240448d0
          966.9231125548403d0 525.0363990074527d0 230.63278856176495d0 722.0457698903015d0
          1013.6392796427823d0 507.8156248794276d0 245.33089350282307d0 781.0409251250496d0
          1149.3193722698434d0 566.8734433262159d0 293.6811804222433d0 857.5353878918315d0
          1256.8668302235947d0 650.7271978623316d0 357.109252359615d0 847.1323726297013d0
          1335.916980986101d0 691.0208683583539d0 378.884720191268d0 898.0123754388738d0
          1414.9671317486086d0 731.3145388543767d0 400.6601880229212d0 948.8923782480464d0)
        (map 'list (lambda (p) (aref (ts-p-pos p) 0)) (ts-points pred))
        :test #'epsilon>))))
