; disable an irritating SBCL flag

(defparameter *files* '(
			"tests/deftest"  ; must be loaded first
			"tricks/lispfuns"
			"tricks/macros"
			"tricks/number"
			"tricks/string"
			"tricks/list"
			"tricks/hash"
			"tricks/random"
			"tricks/normal"
			"tricks/caution"
			"table/structs"
			"table/header"
			"table/data"
			"table/table"
			"table/xindex"
			"learn/nb"
			"utils/utillib"
			"utils/charts"
			))

(defparameter *menzies*
",;;;;iiijttjjfLLLLLGLGGDDDDDDLGGGttDKWW##W##W##WWW
,,;;;;;iittjjfffLLLLGGDDDDGGGLGGGtjfKW##W##W##WWWW
;;;;;;ittttfjjfLLGGGGGGDGGLLGGGGDjGDEW#W##W#WW##KW
,,;ii;iiittjjfLLLLLGfLGDGGGGDGGDDtfKWWW####WW#WW#W
,,;;iiiiittffffLfLLGLGGGGGDDGDDEDGDKWWWWW####WW#WW
,;;;;iiiittjfLfGLLGGGGDDDDDDDDDEEDGKWWW#WWWWWWWWWW
;;;i;iitttjjjjffLLLGGGGDGDDDDEEEGDEWKWWW#W#WWWWWWW
,;,;iiitttjfjLLfGLLGLGDDDGDDEEEGLLEWWWWWWWWWWWWWWW
,,;;;iittjjjffLLGDGGGDDDDGDEEELLGLLWWWWWWWWWWWKWKW
,;;i;ittjjjjffLGGDDGDGGGDGDDDGffLfjWKWWKWWKWWWWWWW
;,;;iiittjjjjfLLGDDDGGDDDDDDGfttjL;:WWWWWWWWWWWKWK
,;,ii;;;;ittttjffLGDDGDDGGGGtft,LKKi,iWWKWWKWWWWWK
,;;i;;;iiii;;;itjffGGLLGGGDijDDjLKKKE,;KWWKWWKWKKK
,,;i;;iittii;;itttjjfffGGK;.;GELEKKKKGt,EKWWKKWKKW
,;;;iitjtj;,,::,,;itjjfLGDj,t#LGEKKKKKKjtWWEWWKKKW
,;;;iitt,:::ti,:,,,;itjLGDjfLGfGE;D;i;t;,KKKWKKWKK
,,,;iii::..iift,,,:,;ijfLGffD#Gi,;LLD##KLKKKEKKEKK
.,,;;,:.;,.:,Lf;;i,;,;ijLGGLL:;;WW###KLGEKKKKKEKKK
: ,;,::,,;::jjtii;;;;;;;tLLL:jKWKE###jDiKKEKKEKKKK
,::.:,,,;;;iti;;;,::,,,,,.,,,DEKGLLjfjDKKEKKKKKEKE
;,,::t,,,;;,:.:,::;tjjWW:..:,EEEGjtffjiiDKKDKKEKKK
;;;,,.:. .:::;LLftijffjt;,LD,EEEGffjKiiiiDEKKKKKEE
;;;;;:.  .iGttttjttijtt;:ifGEKEEGL#j,;;titKKDEKKEK
,;;i;;.  tiiittttiittt;,:tfLD;jjf,;i,;;iiijEEKEEEE
,;;;iii:.tttjtjjttiii;,:;tfGDDEKE,,;,;;;iiiEEEEEEE
;,;iiii;.tttttjtti;,;,:;itfGDEEKE,,;,,;;iiijEDEEED
;;;i;iii.tttttttti,ii;;;itfGGEEKG:,,i,;;iiitiGEEDE
;;;;;;;i;,ttjtjjttt;it;iijfGDEGKL.:,i,;;ii;itiGGEE
;;;i;;;;i;:itttjj;:;tti;itfGEtfKj.:,;,;,;;;ijttGEG
,,;;i;;;;iitjjfft;,,:::,;ifGtttE;::,;;,;,;;;tttjfD
:,,i;;;;;iitjfLfi;,::::;i;;i;ijf,.::,i,,,;;;iittff
:,,;;;;;;iitjLLt;,,;::,;i;,ttii,i.::,i;,,,,;ijttjj
:,:,,,;;;;itjLL;:,:,::,,;;jjft;,.:::,i,,,;;,;Lttjf
:::,:,;,;;ijfLt:,,:,:,;iiifjGL,:::::,;;,,,,,;jtttj
.:::::,,;iijfG::::,,,;iijjfGLLt.:::::;t,,,,,;ttttt
......:,;ittLL,:,,;;,,;ijfLGjLL::::::,t,,,,:,ijttt
.:::..:;;;itLf::;;;;;;tjLGfttft::::.:,i,:,,:,iLttt
:... .:;,,;ijf;:;;;;,;tfjtitjLj::::.::;,:::::;fiii
:.... .;,::;;ti:;;;,,:,,;ifjfGt.:::.::,t,,:::;jtii
i. .. .,...,,i;,,,;,;,;tfjjfjft..::.:.:i::.::,jLii
.,    . ...::,;,;;,:;iitLtjtLj:  .i:..:i,::::,tjii
 ..      ...::;it;;;iiitfjjjtt...:.,..:;,,::::iit;
..;.   . .::.:,i,,;iijjLtf;i;,: ..:...:,t,,:::;if;
 .:....   . ..;,,:,ifjLffjiLi::..:::..:,t,::::;;ti
 . i....  ..,.:,;;;tffDGGtj:.::, :,:..::i,::::,tti
    ,:  . .  . :,:,ttjjLj;....:i..::...:;,,::.:iif
   .  ... .. .      .;,;::..:.:;.:::....,i,:::.;Lj
.   ....:.  ....... .........::;.:::...:,t,,::.,tt")

(defun SUPER-IMPORTANT-FUNCTION ()
  (format t "~a~&*** MENZIES IS WATCHING YOU COMPILE ***~&~&" *menzies*))

(defun make1 (files)
  (let ((n 0))
    (dolist (file files)  
      (format t ";;;; ~a.lisp~%"  file) 
      (incf n)
      (load file))
    (format t ";;;; ~a files loaded~%" n)))

(defun make (&optional (verbose nil))
  (SUPER-IMPORTANT-FUNCTION)
  (if verbose
      (make1 *files*)
      (handler-bind 
	  ((style-warning #'muffle-warning))
	(make1 *files*))))

(make)
