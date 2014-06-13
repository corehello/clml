		
(in-package "TEST")

(define-test test-changefinder
    (let (ts cf)
      (assert-true 
       (setf ts (time-series-data 
                 (read-data-from-file
                  (asdf:system-relative-pathname 'clml "sample/traffic-balance.csv") 
                  :type :csv
                  :csv-type-spec (cons 'string
                                       (make-list 6 :initial-element 'double-float)))
                 :except '(0) :time-label 0)))
      (assert-equality #'= 1015 (length (ts-points ts)))
      (assert-true (setf cf (init-changefinder (sub-ts ts :start 0 :end 24)
                                               :score-type :log
                                               :ts-wsize 5 :score-wsize 5 :sdar-k 4
                                               :discount 0.005d0)))
      (mapcar (lambda (v1 v2) (assert-equality #'epsilon> v2 v1))
              (loop for p across (ts-points (sub-ts ts :start 600 :end 700))
                  as new-dvec = (ts-p-pos p)
                  collect (update-changefinder cf new-dvec))
              '(-1.3797363034571708d0 -1.3795961682793476d0 -1.379720781467288d0
                -1.3789855425622917d0 -1.3783816425133972d0 -1.3781212478779616d0
                -1.378095784488397d0 -1.3780668550145976d0 -1.378250970536135d0
                -1.3774098858907229d0 -1.3769299164177125d0 -1.3771353332042175d0
                -1.3760731307374603d0 -1.3773754763969959d0 -1.3790269898650633d0
                -1.378913896872992d0 -1.3772692489313871d0 -1.3763699116554764d0
                -1.3767230047781904d0 -1.3766207674638924d0 -1.3768349100740598d0
                -1.377185285808378d0 -1.3791240713612714d0 -1.3783648889322373d0
                -1.378088927829769d0 -1.3781963217747295d0 -1.379553257610268d0
                -1.3781489683037715d0 -1.3760504060826948d0 -1.3746343476361687d0
                -1.3749596484988704d0 -1.3749081360916107d0 -1.375461834279887d0
                -1.3784316834844748d0 -1.372540488860761d0 -1.0837585519748112d0
                -0.7346578257054925d0 3.3001253457695854d0 11.650244476939047d0 
                18.50310647658157d0 22.28121534096392d0 26.467824637802245d0 
                24.464198058334517d0 16.481379988738137d0 9.799032850252917d0
                5.87529134731098d0 1.443293649004896d0 -0.43873919254848426d0
                -0.4812932371154776d0 -0.2860620408809028d0 -0.19485563284587762d0
                -0.17333728336441556d0 -0.21885495020162268d0 -0.41979970149497847d0
                -0.6865632685232942d0 -0.8166767946358178d0 -0.838444970824837d0 
                -0.8386689635041608d0 -0.8591248823829893d0 -0.863442731506443d0
                -0.8625840091031103d0 -0.8604755954905109d0 -0.8624715899698675d0
                -0.8631429373784227d0 -0.8646746958915932d0 -0.8654857585837362d0
                -0.8690271970958943d0 -0.8713773150623247d0 -0.872919579656305d0
                -0.8745920932568516d0 -0.8802393211350475d0 -0.8835295816057785d0
                -0.8848427065043787d0 -0.8881563311177907d0 -0.8892583129267433d0
                -0.8910656957432558d0 -0.892563656627645d0 -0.8899178253987099d0
                -0.8905099012829882d0 -0.892574380878018d0 -0.8936080329282261d0
                -0.8954887341421192d0 -0.9003763735708468d0 -0.9024866522671691d0
                -0.9038188481389537d0 -0.9053106822243665d0 -0.9065616703788392d0
                -0.9093304055924601d0 -0.9107965653723195d0 -0.910323723205139d0
                -0.9122056823086077d0 -0.9134551468479728d0 -0.9146034733008319d0
                -0.9161973131404066d0 -0.9192568943022852d0 -0.9206918318119188d0
                -0.9208655991015506d0 -0.9226912040313728d0 -0.9244976917100589d0
                -0.9266223201625129d0 -0.9282316568736432d0))))
