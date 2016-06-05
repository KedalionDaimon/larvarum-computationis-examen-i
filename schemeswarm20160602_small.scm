; GREATER SWARM PREPARATION:
; CHANGED KNOWLEDGESIZE TO 100k (was 50k) AND historylength TO 500
; (was 4k; overall history now insects*500). No further changes made.

; This is just like dirtriB20140603.scm, just that longenough has
; been correctly adjusted to notlongenough and besides, there is
; a splitfuse-function that can handle analogies in planning.

; THIS VERSION DISABLED INPUT HISTORY REHIERARCHISATION, SEE
; THE INTERACTIVE FUNCTION IN THE END!

; MAPCONS HAS BEEN CHANGED - TO ACCEPT EMPTY INPUT.

; The version "B" contains a more far-reaching snowflake mechanism
; (see below).

; LarCom E

; This system employs directional logical triangulation.
; The function proto-eval-triangle re-considers all possible cases of
; a directional conclusion. The predecessor system, victri, was
; operating exclusively on vic atoms. The system expresses the
; influence of a clause by putting it at the front of the list
; of all atoms (i.e. left-most) if it is influential. The system is
; not value-based but purely position-based.

; Herein, vic-connections are defined as dotted pairs - (a . b) - while
; ana-connections are expressed by means of lists - (a b).

; The precise manner of operation can be influenced below under
; USER-SET PARAMETERS.

; The present system has two enhancements to its reasoning mechanism.
; Firstly, it has a "re-slider" - a mechanism for re-considering input
; several times. - This is the "sledge". To disable the sledge, the
; iterations of re-sliding can be set to 0. Secondly, it considers the
; "considerations of the considerations" of a given vic-connection of
; input - and not only the vic-connection's sole considerations.
; (That mechanism may have become "too fanciful", but is still kept
; in existence.) It is implemented in the re-eval function below. If
; it is no longer desired, the "original" re-eval function may be
; re-implemented. - As reasoning, however, grows exponentially, it is
; being limited by the setting of "globallimit" - this global variable
; limits how many conclusions one single couple of atoms can enter
; into - if set to a negative value, it is effectively disabled.

; It could be re-considered whether planning really cannot incorporate
; at all ana-atoms, or whether simply one of the two alternatives has
; to be selected. The present choice - plans consist only out of vic-
; atoms - is more consistent, as only "elementary atoms" are in a
; vicinity, while the inclusion of ana-atoms would mean to include in
; planning the decision between alternatives. However, as one
; alternative _should_ exist, this would be imaginable.

; PREPARATIONS FOR THE USER-SET PARAMETERS:
; A text shall be given to the system for "pre-learning" prior to user
; interaction, so it already has some "fundamental ideas" and needs no
; teaching like a baby.

; For this purpose, the text shall be subdivided into partially
; overlapping sections.

; Take the first atoms of a list:
(define (proto-frontpart howfar inlist resultlist)
  (if (or (zero? howfar) (null? inlist)) (reverse resultlist)
    (proto-frontpart (- howfar 1) (cdr inlist) (cons (car inlist) resultlist))))

(define (frontpart howfar inlist) (proto-frontpart howfar inlist '()))
; sample call:
; (frontpart 3 '(a b c d e f)) --> (a b c)
; (frontpart 10 '(a b c d e f)) --> (a b c d e f)

; skip the first atoms of a list:
(define (skip howmany inlist)
  (if (or (zero? howmany) (null? inlist)) inlist
    (skip (- howmany 1) (cdr inlist))))
; (skip 2 '(a b c d e)) --> (c d e)
; (skip 0 '(a b c d e)) --> (a b c d e)

; The chainload function cuts a long input list of text to be learned
; into partially overlapping smaller portions.

(define (proto-chainload xskip ylength inlist resultlist)
  (if (null? inlist) (reverse resultlist)
    (proto-chainload xskip ylength (skip xskip inlist) (cons (frontpart ylength inlist) resultlist))))

(define (chainload xskip ylength inlist) (proto-chainload xskip ylength inlist '()))

; ==== USER-SET PARAMETERS ====

; "knowledgesize" determines the capacity of the system to contain atom
; connections - a higher count makes the system more intelligent.
(define knowledgesize 64000)

; "inmemory" determines on what size of input history the system shall
; reason - in particular, it should be longer than the longest expected
; input to the system. - If the input is longer, its front part is cut
; off and only the back part is used for reasoning.
(define inmemory 64)

; "re-slide-count" determines how often the system re-considers given
; input - set it to 0 in order to consider input only once.
(define re-slide-count 4)

; How many conclusions can be made with one pair that is in the focus
; of reasoning - set it to a negative number to enable unlimited
; reasoning, but beware that this quickly overwrites all other known
; atoms. It forces termination on countdown to "zero?".
(define globallimit 16)

; "rootlist" represents the initial list of "pre-set" learned material
; - the more, the better. This list can be also loaded from a prepared
; file - this is only a very short example. That list should be huge.
; This is used to implant previous knowledge into the system ere "using" it.
; (define rootlist '(a b c d e f g h i j))

; "initlist" defines a list of "chunks" of the rootlist, each "chunk"
; being separately learned by the system. This setting means:
; chunks of length three, each chunk progresses by 1 atom from the
; previous chunk (3 3 would have meant no repetitions in the chunks).
; The chunks can be of larger size - the larger, the better -
; however, large chunks use a lot of knowledge space as they are
; always fully hierarchised. "knowledgesize" must have been chosen
; appropriately large.
; (define initlist (chainload 1 3 rootlist))

(define snow-depth 1) ; how many re-considerations should be possible.
; use a snow-depth of 1 to have only 1 re-call (as before). "More
; fanciful" is a higher snow-depth.

; This defines how many words of past input may be maximum remembered.
; If all of the input words can be found inside the history, then this
; "insect" is suitable for handling said input.
(define historylength 64)

; ==== END OF USER-SET PARAMETERS ====

; That function is a cshift/eoshift-equivalent and has not been used -
; but should I ever start using vectors here, this may change:
; (define (proto-find-rotate element position listofallatoms resultlist)
;   (if (null? listofallatoms) (cons position (cons element (reverse (cdr resultlist))))
;     (if (equal? element (car listofallatoms))
;       (cons position (append (cons element (reverse resultlist)) (cdr listofallatoms)))
;       (proto-find-rotate element (+ 1 position) (cdr listofallatoms) (cons (car listofallatoms) resultlist)))))
; sample calls:
; (proto-find-rotate 'a 0 '(x y z a b c) '()) --> (3 a x y z b c)
; (proto-find-rotate 'q 0 '(x y z a b c) '()) --> (6 q x y z a b)

; (define (find-rotate element listofallatoms) (proto-find-rotate element 0 listofallatoms '()))

; In order to look at possible connections within the input, it should
; be split into possible pairs. This is done by the following function
; based on this observation:
; (map cons '(a b c) '(x y z)) --> ((a . x) (b . y) (c . z))
(define (mapcons fulllist)
(if (null? fulllist) '()
(map cons (reverse (cdr (reverse fulllist))) (cdr fulllist))))
; a variation of it could be, if you wish to tolerate the existence of
; (a)-style "connection", would be this:
; (define (mapcons fulllist) (map cons fulllist (cdr fulllist)))
; that would be interesting for "no-response-plans", i.e. where "A" is
; found and the response is "()".
; sample call of current version:
; (mapcons '(a b c d)) --> ((a . b) (b . c) (c . d))

; If a vic-connection of the type (a . a), i.e. between the same atom,
; is observed, it cannot participate in further reasoning. - The only
; question is, whether it can be confirmed as already observed or not.
; A question is whether I should loot at analogies of the type (a a).
; Currently, they are not considered as I have not foreseen a way for
; their creation - that an atom is analogous to itself really needs no
; explicit mentioning.
(define (extractpair sameatoms listofallatoms atomschecked)
  (if (null? listofallatoms)
    (cons '() (cons sameatoms (reverse atomschecked)))
    (if (equal? sameatoms (car listofallatoms))
      (cons #t (cons sameatoms (append (reverse atomschecked) (cdr listofallatoms) '((nihil . nihil)))))
      (extractpair sameatoms (cdr listofallatoms) (cons (car listofallatoms) atomschecked)))))
; sample calls:
; (extractpair '(a . a) '((b . c) (c . d) (d . e) (e . f)) '()) --> (() (a . a) (b . c) (c . d) (d . e) (e . f))
; (extractpair '(a . a) '((b . c) (c . d) (d . e) (a . a)) '()) --> (#t (a . a) (b . c) (c . d) (d . e) (nihil . nihil))

; The below triangulation function tests different conditions that
; may have been triggered by triangulation. They are one of:
; - reaching a confirmative conclusion - #t;
; - reaching a contradicting conclusion - #f; - I may consider to
; merely deliver "(#f)" in such a case, rather than the entire main
; knowledge list, if I do not re-use that list with the contradiction;
; - an inconclusive state - '() - when nothing can be said;
; none of the above, which warrants a re-try as long as there are
; untested atoms in the list of all atoms.

; In the below triangulation function, meeting the "opposite" of a
; connection means, generally, a contradiction to it. That is true
; in particular for the first and the third pairs. The first pair must
; either be confirmed by direct observation or conclude its triangle
; before its "opposite" can be seen. A=B (being the same as (B=A),
; A->B and B->A (these latter are considered distinct) are each a
; possible "opposite" of the other two. Only the second pair is
; so far more tolerant to being countered - it is only "dropped" but
; does not stop further reasoning, and that is only the case if the
; proposed third atom has not yet been seen.

; CONSIDER REPLACING THE "IF's" WITH ONE HUGE "COND".

; Avoiding "double" analogies - (b a) and (a b) - should already be the
; case as the "recognition" of analogies also checks for their reverse.

; A few effects used herein:
; (equal? (car '(a . b)) (cdar '((x . a)))) --> #t
; A->B X->A : X->B : (cons (caar '((x . a))) (cdr '(a . b)))
; (equal? (cdr '(a . b)) (caar '((b . x)))) --> #t
; A->B B->X : A->X : (cons (car '(a . b)) (cdar '((b . x))))
; (cons (cdr '(x . y)) (car '(x . y))) --> (y . x)

; A little auxiliary function to distinguish a "pair" and a "list" of
; two elements - the one is a vic-connection, the other is an ana-
; connection, and they are treated differently:
(define (pair x) (if (and (pair? x) (not (list? x))) #t #f))
; JScheme behaves as if "its" "pair?" is "my" "pair", but other
; Schemes do not.

(define (proto-eval-triangle firstpair secondpair thirdpair firstpairseen secondpairseen thirdpairseen inconclusives listofallatoms atomschecked)
; You may uncomment (begin ... ) in order to trace reasoning.

  (cond

  ; POSITIVE:
  ; all three sides seen, triangulation possible:
  ((if (and (equal? #t firstpairseen) (equal? #t secondpairseen) (equal? #t thirdpairseen)) #t #f)
;   (begin (display #\newline) (display "CLAUSE 1 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display #\newline))
    (cons #t (append (cons firstpair (cons secondpair (cons thirdpair (reverse atomschecked)))) listofallatoms '((nihil . nihil)))))

  ; INCONCLUSIVE:
  ; nothing whatsoever has been seen - thirdpairseen is impossible if secondpairseen is #f:
  ((if (and (null? listofallatoms) (equal? #f firstpairseen) (equal? #f secondpairseen)) #t #f)
;   (begin (display #\newline) (display "CLAUSE 2 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display #\newline))
    (cons '() (cons firstpair (reverse atomschecked))))

  ; RECOGNISED:
  ; only the first pair has been seen:
  ((if (and (null? listofallatoms) (equal? #t firstpairseen) (equal? #f secondpairseen) (equal? #f thirdpairseen)) #t #f)
;   (begin (display #\newline) (display "CLAUSE 3 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display #\newline))
    (cons #t (cons firstpair (append (reverse atomschecked) '((nihil . nihil))))))

  ; CONCLUDED:
  ; the first pair has been seen and the second pair has been seen - the third pair is the "conclusion":
  ((if (and (null? listofallatoms) (equal? #t firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen)) #t #f)
;   (begin (display #\newline) (display "CLAUSE 4 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display #\newline))
    (cons #t (cons firstpair (cons secondpair (cons thirdpair (reverse atomschecked))))))

  ; CONCLUDED:
  ; the first pair has not been seen, but everything else has been seen - the first pair is the "conclusion":
  ((if (and (null? listofallatoms) (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #t thirdpairseen)) #t #f)
;   (begin (display #\newline) (display "CLAUSE 5 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display #\newline))
    (cons #t (cons firstpair (cons secondpair (cons thirdpair (reverse atomschecked))))))
 ; same as above one

  ; INCONCLUSIVE:
  ; the first pair has not been seen, but is a hypothesis - but the third pair cannot yet be concluded;
  ; still, the first and the second pair can be put on the front part:
  ((if (and (null? listofallatoms) (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen)) #t #f)
;   (begin (display #\newline) (display "CLAUSE 6 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display #\newline))
    (cons '() (cons firstpair (cons secondpair (reverse atomschecked)))))

  ; NEGATIVE - THIRD PAIR CONTRADICTED, FIRST PAIR SEEN (pair): --- THIS IS EXPRESSED A BIT UNUSUALLY COMPARED TO BELOW
  ((if (and (equal? #t firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen) (pair thirdpair)
    (or (and (list? (car listofallatoms))
        (or (equal? (car listofallatoms) (list (car thirdpair) (cdr thirdpair)))
            (equal? (car listofallatoms) (list (cdr thirdpair) (car thirdpair)))))
    (and (pair (car listofallatoms))
         (equal? (car listofallatoms) (cons (cdr thirdpair) (car thirdpair)))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 7 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
      (cons #f (append (reverse atomschecked) listofallatoms (list thirdpair secondpair firstpair))))

  ; NEGATIVE - THIRD PAIR CONTRADICTED, FIRST PAIR sEEN (list):
  ((if (and (equal? #t firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen) (list? thirdpair)
           (pair (car listofallatoms))
           (or (equal? (car listofallatoms) (cons (car thirdpair) (cadr thirdpair)))
               (equal? (car listofallatoms) (cons (cadr thirdpair) (car thirdpair))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 8 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
      (cons #f (append (reverse atomschecked) listofallatoms (list thirdpair secondpair firstpair))))

  ; NEGATIVE - THIRD PAIR CONTRADICTED, FIRST PAIR NOT SEEN (pair): --- THIS IS EXPRESSED A BIT UNUSUALLY COMPARED TO BELOW
  ((if (and (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen) (pair thirdpair)
    (or (and (list? (car listofallatoms))
        (or (equal? (car listofallatoms) (list (car thirdpair) (cdr thirdpair)))
            (equal? (car listofallatoms) (list (cdr thirdpair) (car thirdpair)))))
    (and (pair (car listofallatoms))
         (equal? (car listofallatoms) (cons (cdr thirdpair) (car thirdpair)))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 9 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
      (cons #f (append (reverse atomschecked) listofallatoms (list thirdpair secondpair))))

  ; NEGATIVE - THIRD PAIR CONTRADICTED, FIRST PAIR NOT SEEN (list):
  ((if (and (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen) (list? thirdpair)
           (pair (car listofallatoms))
           (or (equal? (car listofallatoms) (cons (car thirdpair) (cadr thirdpair)))
               (equal? (car listofallatoms) (cons (cadr thirdpair) (car thirdpair))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 10 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
      (cons #f (append (reverse atomschecked) listofallatoms (list thirdpair secondpair))))

  ; NEGATIVE - FIRST PAIR CONTRADICTED BEFORE IT WAS SEEN, SECOND ATOM NOT SEEN, EITHER (pair):
  ((if (and (equal? #f firstpairseen) (equal? #f secondpairseen) (pair firstpair)
           (or (and (pair (car listofallatoms)) (equal? (car listofallatoms) (cons (cdr firstpair) (car firstpair))))
               (and (list? (car listofallatoms))
                    (or (equal? (car listofallatoms) (list (car firstpair) (cdr firstpair)))
                        (equal? (car listofallatoms) (list (cdr firstpair) (car firstpair))))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 11 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (cons #f (append (reverse atomschecked) listofallatoms (list firstpair))))

  ; NEGATIVE - FIRST PAIR CONTRADICTED BEFORE IT WAS SEEN, SECOND ATOM NOT SEEN, EITHER (list):
  ((if (and (equal? #f firstpairseen) (equal? #f secondpairseen) (list? firstpair)
           (pair (car listofallatoms))
               (or (equal? (car listofallatoms) (cons (car firstpair) (cadr firstpair)))
                   (equal? (car listofallatoms) (cons (cadr firstpair) (car firstpair))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 12 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (cons #f (append (reverse atomschecked) listofallatoms (list firstpair))))

  ; NEGATIVE - FIRST PAIR CONTRADICTED BEFORE IT WAS SEEN, SECOND ATOM SEEN, THIRD ATOM NOT SEEN (pair):
  ((if (and (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen) (pair firstpair)
           (or (and (pair (car listofallatoms)) (equal? (car listofallatoms) (cons (cdr firstpair) (car firstpair))))
               (and (list? (car listofallatoms))
                    (or (equal? (car listofallatoms) (list (car firstpair) (cdr firstpair)))
                        (equal? (car listofallatoms) (list (cdr firstpair) (car firstpair))))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 13 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (cons #f (append (reverse atomschecked) listofallatoms (list secondpair firstpair))))

  ; NEGATIVE - FIRST PAIR CONTRADICTED BEFORE IT WAS SEEN, SECOND ATOM SEEN, THIRD ATOM NOT SEEN (list):
  ((if (and (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #f thirdpairseen) (list? firstpair)
           (pair (car listofallatoms))
               (or (equal? (car listofallatoms) (cons (car firstpair) (cadr firstpair)))
                   (equal? (car listofallatoms) (cons (cadr firstpair) (car firstpair))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 14 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (cons #f (append (reverse atomschecked) listofallatoms (list secondpair firstpair))))

  ; NEGATIVE - FIRST PAIR CONTRADICTED BEFORE IT WAS SEEN, SECOND ATOM SEEN, THIRD ATOM SEEN:
  ((if (and (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #t thirdpairseen) (pair firstpair)
           (or (and (pair (car listofallatoms)) (equal? (car listofallatoms) (cons (cdr firstpair) (car firstpair))))
               (and (list? (car listofallatoms))
                    (or (equal? (car listofallatoms) (list (car firstpair) (cdr firstpair)))
                        (equal? (car listofallatoms) (list (cdr firstpair) (car firstpair))))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 15 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (cons #f (append (reverse atomschecked) listofallatoms (list thirdpair secondpair firstpair))))

  ; NEGATIVE - FIRST PAIR CONTRADICTED BEFORE IT WAS SEEN, SECOND ATOM SEEN, THIRD ATOM SEEN:
  ((if (and (equal? #f firstpairseen) (equal? #t secondpairseen) (equal? #t thirdpairseen) (list? firstpair)
           (pair (car listofallatoms))
               (or (equal? (car listofallatoms) (cons (car firstpair) (cadr firstpair)))
                   (equal? (car listofallatoms) (cons (cadr firstpair) (car firstpair))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 16 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (cons #f (append (reverse atomschecked) listofallatoms (list thirdpair secondpair firstpair))))

  ; RECALL - THIRD PAIR SEEN (pair):
  ; whether the first pair is seen or not is determined in the re-call, i.e. whether all three sides were seen.
  ((if (and (equal? #t secondpairseen) (equal? #f thirdpairseen) (pair thirdpair)
           (pair (car listofallatoms)) (equal? (car listofallatoms) thirdpair)) #t #f) ; then re-call with thirdpairseen set to "true"
;   (begin (display #\newline) (display "CLAUSE 17 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair secondpair thirdpair firstpairseen secondpairseen #t inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - THIRD PAIR SEEN (list):
  ; whether the first pair is seen or not is determined in the re-call, i.e. whether all three sides were seen.
  ((if (and (equal? #t secondpairseen) (equal? #f thirdpairseen) (list? thirdpair)
           (list? (car listofallatoms))
           (or (equal? (car listofallatoms) thirdpair)
               (equal? (car listofallatoms) (reverse thirdpair)))) #t #f) ; then re-call with thirdpairseen set to "true"
;   (begin (display #\newline) (display "CLAUSE 18 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair secondpair thirdpair firstpairseen secondpairseen #t inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - FIRST PAIR SEEN (pair):
  ((if (and (equal? #f firstpairseen) (pair firstpair)
           (pair (car listofallatoms)) (equal? (car listofallatoms) firstpair)) #t #f) ; then re-call with firstpairseen set to "true"
;   (begin (display #\newline) (display "CLAUSE 19 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair secondpair thirdpair #t secondpairseen thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - FIRST PAIR SEEN (list):
  ((if (and (equal? #f firstpairseen) (list? firstpair)
           (list? (car listofallatoms))
           (or (equal? (car listofallatoms) firstpair)
               (equal? (car listofallatoms) (reverse firstpair)))) #t #f) ; then re-call with firstpairseen set to "true"
;   (begin (display #\newline) (display "CLAUSE 20 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair secondpair thirdpair #t secondpairseen thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, first possibility vic-vic-vic):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (pair (car listofallatoms))
           (equal? (car firstpair) (cdar listofallatoms))
           (not (equal? (cdr firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 21 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (caar listofallatoms) (cdr firstpair))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, second possibility vic-vic-vic):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (pair (car listofallatoms))
           (equal? (cdr firstpair) (caar listofallatoms))
           (not (equal? (car firstpair) (cdar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 22 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (car firstpair) (cdar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, third possibility vic-vic-ana):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (pair (car listofallatoms))
           (equal? (car firstpair) (caar listofallatoms))
           (not (equal? (cdr firstpair) (cdar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 23 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (list (cdr firstpair) (cdar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, fourth possibility vic-vic-ana):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (pair (car listofallatoms))
           (equal? (cdr firstpair) (cdar listofallatoms))
           (not (equal? (car firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 24 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (list (car firstpair) (caar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (list and list, first possibility ana-ana-ana):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (list? (car listofallatoms))
           (equal? (car firstpair) (caar listofallatoms))
           (not (equal? (cadr firstpair) (cadar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 25 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (list (cadr firstpair) (cadar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (list and list, second possibility ana-ana-ana):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (list? (car listofallatoms))
           (equal? (cadr firstpair) (cadar listofallatoms))
           (not (equal? (car firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 26 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (list (car firstpair) (caar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (list and list, third possibility ana-ana-ana):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (list? (car listofallatoms))
           (equal? (car firstpair) (cadar listofallatoms))
           (not (equal? (cadr firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 27 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (list (cadr firstpair) (caar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (list and list, fourth possibility ana-ana-ana):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (list? (car listofallatoms))
           (equal? (cadr firstpair) (caar listofallatoms))
           (not (equal? (car firstpair) (cadar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 28 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (list (car firstpair) (cadar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, first possibility vic-ana-vic):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (list? (car listofallatoms))
           (equal? (car firstpair) (caar listofallatoms))
           (not (equal? (cdr firstpair) (cadar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 29 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (cadar listofallatoms) (cdr firstpair))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, second possibility vic-ana-vic):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (list? (car listofallatoms))
           (equal? (cdr firstpair) (cadar listofallatoms))
           (not (equal? (car firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 30 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (car firstpair) (caar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, third possibility vic-ana-vic):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (list? (car listofallatoms))
           (equal? (car firstpair) (cadar listofallatoms))
           (not (equal? (cdr firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 31 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (caar listofallatoms) (cdr firstpair))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, fourth possibility vic-ana-vic):
  ((if (and (equal? #f secondpairseen) (pair firstpair) (list? (car listofallatoms))
           (equal? (cdr firstpair) (caar listofallatoms))
           (not (equal? (car firstpair) (cadar listofallatoms)))
           (not (equal? (car firstpair) (cdr firstpair)))
           (not (equal? (caar listofallatoms) (cadar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 32 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (car firstpair) (cadar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, first possibility ana-vic-vic):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (pair (car listofallatoms))
           (equal? (car firstpair) (caar listofallatoms))
           (not (equal? (cadr firstpair) (cdar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 33 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (cadr firstpair) (cdar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, second possibility ana-vic-vic):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (pair (car listofallatoms))
           (equal? (cadr firstpair) (cdar listofallatoms))
           (not (equal? (car firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 34 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (caar listofallatoms) (car firstpair))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, third possibility ana-vic-vic):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (pair (car listofallatoms))
           (equal? (car firstpair) (cdar listofallatoms))
           (not (equal? (cadr firstpair) (caar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 35 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (caar listofallatoms) (cadr firstpair))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR SEEN (pair and pair, fourth possibility ana-vic-vic):
  ((if (and (equal? #f secondpairseen) (list? firstpair) (pair (car listofallatoms))
           (equal? (cadr firstpair) (caar listofallatoms))
           (not (equal? (car firstpair) (cdar listofallatoms)))
           (not (equal? (car firstpair) (cadr firstpair)))
           (not (equal? (caar listofallatoms) (cdar listofallatoms)))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 36 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair (car listofallatoms) (cons (car firstpair) (cdar listofallatoms))
      firstpairseen #t thirdpairseen inconclusives (cdr listofallatoms) atomschecked))

  ; RECALL - SECOND PAIR CONTRADICTED ERE USED FOR A THIRD ATOM (pair):
  ; this is not a termination reason, as the hypothesis of the first atom was not per se being contradicted:
  ((if (and (equal? #t secondpairseen) (equal? #f thirdpairseen) (pair secondpair)
           (or (and (pair (car listofallatoms)) (equal? (car listofallatoms) (cons (cdr secondpair) (car secondpair))))
               (and (list? (car listofallatoms))
                    (or (equal? (car listofallatoms) (list (car secondpair) (cdr secondpair)))
                        (equal? (car listofallatoms) (list (cdr secondpair) (car secondpair))))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 37 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair '() '() firstpairseen #f #f inconclusives (cdr listofallatoms)
      (cons secondpair (cons (car listofallatoms) atomschecked))))
 ; the second pair will end up next to and behind its contradiction

  ; RECALL - SECOND PAIR CONTRADICTED ERE USED FOR A THIRD ATOM (list):
  ; this is not a termination reason, as the hypothesis of the first atom was not per se being contradicted:
  ((if (and (equal? #t secondpairseen) (equal? #f thirdpairseen) (list? secondpair)
           (pair (car listofallatoms))
           (or (equal? (car listofallatoms) (cons (car secondpair) (cadr secondpair)))
               (equal? (car listofallatoms) (cons (cadr secondpair) (car secondpair))))) #t #f)
;   (begin (display #\newline) (display "CLAUSE 38 ") (display " FIRST: ") (display firstpair) (display "  SECOND: ") (display secondpair) (display "  THIRD: ") (display thirdpair) (display "  CAR_L: ") (display (car listofallatoms)) (display #\newline))
    (proto-eval-triangle firstpair '() '() firstpairseen #f #f inconclusives (cdr listofallatoms)
      (cons secondpair (cons (car listofallatoms) atomschecked))))
 ; the second pair will end up next to and behind its contradiction

  ; RECALL - NOTHING OF INTEREST HAPPENED:
  (#t
  (proto-eval-triangle firstpair secondpair thirdpair firstpairseen secondpairseen thirdpairseen inconclusives
    (cdr listofallatoms) (cons (car listofallatoms) atomschecked)))))

(define (eval-triangle firstpair listofallatoms)
  (if (equal? (car firstpair) (cdr firstpair))
    (extractpair firstpair listofallatoms '())
    (proto-eval-triangle firstpair '() '() #f #f #f '() listofallatoms '())))

; The sample calls were mainly inspired by the victri-predecessor:
; sample calls (non-exhaustive):

; positive triangulation 1:
; (eval-triangle '(a . b) '((x . y) (b . c) (a . c) (y . z) (q . r) (a . b)))
; --> (#t (a . b) (b . c) (a . c) (x . y) (y . z) (q . r) (nihil . nihil))

; negative triangulation 1:
; (eval-triangle '(a . b) '((x . y) (b . c) (a . b) (c . a) (y . z) (q . r)))
; --> (#f (x . y) (c . a) (y . z) (q . r) (a . c) (b . c) (a . b))

; positive triangulation 2:
; (eval-triangle '(a . b) '((x . y) (z . a) (a . b) (z . b) (y . z) (q . r)))
; --> (#t (a . b) (z . a) (z . b) (x . y) (y . z) (q . r) (nihil . nihil))

; negative triangulation 2:
; (eval-triangle '(a . b) '((x . y) (z . a) (a . b) (b . z) (y . z) (q . r)))
; --> (#f (x . y) (b . z) (y . z) (q . r) (z . b) (z . a) (a . b))

; positive triangulation 3:
; (eval-triangle '(a . b) '((x . y) (b c) (a . c) (y . z) (q . r) (a . b)))
; --> (#t (a . b) (b c) (a . c) (x . y) (y . z) (q . r) (nihil . nihil))

; negative triangulation 3:
; (eval-triangle '(a . b) '((x . y) (b c) (a c) (y . z) (q . r) (a . b)))
; --> (#f (x . y) (a c) (y . z) (q . r) (a . b) (a . c) (b c))

; positive triangulation 4:
; (eval-triangle '(a b) '((x . y) (b . c) (a . c) (y . z) (q . r) (a b)))
; --> (#t (a b) (b . c) (a . c) (x . y) (y . z) (q . r) (nihil . nihil))

; negative triangulation 3:
; (eval-triangle '(a b) '((x . y) (b . c) (a c) (y . z) (q . r) (a b)))
; --> (#f (x . y) (a c) (y . z) (q . r) (a b) (a . c) (b . c))

; positive triangulation 5:
; (eval-triangle '(a b) '((x . y) (b c) (a c) (y . z) (q . r) (a b)))
; --> (#t (a b) (b c) (a c) (x . y) (y . z) (q . r) (nihil . nihil))

; negative triangulation 5:
; (eval-triangle '(a b) '((x . y) (b . c) (c . a) (y . z) (q . r) (a b)))
; --> (#f (x . y) (c . a) (y . z) (q . r) (a b) (a . c) (b . c))

; conclusion 1:
; (eval-triangle '(a . b) '((x . y) (b . c) (a . b) (e . f) (y . z) (q . r)))
; --> (#t (a . b) (b . c) (a . c) (x . y) (e . f) (y . z) (q . r))

; conclusion 2:
; (eval-triangle '(a . b) '((x . y) (z . a) (a . b) (e . f) (y . z) (q . r)))
; --> (#t (a . b) (z . a) (z . b) (x . y) (e . f) (y . z) (q . r))

; conclusion 3:
; (eval-triangle '(a . b) '((x . y) (b . c) (a . c) (e . f) (y . z) (q . r)))
; --> (#t (a . b) (b . c) (a . c) (x . y) (e . f) (y . z) (q . r))

; conclusion 4:
; (eval-triangle '(a . b) '((x . y) (z . a) (z . b) (e . f) (y . z) (q . r)))
; --> (#t (a . b) (z . a) (z . b) (x . y) (e . f) (y . z) (q . r))

; conclusion 5:
; (eval-triangle '(a . b) '((x . y) (b c) (a . b) (e . f) (y . z) (q . r)))
; --> (#t (a . b) (b c) (a . c) (x . y) (e . f) (y . z) (q . r))

; conclusion 6:
; (eval-triangle '(a b) '((x . y) (b . c) (a b) (e . f) (y . z) (q . r)))
; --> (#t (a b) (b . c) (a . c) (x . y) (e . f) (y . z) (q . r))

; conclusion 7:
; (eval-triangle '(a . b) '((x . y) (a . c) (a . b) (e . f) (y . z) (q . r)))
; --> (#t (a . b) (a . c) (b c) (x . y) (e . f) (y . z) (q . r))

; conclusion 8:
; (eval-triangle '(a b) '((x . y) (b c) (a b) (e . f) (y . z) (q . r)))
; --> (#t (a b) (b c) (a c) (x . y) (e . f) (y . z) (q . r))

; counter-conclusion 1:
; (eval-triangle '(a . b) '((x . y) (b . c) (b . a) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (b . a) (e . f) (y . z) (q . r) (b . c) (a . b))

; counter-conclusion 2:
; (eval-triangle '(a . b) '((x . y) (z . a) (b . a) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (b . a) (e . f) (y . z) (q . r) (z . a) (a . b))

; counter-conclusion 3:
; (eval-triangle '(a . b) '((x . y) (b . c) (c . a) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (c . a) (e . f) (y . z) (q . r) (a . c) (b . c))

; counter-conclusion 4:
; (eval-triangle '(a . b) '((x . y) (z . a) (b . z) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (b . z) (e . f) (y . z) (q . r) (z . b) (z . a))

; counter-conclusion 5:
; (eval-triangle '(a . b) '((x . y) (b c) (a b) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (a b) (e . f) (y . z) (q . r) (b c) (a . b))

; counter-conclusion 6:
; (eval-triangle '(a b) '((x . y) (b . c) (c . a) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (c . a) (e . f) (y . z) (q . r) (a . c) (b . c))

; counter-conclusion 7:
; (eval-triangle '(a . b) '((x . y) (a c) (a b) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (a b) (e . f) (y . z) (q . r) (a c) (a . b))

; counter-conclusion 8:
; (eval-triangle '(a b) '((x . y) (b . c) (a . b) (e . f) (y . z) (q . r)))
; --> (#f (x . y) (a . b) (e . f) (y . z) (q . r) (b . c) (a b))

; inconclusive - A-B is proposed, but cannot be proven in any way:
; (eval-triangle '(a . b) '((x . y) (g . h) (f . g) (e . f) (y . z) (q . r)))
; --> (() (a . b) (x . y) (g . h) (f . g) (e . f) (y . z) (q . r))

; inconclusive - A=B is proposed, but cannot be proven in any way:
; (eval-triangle '(a b) '((x . y) (g . h) (f . g) (e . f) (y . z) (q . r)))
; --> (() (a b) (x . y) (g . h) (f . g) (e . f) (y . z) (q . r))

; inconclusive - vicinal combination possible, but proposal unknown:
; (eval-triangle '(a . b) '((x . y) (g . h) (b . c) (e . f) (y . z) (q . r)))
; --> (() (a . b) (b . c) (x . y) (g . h) (e . f) (y . z) (q . r))

; inconclusive - analogous combination possible, but proposal unknown:
; (eval-triangle '(a b) '((x . y) (g . h) (b . c) (e . f) (y . z) (q . r)))
; --> (() (a b) (b . c) (x . y) (g . h) (e . f) (y . z) (q . r))

; direct confirmation 1:
; (eval-triangle '(a . b) '((x . y) (e . f) (a . b) (b . a) (y . z) (q . r)))
; --> (#t (a . b) (x . y) (e . f) (b . a) (y . z) (q . r) (nihil . nihil))

; direct confirmation 2:
; (eval-triangle '(a b) '((x . y) (e . f) (a b) (b . a) (y . z) (q . r)))
; --> (#t (a b) (x . y) (e . f) (b . a) (y . z) (q . r) (nihil . nihil))

; direct confirmation 3:
; (eval-triangle '(a b) '((x . y) (e . f) (b a) (b . a) (y . z) (q . r)))  
; --> (#t (a b) (x . y) (e . f) (b . a) (y . z) (q . r) (nihil . nihil))

; the atom doubling in the end is not good:

; direct contradiction 1:
; (eval-triangle '(a . b) '((x . y) (e . f) (b . a) (q . e) (y . z) (a . b)))
; --> (#f (x . y) (e . f) (b . a) (q . e) (y . z) (a . b) (a . b))

; direct contradiction 2:
; (eval-triangle '(a . b) '((x . y) (b . c) (b . a) (q . e) (y . z) (a . b)))
; --> (#f (x . y) (b . a) (q . e) (y . z) (a . b) (b . c) (a . b))

; direct contradiction 3:
; (eval-triangle '(a . b) '((x . y) (b . c) (a . c) (b . a) (y . z) (a . b)))
; --> (#f (x . y) (b . a) (y . z) (a . b) (a . c) (b . c) (a . b))

; direct contradiction 4:
; (eval-triangle '(a . b) '((x . y) (e . f) (b a) (q . e) (y . z) (a . b)))
; --> (#f (x . y) (e . f) (b a) (q . e) (y . z) (a . b) (a . b))

; direct contradiction 5:
; (eval-triangle '(a b) '((x . y) (e . f) (a . b) (q . e) (y . z) (a b)))
; --> (#f (x . y) (e . f) (a . b) (q . e) (y . z) (a b) (a b))

; say that a list must have at least 3 elements to be considered for
; triangulation (minimum for recognising three known triangle sides):
(define (notlongenough somelist)
(if (or
  (null? somelist)
  (null? (cdr somelist))
  (null? (cddr somelist)))
  #t #f))
; sample calls:
; (notlongenough '(a b)) --> #t
; (notlongenough '(a b c)) --> #f
; later on, I will use cddddr, i.e. one "cdr" more, because I know that the list
; will have a #t, #f or () attached in front.

; OPERATION SNOWFLAKE:
; As an improvement to an earlier version, not only a term is evaluated,
; but also each of the participants in its triangulations is evaluated.
; I.e., each of the two other sides now tries to reach further
; conclusions. - That means that inheritance of conclusions is possible
; even if not directly driven by input. (That might be too far-reaching
; and too "fanciful", which is why the old version above is kept for
; reference.) - I am calling this figure a "snowflake" as further
; triangles may thus emerge from the sides of triangles.

; Relying only on the first pair for confirming a term is possible, but
; other choices are possible, too. Relying on the first pair bases
; reasoning on the basis of "most recent experience". But if one were
; to base reasoning on the "most consistent recent experience", one
; should look at further combination possibilities of a given term -
; namely, HOW MANY positive conclusions can be made without
; hitting a contradiction. This is done by re-evaluating a term on the
; list of all atoms "apart from" positive previous conclusions.

; (OLD VERSION: THIS IS A SOLO-EVALUATION - NOT SNOWFLAKE-STYLE!
; QUESTION: SHOULD THIS REALLY "STOP" AT THE FIRST NEGATION...
; OR SHOULD IT ENTIRELY RE-ORDER THE KNOWLEDGE DUE TO TRIANGLES?)

; So far, it is stopping at the first negation, with the idea that
; contradictory knowledge may co-exist and knowledge may be infinite,
; but what really matters is whether a set of knowledge "matters"
; "in this moment" - where the moment is limited to the span of
; knowledge that is free of contradictions.
; (define (proto-re-eval firstpair listofallatoms congruentpairs counter)
;   (if (notlongenough listofallatoms)
;     (cons counter (cons firstpair (append (reverse congruentpairs) listofallatoms)))
;     (let ((evaltri (eval-triangle firstpair listofallatoms)))
;       (if (equal? #f (car evaltri)) ; we hit a wrong combination - output the transformed list so far
;         (cons (- counter 1) (cons firstpair (append (reverse congruentpairs) (reverse (cdr (reverse (cdr evaltri)))))))
;         (if (null? (car evaltri)) ; we hit an inconclusive combination
;           (cons counter (cons firstpair (append (reverse congruentpairs) (cddr evaltri))))
;           (proto-re-eval firstpair (cddddr evaltri) (cons (cadddr evaltri) (cons (caddr evaltri) congruentpairs)) (+ 1 counter)))))))

; (define (re-eval firstpair listofallatoms) (reverse (cdr (reverse (proto-re-eval firstpair listofallatoms '() 1))))) ; "1" means minimum 0 in the result.

; OPERATION SNOWFLAKE:
; As an improvement to the above version, not only a term is evaluated,
; but also each of the participants in its triangulations is evaluated.
; I.e., each of the two other sides now tries to reach further
; conclusions. - That means that inheritance of conclusions is possible
; even if not directly driven by input. (That might be too far-reaching
; and too "fanciful", which is why the old version above is kept for
; reference.) - I am calling this figure a "snowflake" as further
; triangles may thus emerge from the sides of triangles.

; MAYBE I SHOULD ENABLE THE FUNCTION TO DO FURTHER RECURSION -
; CONCLUSIONS OF CONCLUSIONS OF CONCLUSIONS OF CONCLUSIONS...
; THAT WOULD INCREASE "CREATIVITY". 

(define (proto1-re-eval firstpair listofallatoms congruentpairs counter)
  (if (notlongenough listofallatoms)
    congruentpairs ; this line is - it delivers which congruent pairs to re-evaluate.
    (let ((evaltri (eval-triangle firstpair listofallatoms)))
      (if (equal? #f (car evaltri)) ; we hit a wrong combination - output the transformed list so far
        congruentpairs
        (if (null? (car evaltri)) ; we hit an inconclusive combination
          congruentpairs
          (proto1-re-eval firstpair (cddddr evaltri) (cons (cadddr evaltri) (cons (caddr evaltri) congruentpairs)) (+ 1 counter)))))))

; the previous version of the below function:
; (define (proto2-re-eval firstpair listofallatoms congruentpairs counter)
;   (if (notlongenough listofallatoms)
;     (cons counter (cons firstpair (append (reverse congruentpairs) listofallatoms)))
;     (let ((evaltri (eval-triangle firstpair listofallatoms)))
;       (if (equal? #f (car evaltri)) ; we hit a wrong combination - output the transformed list so far
;         (cons (- counter 1) (cons firstpair (append (reverse congruentpairs) (reverse (cdr (reverse (cdr evaltri)))))))
;         (if (null? (car evaltri)) ; we hit an inconclusive combination
;           (cons counter (cons firstpair (append (reverse congruentpairs) (cddr evaltri))))
;           (proto2-re-eval firstpair (cddddr evaltri) (cons (cadddr evaltri) (cons (caddr evaltri) congruentpairs)) (+ 1 counter)))))))

; Deriving conclusions has the positive effect of extending consistent
; knowledge - but it also has the negative effect of displacing old
; knowledge into forgetting. - This second effect becomes problematic
; if very many conclusions are reached, and therefore, the below
; function terminates reasoning if the "global limit" of conclusions
; has been reached. (If that number is negative, there is no limit.)
; The global limit of conclusions not only limits the conclusions of a
; given couple of atoms, it also limits how many "consequential"
; evaluations may be undertaken, namely globallimit^N, where currently
; N=2. (The initial pair triggering N conclusions, and each of these
; triggering further N conclusions.)

; THUNK: GLOBAL LIMIT ENABLED IN THE SECOND LINE. Otherwise exactly the same as above.
(define (proto2-re-eval firstpair listofallatoms congruentpairs counter)
  (if (or (zero? globallimit) (notlongenough listofallatoms))
    (cons counter (cons firstpair (append (reverse congruentpairs) listofallatoms)))
    (let ((evaltri (eval-triangle firstpair listofallatoms)))
      (if (equal? #f (car evaltri)) ; we hit a wrong combination - output the transformed list so far
        (cons (- counter 1) (cons firstpair (append (reverse congruentpairs) (reverse (cdr (reverse (cdr evaltri)))))))
        (if (null? (car evaltri)) ; we hit an inconclusive combination
          (cons counter (cons firstpair (append (reverse congruentpairs) (cddr evaltri))))
          (proto2-re-eval firstpair (cddddr evaltri) (cons (cadddr evaltri) (cons (caddr evaltri) congruentpairs)) (+ 1 counter)))))))

; the congruent pairs are delivered in a back-to-front way:
(define (proto3-re-eval firstpair congruentpairs counter listofallatoms)
  (if (null? congruentpairs)
    (reverse (cdr (reverse (proto2-re-eval firstpair listofallatoms '() counter)))) ; (cons counter listofallatoms)
    (let ((reeval (reverse (cdr (reverse (proto2-re-eval (car congruentpairs) listofallatoms '() counter))))))
      (proto3-re-eval firstpair (cdr congruentpairs) (+ counter (car reeval)) (cdr reeval))))) ; making this not reverse cdr reverse reeval keeps the length.

; Basically, the idea is that not a single pair is re-evaluated, but
; all pairs that single pair generates. For this, first the congruent
; pairs are established in in proto1-re-eval. Then proto3-re-eval is
; feeding each of these pairs to the original list of all atoms (i.e.
; not the evaluated one in proto1-re-eval) by means of proto2-re-eval.
; When done, it spits out the last evaluation.

; Old version, just once following the conclusions - can be enabled any
; time instead of the other functions:
; (define (re-eval firstpair listofallatoms)
;   (let ((re-ev (proto1-re-eval firstpair listofallatoms '() 1))) ; "1" means minimum 0 in the result.
;     (proto3-re-eval firstpair re-ev 1 listofallatoms)))

; Erasedup is an UGLY KLUDGE that should be eliminated in order to get
; the below functions to work (not needed for try 4):
(define (proto-erasedup somelist resultlist)
  (if (null? somelist) (reverse resultlist)
    (if (or (and (list? (car somelist))
                 (not (member (car somelist) resultlist))
                 (not (member (reverse (car somelist)) resultlist)))
            (and (pair (car somelist))
                 (not (member (car somelist) resultlist))))
      (proto-erasedup (cdr somelist) (cons (car somelist) resultlist))
        (proto-erasedup (cdr somelist) resultlist))))

(define (erasedup somelist) (proto-erasedup somelist '()))

; THERE WAS A BUG IN THE TRIANGULATOR ITSELF - CORRECTED NOW.
; IT WAS NOT RECOGNISING ANA-ATOMS. - THAT MAY HAVE BEEN THE REASON
; FOR THE DUPLICATES. 

; try 1: DELETED. That completely failed on the nihil.nihil-pairs.

; try 2: AFTER REPAIR IT SEEMS THIS ONE WOULD HAVE WORKED, TOO
; This function applies proto1-re-eval on each of a list of
; conclusions, repetitions ARE possible - and ACCEPTED, as they mean
; "re-thinking" a topic of interest:
; (define (build-conclusions-list listofconclusions listofallatoms resultlist)
;   (if (null? listofconclusions) (cdr resultlist)
;     (build-conclusions-list (cdr listofconclusions) listofallatoms
;       (append resultlist (proto1-re-eval (car listofconclusions) listofallatoms '() 1)))))

; (define (proto-get-conclusions snowdepth listofallatoms resultconclusions)
;   (if (zero? snowdepth) resultconclusions
;     (let ((build-conc (build-conclusions-list resultconclusions listofallatoms '())))
;       (if (null? build-conc) ; then you are unable to re-reason and you may terminate faster
;         resultconclusions ; otherwise, continue searching conclusions:
;         (proto-get-conclusions (- snowdepth 1) listofallatoms (append resultconclusions build-conc))))))

; (define (get-conclusions firstpair listofallatoms)
;   (proto-get-conclusions snow-depth listofallatoms (list firstpair)))

; (define (re-eval firstpair listofallatoms)
;   (let ((re-ev (erasedup (get-conclusions firstpair listofallatoms)))) ; "1" means minimum 0 in the result.
;     (proto3-re-eval firstpair re-ev 1 listofallatoms)))

; try 3: THIS HAS THE SAME (CDR RESULTLIST)-PROBLEM BELOW AS TRY 4 HAD IT.
; (define (build-conclusions-list listofconclusions listofallatoms resultlist)
;   (if (null? listofconclusions) (cdr resultlist)
;     (build-conclusions-list (cdr listofconclusions) listofallatoms
;       (append resultlist (proto1-re-eval (car listofconclusions) listofallatoms '() 1)))))

; (define (proto-get-conclusions snowdepth listofallatoms resultconclusions)
;   (if (zero? snowdepth) resultconclusions
;     (let ((build-conc (build-conclusions-list resultconclusions listofallatoms '())))
;       (if (null? build-conc) ; then you are unable to re-reason and you may terminate faster
;         resultconclusions ; otherwise, continue searching conclusions:
;         (proto-get-conclusions (- snowdepth 1) listofallatoms (append resultconclusions build-conc))))))

; (define (get-conclusions firstpair listofallatoms)
;   (cdr (erasedup (proto-get-conclusions snow-depth listofallatoms (list firstpair)))))
; the cdr above is needed to remove the first pair, which apparently is the culprint for the doubles.

; (define (re-eval firstpair listofallatoms)
;   (let ((re-ev (get-conclusions firstpair listofallatoms))) ; "1" means minimum 0 in the result.
;     (begin (display "re-ev: ") (display re-ev) (display #\newline)
;     (proto3-re-eval firstpair re-ev 1 listofallatoms))))

; try 4: THE CULPRIT FOR THE DOUBLES IS APPARENTLY THE FIRST PAIR
; ATTACHED ON THE FRONT IN re-ev IN re-eval - cdr-ed it away, works!
(define (build-conclusions-list listofconclusions listofallatoms resultlist)
  (if (null? listofconclusions) ; the previous variant "(cdr resultlist)"
    (if (not (null? resultlist)) (cdr resultlist) '()) ; caused an error on an empty list
    (build-conclusions-list (cdr listofconclusions) listofallatoms
      (append resultlist (proto1-re-eval (car listofconclusions) listofallatoms '() 1)))))

(define (proto-get-conclusions snowdepth listofallatoms resultconclusions)
  (if (zero? snowdepth) resultconclusions
    (let ((build-conc (build-conclusions-list resultconclusions listofallatoms '())))
      (if (null? build-conc) ; then you are unable to re-reason and you may terminate faster
        resultconclusions ; otherwise, continue searching conclusions:
        (proto-get-conclusions (- snowdepth 1) listofallatoms (append resultconclusions build-conc))))))

(define (get-conclusions firstpair listofallatoms)
  (proto-get-conclusions snow-depth listofallatoms (list firstpair)))

; (define (proto-eraseelement element somelist resultlist)
;   (if (null? somelist) (reverse resultlist)
;     (if (or (equal? element (car somelist)) (and (list? element) (equal? (reverse element) (car somelist))))
;       (append (reverse resultlist) (cdr somelist))
;       (proto-eraseelement element (cdr somelist) (cons (car somelist) resultlist)))))

; (define (eraseelement element somelist) (proto-eraseelement element somelist '()))

; (define (re-eval firstpair listofallatoms)
;   (let ((re-ev (get-conclusions firstpair listofallatoms))) ; "1" means minimum 0 in the result.
;     (begin (display "re-ev: ") (display re-ev) (display #\newline)
;     (proto3-re-eval firstpair (eraseelement firstpair re-ev) 1 listofallatoms))))


(define (re-eval firstpair listofallatoms)
  (let ((re-ev (get-conclusions firstpair listofallatoms))) ; "1" means minimum 0 in the result.
;     (begin (display "re-ev: ") (display re-ev) (display #\newline)
        ; THIS CAN BE REPLACED:
    (proto3-re-eval firstpair (cdr (erasedup re-ev)) 1 listofallatoms)))
;       EXTREME DEPTH CAN BE GAINED IF NOT USING ERASEDUP, BUT THE
;       CONCLUSIONS COUNT RISES AWFULLY - FROM 126 TO 274953538178:
;       (proto3-re-eval firstpair (cdr re-ev) 1 listofallatoms)))
; )
; extreme depth could not be observed here as in victriexpB20140530.scm

; As a matter of fact, I prefer the old version above,
; together with resliding of long enough history.

; Rather than a global limit, the above function could contain a local
; limit - I do not _need_ to supply the _entire_ re-eval to
; proto3-re-eval, I could limit it to its first M conclusions.
; M does not have to be the same as N above, it could be e.g. N^2.
; So far, everything is symmetrically regulated by the globallimit.

; sample calls:

; (re-eval '(a . b) '((x . y) (q . r) (b . c) (c . a) (s . t) (b . d) (d . a) (l . m) (n . o) (o . p) (p . q) (q . r)))
; --> (0 (a . b) (x . y) (q . r) (c . a) (s . t) (b . d) (d . a) (l . m) (n . o) (o . p) (p . q) (q . r))

; (re-eval '(a . b) '((x . y) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s)))
; --> (1 (a . b) (x . y) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r))

; (re-eval '(a . b) '((x . y) (b . c) (a . c) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s)))
; --> (2 (a . b) (b . c) (a . c) (x . y) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r))

; (re-eval '(a . b) '((x . y) (b . c) (a . c) (b . d) (a . d) (l . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s)))
; --> (3 (a . b) (b . c) (a . c) (b . d) (a . d) (x . y) (l . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r))

; (re-eval '(a . b) '((x . y) (b . c) (a . c) (b . d) (a . d) (b . e) (e . a) (l . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s)))
; --> (2 (a . b) (b . c) (a . c) (b . d) (a . d) (x . y) (e . a) (l . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s))

; (re-eval '(a . b) '((x . y) (b . c) (a . c) (b . d) (a . d) (b . e) (e . a) (b . f) (f . a) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s)))
; --> (2 (a . b) (b . c) (a . c) (b . d) (a . d) (x . y) (e . a) (b . f) (f . a) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s))

; (re-eval '(a . b) '((x . y) (b . c) (a . c) (b . e) (e . a) (b . f) (f . a) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s)))
; --> (1 (a . b) (b . c) (a . c) (x . y) (e . a) (b . f) (f . a) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s))

; (re-eval '(a . b) '((x . y) (b . e) (e . a) (b . f) (f . a) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s)))
; --> (0 (a . b) (x . y) (e . a) (b . f) (f . a) (q . r) (s . t) (l . m) (n . o) (o . p) (p . q) (q . r) (r . s))

; END OF OPERATION SNOWFLAKE.

; Now - remove all duplicates and say how often you saw any unicate.
; Triangulation should be undertaken on each input unit only once.
; However, triangulation merely shows "confirmed observations" -
; actually, observations may be confirmed also from how often they are seen in input.
(define (proto1-erase-duplicates unicate listofpairs counter resultlist)
  (if (null? listofpairs) (cons (cons counter unicate) (reverse resultlist))
    (if (equal? unicate (car listofpairs))
      (proto1-erase-duplicates unicate (cdr listofpairs) (+ 1 counter) resultlist)
      (proto1-erase-duplicates unicate (cdr listofpairs) counter (cons (car listofpairs) resultlist)))))

(define (proto2-erase-duplicates listofunicates listofpairs resultlist)
  (if (null? listofunicates) (reverse resultlist)
    (let ((proto1 (proto1-erase-duplicates (car listofunicates) listofpairs 0 '())))
    (proto2-erase-duplicates (cdr proto1) (cdr proto1)
      (cons (car proto1) resultlist)))))

(define (erase-duplicates listofpairs) (proto2-erase-duplicates listofpairs listofpairs '()))

; sample call:
; (erase-duplicates '((a . b) (a . b) (b . c) (c . d) (a . b) (c . d)))
; --> ((3 a . b) (1 b . c) (2 c . d))
; I could now MULTIPLY that with triangulation results...
; or I could merely ADD it, and ADDING IT would be more interesting if
; the results could be NEGATIVE. But NEGATIVE results would only
; signify ABSOLUTE KNOWLEDGE rather than ATTENTION.

(define (proto-compare-tri pairs listofallatoms bestresult)
  (if (null? pairs) bestresult
    (let ((intermediate (re-eval (cdar pairs) listofallatoms)))
      (if (>= (+ (caar pairs) (car intermediate)) (car bestresult))
        (proto-compare-tri (cdr pairs) listofallatoms
          (cons (+ (caar pairs) (car intermediate)) (cdr intermediate)))
        (proto-compare-tri (cdr pairs) listofallatoms bestresult)))))

(define (compare-tri inputlist listofallatoms)
  (proto-compare-tri (erase-duplicates (mapcons inputlist)) listofallatoms '(-1 ())))
; sample calls:

; (compare-tri '(a b c a b d a b e)
; '((f . g) (a . b) (b . x) (g . h) (b . y) (a . y) (b . z) (z . a)
; (b . h) (a . h) (c . i) (c . j) (k . b) (k . c) (l . b) (l . c)
; (m . b) (m . c) (b . i) (b . j)
; ; (c . a) is unknown
; (d . b)
; (e . n) (n . b)))

; --> (5 (a . b) (b . x) (a . x) (b . y) (a . y) (f . g) (g . h)
; (z . a) (b . h) (a . h) (c . i) (c . j) (k . b) (k . c) (l . b)
; (l . c) (m . b) (m . c) (b . i) (b . j) (d . b) (e . n) (n . b))

; (compare-tri '(a b c a b d a b e)
; '((f . g) (a . b) (b . x) (g . h) (b . y) (a . y) (b . z) (z . a)
; (b . h) (a . h) (c . b) (c . i) (c . j)
; (a . c) ; it tend to conclude
; (a . d) ; each of these three's antitheses if they are not
; (d . b) ; specified, because they are later than "(a . b)"
; (e . n) (n . b)))

; --> (5 (a . b) (b . x) (a . x) (b . y) (a . y) (f . g) (g . h)
; (z . a) (b . h) (a . h) (c . b) (c . i) (c . j) (a . c) (a . d)
; (d . b) (e . n) (n . b))

; Now, the foundation of hierarchisation has to be defined. I.e. that
; the system re-considers input, each time combining another pair.

; IN THE PRESENT DESIGN, HIERARCHISATION ALWAYS CONTINUES "TO THE TOP"
; AND DELIVERS "ONE" CONNECTION AS THE ANSWER. - THIS HAPPENS ON EACH
; RE-HIERARCHISATION, TOO. - That might be re-considered as it is
; wasteful of atoms, but on the positive side, it creates a lot of
; variations of one and the same input that can be used in further
; reasoning and thus aids the creation of "areas of knowledge".

; (define (hierarchise-input chosen pairs)
; (map car (map (lambda (x) (if (equal? x chosen) (list x) x)) pairs)))
; (hierarchise-input '(a . b) '((a . b) (b . c) (c . a) (a . b) (b . c) (c . a))
; --> ((a . b) b c (a . b) b c) ; catch: I must get rid of the "b"-s
; I could do this with mapcons, compare, then map car... blah.
; Let's do it "normally", instead.

(define (proto-hierarchise chosen carinputlist inputlist resultlist)
  (if (null? inputlist) (reverse resultlist)
    (if (equal? chosen (cons carinputlist (car inputlist)))
      (proto-hierarchise chosen (car inputlist) (cdr inputlist) (cons chosen (cdr resultlist)))
      (proto-hierarchise chosen (car inputlist) (cdr inputlist) (cons (car inputlist) resultlist)))))

(define (hierarchise chosen inputlist)
  (if (null? inputlist) '()
    (proto-hierarchise chosen (car inputlist) (cdr inputlist) (list (car inputlist)))))

; (hierarchise '(a . b) '(a b c d a b c d a b))
; --> ((a . b) c d (a . b) c d (a . b))
; (hierarchise '((a . b) . c) (hierarchise '(a . b) '(a b c d a b c d a b)))
; --> (((a . b) . c) d ((a . b) . c) d (a . b))
; (hierarchise '(b . c) '(a b c a b d a b e o))
; --> (a (b . c) a b d a b e o)

; The above function is used in the tri-hier function defined below.

; If input is re-hierarchised after being only partially shifted, i.e.
; if input history is partially "re-considered", that creates multiple
; hierarchisation peaks and contributes to "areas of knowledge" as well
; as giving the system "multiple points of view" on the same "matter".

; ======== THIS MODIFICATION TO SPLITFUSE CAN WORK WITH ANALOGIES ========

; The next function is where a plan is prepared for output. Its
; hierarchy is flattened and the list of sub-atoms constitutes the
; answer. - This function is later used in planning.

; OLD VERSION:
; with hard "pair":
; (define (proto-splitfuse pairtree resultlist)
;   (if (not (pair pairtree)) (reverse (cons pairtree resultlist))
;     (if (not (pair (car pairtree)))
;       (proto-splitfuse (cdr pairtree) (cons (car pairtree) resultlist))
;       (proto-splitfuse (cons (caar pairtree) (cons (cdar pairtree) (cdr pairtree))) resultlist))))
; sample calls:
; (proto-splitfuse '(((a (b . c) d . e) . f) g . h) '()) --> (a b c d e f g h)   
; (proto-splitfuse '(a . b) '()) --> (a b)
; (proto-splitfuse 'a '()) --> (a)

; EXTRA FOR HANDLING ANALOGIES:
; CAN BE ELIMINATED IF THE OLD SPLITFUSE IS TO BE USED.

; NEW VERSION FOR THE ANA-TOLERANCE:
; pair? instead of pair:
(define (proto-splitfuse pairtree resultlist)
  (if (not (pair? pairtree)) (reverse (cons pairtree resultlist))
    (if (not (pair? (car pairtree)))
      (proto-splitfuse (cdr pairtree) (cons (car pairtree) resultlist))
      (proto-splitfuse (cons (caar pairtree) (cons (cdar pairtree) (cdr pairtree))) resultlist))))

(define (elimnil somelist resultlist)
  (if (null? somelist) resultlist
    (if (equal? '() (car somelist))
      (elimnil (cddr somelist) resultlist)
      (elimnil (cdr somelist) (cons (car somelist) resultlist)))))

; OLD SPLITFUSE FUNCTION:
; (define (splitfuse pairtree) (proto-splitfuse pairtree '()))
; NEW SPLITFUSE FUNCTION:
(define (splitfuse pairtree) (elimnil (reverse (proto-splitfuse pairtree '())) '()))
; sample calls - first pure vic, second with anas:
; (splitfuse '(((a (b . c) d . e) . f) g . h)) --> (A B C D E F G H)
; (splitfuse '(((a (b c) d e) . f) g . h)) --> (A B D F G H)

; The next function tries to find a plan as the continuation of the
; present. If the hierarchy has no right neighbour, it is decomposed.
; Then again it is checked whether the right-most part has a right
; neighbour in the list of all atoms, until such right neighbour is
; found - it is this right neighbour that consititutes the plan:

(define (proto-findplan initialpair listofallatoms original-listofallatoms)
  (if (and (null? listofallatoms) (pair initialpair))
    (proto-findplan (cdr initialpair) original-listofallatoms original-listofallatoms)
    (if (null? listofallatoms) '()
      (if (and (pair (car listofallatoms))
          (or (and (pair initialpair) (equal? (cdr initialpair) (caar listofallatoms)))
              (equal? initialpair (caar listofallatoms))))
        (splitfuse (cdar listofallatoms))
        (proto-findplan initialpair (cdr listofallatoms) original-listofallatoms)))))

(define (findplan initialpair listofallatoms) (proto-findplan initialpair listofallatoms listofallatoms))
; sample calls:
; (findplan '(x . a) '((r . s) (s . t) (t . u) (u . a) (a . v) (a . w) (u . v))) --> (v)
; (findplan '(y x . a) '((r . s) (s . t) (t . u) (u . a) (a v . w) (a . w) (u . v))) --> (v w)

; debugging version, delivering not a plan, but the problematic
; listofallatoms:
; (define (tri-hier inputlist listofallatoms)
; (begin (display "inputlist: ") (display inputlist) (display #\newline) (display #\newline)
;        (display "listofallatoms: ") (display listofallatoms) (display #\newline)
;        (display "length of listofallatoms: ") (display (length listofallatoms)) (display #\newline) (display #\newline)
;   (if (equal? 1 (length inputlist)) (findplan inputlist listofallatoms) ; (cons inputlist listofallatoms)
;     (let ((tri-knowledge (compare-tri inputlist listofallatoms)))
;       (tri-hier (hierarchise (cadr tri-knowledge) inputlist) (cdr tri-knowledge))))))

; Now it is time to "triangulate and hierarchise", i.e. combining
; the previous functions into a challenge-response package. The answer
; of that function contains both the string of the plan and a changed
; version of the list of all atoms (changes according to reasoning).

(define (tri-hier inputlist listofallatoms)
  (if (equal? 1 (length inputlist)) (cons (findplan (car inputlist) listofallatoms) listofallatoms) ; inputlist
    (let ((tri-knowledge (compare-tri inputlist listofallatoms)))
      (tri-hier (hierarchise (cadr tri-knowledge) inputlist) (cdr tri-knowledge)))))

; sample call:
; (tri-hier '(a b c a b e) '((e n o p . q) (f . g)
; (a . b) (b . x) (g . h) (b . y) (a . y) (b . z) (z . a)
; (b . h) (a . h) (c . i) (c . j) (k . b) (k . c) (l . b)
; (l . c) (m . b) (m . c) (b . i) (b . j) (d . b) (n . b)))
; --> ((n o p q) ((a . b) c (a . b) . e) ((a . b) . e) (c (a . b) . e)
; (c . i) (e n o p . q) (a . b) (b . x) (a . x) (b . y) (a . y) (f . g)
; (g . h) (z . a) (b . h) (a . h) (c . j) (k . b) (k . c) (l . b)
; (l . c) (m . b) (m . c) (b . i))

; HYPOTHESIS: MY PROBLEMS WERE DUE TO THE FACT THAT THE TRIANGULATOR FUNCTION "KEEPS CONSTAND LENGHT", RATHER THAN "INCREASING LENGTH BY 1"!
; HYPOTHESIS CONFIRMED, PROBLEMS CORRECTED.

; ---- EXPERIMENTAL STAGE: MAKE IT "LEARN A TEXT", THEN TALK ABOUT IT!

; define a global list of all atoms, "empty" for now
(define (proto-protolist x resultlist)
  (if (zero? x) resultlist ; no need to reverse, it is nonsense anyway
    (proto-protolist (- x 1) (cons '(nihil . nihil) resultlist))))

; THUNK: The below function defines the list of all atoms according to
; the globally set variable knowledgesize.
; (define protolist (proto-protolist 65000 '())) ; a first experiment with 65k atoms.

(define protolist (proto-protolist knowledgesize '()))

; This is where you require the "filling" of the knowledge base before
; even "elementary" teaching;
; this also determines the length of the list of all atoms.

; For interactive input, always the last N atoms will be reasoned on:
(define (proto-takelastn counter somelist resultlist)
  (if (or (zero? counter) (null? somelist)) resultlist
    (proto-takelastn (- counter 1) (cdr somelist) (cons (car somelist) resultlist))))

; OPERATION SLEDGE:

; It is possible that repeated hierarchisations uncover formerly
; unknown combination possibilities - this is why the input should be
; re-considered to a certain history length, and moreover, each chunk
; of history should be considered several times. This is implemented
; below. takelastn determines how much of the history is to be re-
; considered while re-slider defines the re-consideration of history.

(define (takelastn counter somelist) (proto-takelastn counter (reverse somelist) '()))
; sample call:
; (takelastn 3 '(a b c d e f)) --> (d e f)

(define (re-slider howoften inputlist listofallatoms)
  (if (zero? howoften) (tri-hier inputlist listofallatoms)
    (re-slider (- howoften 1) inputlist (cdr (tri-hier inputlist listofallatoms)))))

; END OF OPERATION SLEDGE.

; This function is used to "learn" an input list - without generating
; a reply, i.e. only the list of all atoms is changed. This is used
; for pre-setting knowledge into the system.

(define (learn inputlist listofallatoms)
  (if (equal? 1 (length inputlist)) listofallatoms ; (cons (findplan (car inputlist) listofallatoms) listofallatoms)
    (let ((tri-knowledge (compare-tri inputlist listofallatoms)))
      (learn (hierarchise (cadr tri-knowledge) inputlist) (cdr tri-knowledge)))))

(define (recursivelearn listofinputlists listofallatoms)
  (if (null? listofinputlists) (set! mainlist listofallatoms)
    (recursivelearn (cdr listofinputlists) (learn (car listofinputlists) listofallatoms))))

; This is where the actual pre-learning takes place:
; (recursivelearn initlist protolist)
; (set! rootlist '()) ; free memory of the rootlist after pre-learning.

; make sure the history of past input is within limits:
(define (proto-takefirstn counter x resultlist)
  (if (or (zero? counter) (null? x)) (reverse resultlist)
    (proto-takefirstn (- counter 1) (cdr x) (cons (car x) resultlist))))

(define (takefirstn howmany x) (proto-takefirstn howmany x '()))
; sample call:
; (takefirstn 3 '(a b c d e f)) --> (a b c)
; (takefirstn 3 '(a b)) --> (a b)

; this function tests whether each element of the first list
; can be found in the second list. I shall use this to
; determine whether the machine is able to be used for a specific
; input or whether such input would be unknown to it.
(define (allinsecond firstlist secondlist)
  (if (null? firstlist) #t
    (if (equal? #f (member (car firstlist) secondlist)) #f
      (allinsecond (cdr firstlist) secondlist))))
; sample calls:
; (allinsecond '(a b a c a) '(a b c)) --> #t
; (allinsecond '(a b x c a) '(a b c)) --> #f

; THIS IS A THUNK.
; It updates the past input history for future calls.
(define (mergehistory newinput knownhistory)
  (takefirstn historylength (append newinput knownhistory)))

(define (shallitrun readinsist newinput knownhistory)
  (if (equal? readinsist '(DORUN)) #t
    (allinsecond newinput knownhistory)))

; The below functions handle batch interaction of the system.
(define mainlist '())
(define maininput '())
(define inputhistory '())
(define insistence '())

; The list of input is placed into swarminput.txt,
; the list of all atoms should be in swarmdata.txt,
; and the answer is to be received in swarmoutput.txt.
; swarminsistence tries to find out whether reasoning
; should take place "anyway" (otherwise it will only
; take place if the input can be found in the history)
; for this, insistence must be set to "(DORUN)".
; It is the OS' responsibility to clean up the insistence,
; clean up the input, and handle and clean up the output.
(define main
  (let ((swarmdata (open-input-file "swarmdata.txt"))
        (swarminput (open-input-file "swarminput.txt"))
        (swarminsistence (open-input-file "swarminsistence.txt"))
        (swarmhistory (open-input-file "swarmhistory.txt")))
    (begin
      (set! mainlist (read swarmdata)) (close-input-port swarmdata)
      (set! maininput (takelastn inmemory (read swarminput))) (close-input-port swarminput)
      (set! insistence (read swarminsistence)) (close-input-port swarminsistence)
      (set! inputhistory (read swarmhistory)) (close-input-port swarmhistory)
      (if (equal? #f (shallitrun insistence maininput inputhistory)) '() ; "then do nothing", else:
        (let ((trihier (re-slider re-slide-count maininput mainlist))
              (swarmupdate (open-output-file "swarmdata.txt"))
              (swarmoutput (open-output-file "swarmoutput.txt"))
              (swarmnewhist (open-output-file "swarmhistory.txt")))
          (begin
            (display (cdr trihier) swarmupdate) (close-output-port swarmupdate)
            (display (car trihier) swarmoutput) (close-output-port swarmoutput)
            (display (mergehistory maininput inputhistory) swarmnewhist) (close-output-port swarmnewhist)))))))

; fire up the whole exchange:
main

; TO SUM IT UP:
; THE SYSTEM WILL FIRE IF THE INPUT LIST'S ELEMENTAS ARE ALL KNOWN,
; OTHERWISE IT WILL NOT FIRE. THIS CAN BE OVERRIDDEN BY PLACING
; "(DORUN)" IN swarminsistence.txt - THEN THE SYSTEM ALSO RUNS IF THE
; INPUT LIST'S ELEMENTS ARE NOT ALL KNOWN. (OBVIOUSLY, IT THEN CREATES
; NEW ELEMENTS AND COULD RUN ON THAT SAME INPUT AGAIN, EVEN WITHOUT
; (DORUN), BECAUSE NOW IT BECOMES KNOWN INPUT).

; HAHA, THIS LINE IS 1337. :)
