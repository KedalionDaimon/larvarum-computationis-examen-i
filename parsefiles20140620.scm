; This file parser is very similar to what I have in LarCom A.
; It will always parse files in both directions - from input and to plan,
; at once.

; USAGE:
; SET THE USER INPUT INTO usertoswarm.txt
; (You might actually just set there "cat input | tail -afewlines", to limit input
; length, thought that is not necessary, as each swarm insect will do that anyway.)
; It will then create out of this mutin.txt, containing the input as machine list.

; SET THE MACHINE OUTPUT INTO mutout.txt
; It will then translate the machine output into user-presentable input in
; swarmtouser.txt. This you may show again to the user.

; ORIGINALLY EMPTY are therefore mutin.txt and swarmtouser.txt.


; usertoswarm.txt: the (original) list of input from the outer world
; mutin.txt: the (targeted) list of input for the swarm
; mutout.txt: the (original) list of output by the swarm
; swarmtouser.txt: the (targeted) list of input to the outer world.

; +---------------------------------------------------+
; | Parse a String to Symbols and Symbols to a String |
; +---------------------------------------------------+

; The parts from this one on have actually not much to do with
; reasoning. They merely concern the technicalities of file I/O.
; Note only the final part that actually concerns activating
; file input into the system.

; Your system is reading a input "string", but actually, it shall operate on symbols.
; Moreover, in order to output an answer, it will again need to turn symbols to a string.

(define (proto-parsechars listofchars currentwordlist resultlist)
  (if (null? listofchars) ; then, IF we DO NOT have a word, give the result:
    (if (null? currentwordlist) resultlist ; or else append the word:
      (append resultlist (list (string->symbol (list->string currentwordlist)))))
    (let ((chart (chartester (car listofchars))))
      (if (list? chart) ; then terminate the word:
        (proto-parsechars (cdr listofchars) '()
          (append resultlist
          (if (null? currentwordlist) '() (list (string->symbol (list->string currentwordlist))))
          chart)) ; else just extend the word:
        (proto-parsechars (cdr listofchars)
          (append currentwordlist (list chart))
          resultlist)))))

(define (proto-parsesym mysymlist resultstring)
; (begin (display "mysymlist: ") (display mysymlist) (display #\newline)
(if (or (not (list? mysymlist)) (null? mysymlist)) resultstring
(let ((nextsymbol (car mysymlist)))
(cond ; tab and space not contained in this listing
((equal? nextsymbol 'scm-signal-dot) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\.))))
((equal? nextsymbol 'scm-signal-comma) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\,))))
((equal? nextsymbol 'scm-signal-bang) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\!))))
((equal? nextsymbol 'scm-signal-question) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\?))))
((equal? nextsymbol 'scm-signal-colon) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\:))))
((equal? nextsymbol 'scm-signal-semicolon) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\;))))
((equal? nextsymbol 'scm-signal-dash) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\-))))
((equal? nextsymbol 'scm-signal-quote) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\")))) ; due to syntax highlighting: " 
((equal? nextsymbol 'scm-signal-singlequote) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\'))))
((equal? nextsymbol 'scm-signal-plus) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\+))))
((equal? nextsymbol 'scm-signal-asterisk) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\*))))
((equal? nextsymbol 'scm-signal-divide) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\/))))
((equal? nextsymbol 'scm-signal-backslash) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\\))))
((equal? nextsymbol 'scm-signal-dollar) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\$))))
((equal? nextsymbol 'scm-signal-openpar) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\())))
((equal? nextsymbol 'scm-signal-closepar) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\)))))
((equal? nextsymbol 'scm-signal-opensqpar) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\[))))
((equal? nextsymbol 'scm-signal-closesqpar) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\]))))
((equal? nextsymbol 'scm-signal-underscore) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\_))))
((equal? nextsymbol 'scm-signal-hash) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\#))))
((equal? nextsymbol 'scm-signal-percent) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\%))))
((equal? nextsymbol 'scm-signal-tilde) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\~))))
((equal? nextsymbol 'scm-signal-and) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\&))))
((equal? nextsymbol 'scm-signal-biggerthan) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\>))))
((equal? nextsymbol 'scm-signal-smallerthan) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\<))))
((equal? nextsymbol 'scm-signal-pipe) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\|))))
((equal? nextsymbol 'scm-signal-powerof) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\^))))
((equal? nextsymbol 'scm-signal-equal) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\=))))
((equal? nextsymbol 'scm-signal-openshpar) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\{))))
((equal? nextsymbol 'scm-signal-closeshpar) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\}))))
((equal? nextsymbol 'scm-signal-newline) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\newline))))
((equal? nextsymbol 'scm-signal-othercharacter) (proto-parsesym (cdr mysymlist) (string-append resultstring (string #\_)))) ; underscore for unknown characters
(else (proto-parsesym (cdr mysymlist) (string-append resultstring " "
(if (symbol? nextsymbol) (symbol->string nextsymbol) (number->string nextsymbol))))))))) ; always append a space
; )

(define (chartester somecharacter) 
(cond 
((equal? somecharacter #\A) somecharacter)
((equal? somecharacter #\B) somecharacter) 
((equal? somecharacter #\C) somecharacter) 
((equal? somecharacter #\D) somecharacter) 
((equal? somecharacter #\E) somecharacter) 
((equal? somecharacter #\F) somecharacter) 
((equal? somecharacter #\G) somecharacter) 
((equal? somecharacter #\H) somecharacter) 
((equal? somecharacter #\I) somecharacter) 
((equal? somecharacter #\J) somecharacter) 
((equal? somecharacter #\K) somecharacter) 
((equal? somecharacter #\L) somecharacter) 
((equal? somecharacter #\M) somecharacter) 
((equal? somecharacter #\N) somecharacter) 
((equal? somecharacter #\O) somecharacter) 
((equal? somecharacter #\P) somecharacter) 
((equal? somecharacter #\Q) somecharacter) 
((equal? somecharacter #\R) somecharacter) 
((equal? somecharacter #\S) somecharacter) 
((equal? somecharacter #\T) somecharacter) 
((equal? somecharacter #\U) somecharacter) 
((equal? somecharacter #\V) somecharacter) 
((equal? somecharacter #\W) somecharacter) 
((equal? somecharacter #\X) somecharacter) 
((equal? somecharacter #\Y) somecharacter) 
((equal? somecharacter #\Z) somecharacter) 
((equal? somecharacter #\a) #\A) ; symbols are matched in caps
((equal? somecharacter #\b) #\B) 
((equal? somecharacter #\c) #\C) 
((equal? somecharacter #\d) #\D) 
((equal? somecharacter #\e) #\E) 
((equal? somecharacter #\f) #\F) 
((equal? somecharacter #\g) #\G) 
((equal? somecharacter #\h) #\H) 
((equal? somecharacter #\i) #\I) 
((equal? somecharacter #\j) #\J) 
((equal? somecharacter #\k) #\K) 
((equal? somecharacter #\l) #\L) 
((equal? somecharacter #\m) #\M) 
((equal? somecharacter #\n) #\N) 
((equal? somecharacter #\o) #\O) 
((equal? somecharacter #\p) #\P) 
((equal? somecharacter #\q) #\Q) 
((equal? somecharacter #\r) #\R) 
((equal? somecharacter #\s) #\S) 
((equal? somecharacter #\t) #\T) 
((equal? somecharacter #\u) #\U) 
((equal? somecharacter #\v) #\V) 
((equal? somecharacter #\w) #\W) 
((equal? somecharacter #\x) #\X) 
((equal? somecharacter #\y) #\Y) 
((equal? somecharacter #\z) #\Z) 
((equal? somecharacter #\0) somecharacter) 
((equal? somecharacter #\1) somecharacter) 
((equal? somecharacter #\2) somecharacter) 
((equal? somecharacter #\3) somecharacter) 
((equal? somecharacter #\4) somecharacter) 
((equal? somecharacter #\5) somecharacter) 
((equal? somecharacter #\6) somecharacter) 
((equal? somecharacter #\7) somecharacter) 
((equal? somecharacter #\8) somecharacter) 
((equal? somecharacter #\9) somecharacter) 
((equal? somecharacter #\.) '(scm-signal-dot)) 
((equal? somecharacter #\,) '(scm-signal-comma)) 
((equal? somecharacter #\!) '(scm-signal-bang)) 
((equal? somecharacter #\?) '(scm-signal-question)) 
((equal? somecharacter #\:) '(scm-signal-colon)) 
((equal? somecharacter #\;) '(scm-signal-semicolon)) 
((equal? somecharacter #\-) '(scm-signal-dash)) 
((equal? somecharacter #\") '(scm-signal-quote)) ; due to syntax highlighting: "
((equal? somecharacter #\') '(scm-signal-singlequote)) 
((equal? somecharacter #\+) '(scm-signal-plus)) 
((equal? somecharacter #\*) '(scm-signal-asterisk)) 
((equal? somecharacter #\/) '(scm-signal-divide)) 
((equal? somecharacter #\\) '(scm-signal-backslash)) 
((equal? somecharacter #\$) '(scm-signal-dollar)) 
((equal? somecharacter #\() '(scm-signal-openpar)) 
((equal? somecharacter #\)) '(scm-signal-closepar)) 
((equal? somecharacter #\[) '(scm-signal-opensqpar)) 
((equal? somecharacter #\]) '(scm-signal-closesqpar)) 
((equal? somecharacter #\_) '(scm-signal-underscore)) 
((equal? somecharacter #\#) '(scm-signal-hash)) 
((equal? somecharacter #\%) '(scm-signal-percent)) 
((equal? somecharacter #\~) '(scm-signal-tilde)) 
((equal? somecharacter #\&) '(scm-signal-and)) 
((equal? somecharacter #\>) '(scm-signal-biggerthan)) 
((equal? somecharacter #\<) '(scm-signal-smallerthan)) 
((equal? somecharacter #\|) '(scm-signal-pipe)) 
((equal? somecharacter #\^) '(scm-signal-powerof)) 
((equal? somecharacter #\=) '(scm-signal-equal)) 
((equal? somecharacter #\{) '(scm-signal-openshpar)) 
((equal? somecharacter #\}) '(scm-signal-closeshpar)) 
((equal? somecharacter #\newline) '(scm-signal-newline)) 
((equal? somecharacter #\space) '()) ; spaces and tabs are ignored.
; ((equal? somecharacter (car (string->list "	"))) '()) ; #'\t' works for jscheme, but not for kawa; and jscheme does not like #\tab, apparently.
(else '(scm-signal-othercharacter))))

(define (parsestringtosym mystring) (proto-parsechars (string->list mystring) '() '()))

(define (parsesymtostring mysymlist) (proto-parsesym mysymlist ""))

; sample call:
; (parsesymtostring (parsestringtosym "Hey, this is a test!")) --> " HEY, THIS IS A TEST!"

; +-------------------------------+
; | Read from and Write to a File |
; +-------------------------------+

; The READING part:

(define (attachnewline somestring) (string-append somestring (string #\newline)))

(define (slowstrappend mylistofstrings resultstring)
(if (null? mylistofstrings) resultstring
(slowstrappend (cdr mylistofstrings) (string-append resultstring (car mylistofstrings)))))

(define (readfile filenameasstring)
(call-with-input-file filenameasstring
(lambda (myfil)
(let reread ((line (read-line myfil)) (result '()))
(if (eof-object? line) (string->list (slowstrappend (map attachnewline (reverse result)) ""))
(reread (read-line myfil) (cons line result)))))))

; (define redfil "")

; (set! redfil (readfile "somefile.txt"))

; sample call:
; (display redfil) ; The file is displayed as it is read into chars.

; The WRITING part:

; (define outputf "schemwrite.txt")

(define (writeachar mycharlist outputfile)
(if (not (null? mycharlist))
(if (equal? (car mycharlist) #\newline )
(begin (newline outputfile) (writeachar (cdr mycharlist) outputfile))
(begin (display (car mycharlist) outputfile) (writeachar (cdr mycharlist) outputfile)))))

(define (writereport filenameasstring mystring)
(let ((outfile (open-output-file filenameasstring)))
(begin (writeachar (string->list mystring) outfile) (close-output-port outfile))))

; sample call:
; (writereport outputf "This is some funny text. I want to see it written.")

; +--------------------------------------+
; | Write to and Read from a File a List |
; +--------------------------------------+

(define inlist '())

(define (readlist filenameasstring)
(let ((infile (open-input-file filenameasstring)))
(begin (set! inlist (read infile)) (close-input-port infile))))
; sample call, given above outputf:
; (readlist outputf) --> #t
; inlist --> (this is another (rather fancy ((list))))

(define (writelist filenameasstring mylist)
(let ((outfile (open-output-file filenameasstring)))
(begin (display mylist outfile) (close-output-port outfile))))
; sample call, given:
; (define outputf "schemwrite.txt")
; (define myl '(this is another (rather fancy ((list)))))
; (writelist outputf myl) --> #t and the file contained
; (this is another (rather fancy ((list))))
; (writelist "./testlist.txt" '(this is another fancy (list for) testing purposes)) ; --> worked

; +---------------------------+
; | Specification of File I/O |
; +---------------------------+

; Define the files and symbol lists to be used:

(define userinput "./usertoswarm.txt")
(define useroutput "./swarmtouser.txt")
(define INPUTSYMBOLS '())
(define OUTPUTSYMBOLS '())
; (define atomdefinitions "./simpledefinitions.txt") ; DISABLE!!!!!!!!!!!!!!!!!!

; Read the user input:

(define giveuserinput
(begin
(set! INPUTSYMBOLS (parsestringtosym (list->string (readfile userinput))))
INPUTSYMBOLS))

; Answer with output to the user:

(define (senduseroutput OUTPUTSYMBOLS)
(begin
(writereport useroutput (parsesymtostring OUTPUTSYMBOLS))
(set! OUTPUTSYMBOLS '())))

; sample call - this translates correctly the infile to the outfile:
; (senduseroutput giveuserinput)

(begin
giveuserinput
; (writelist "mutin.txt" INPUTSYMBOLS) ; Now the system has the input.
; THE ABOVE FALSELY PLANTS A NEWLINE AT THE END. THE BELOW DOES NOT.
(writelist "mutin.txt" (reverse (cdr (reverse INPUTSYMBOLS)))) ; Now the system has the input.

(readlist "mutout.txt") ; Now inlist will contain the plan list.
(set! OUTPUTSYMBOLS inlist) ; Transfer inlist ready for output.
(senduseroutput OUTPUTSYMBOLS)) ; Show the plan list to the user.

