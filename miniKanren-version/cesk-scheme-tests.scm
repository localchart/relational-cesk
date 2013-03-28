#!/usr/bin/env scheme-script
(import (rnrs)
        (mk-lib)
        (lookupo-lib)
        (test-check-lib)
        (cesk-scheme)
        (rename (cesk-scheme-simple-dummy-v-out) (evalo evalo-simple) (eval-expo eval-expo-simple) (empty-env empty-env-simple) (empty-store empty-store-simple) (empty-k empty-k-simple)))

;;; datastructures based on higher-order functions

;;; mutable cell

(test "cell-guess-paper-1"
  (run 1 (q)
    (fresh (code-bang code-get code-bang-part)
      (absento 4 code-bang)
      (absento 4 code-get)
      (== code-bang `(lambda (new-value) ,code-bang-part))
      (== code-get `(lambda (dummy) value))
      (evalo
        `((lambda (make-cell)
            ((lambda (c1)
               (c1 (lambda (bang) (lambda (get) ((lambda (ignore) (get c1)) (bang (quote 4)))))))
              (make-cell (quote 3))))
           (lambda (value)
             (((lambda (bang)
                 (lambda (get)
                   (lambda (f)
                     ((f bang) get))))
                ,code-bang)
               ,code-get)))
        '4)
      (== q `(,code-bang ,code-get))))
  '(((lambda (new-value) (set! value new-value))
      (lambda (dummy) value))))

(test "cell-get-1"
  (run* (q)
    (evalo
      '((lambda (make-cell)
          ((lambda (c1) ((c1 (lambda (bang) (lambda (get) get))) c1))
            (make-cell (quote 3))))
         (lambda (value)
           (((lambda (bang)
               (lambda (get)
                 (lambda (f)
                   ((f bang) get))))
              (lambda (new-value) (set! value new-value)))
             (lambda (dummy) value))))
      q))
  '(3))

(test "cell-get-2"
  (run* (q)
    (evalo
      '((lambda (make-cell)
          ((lambda (c1) (c1 (lambda (bang) (lambda (get) (get c1)))))
            (make-cell (quote 3))))
         (lambda (value)
           (((lambda (bang)
               (lambda (get)
                 (lambda (f)
                   ((f bang) get))))
              (lambda (new-value) (set! value new-value)))
             (lambda (dummy) value))))
      q))
  '(3))

(test "cell-set-1"
  (run* (q)
    (evalo
      '((lambda (make-cell)
          ((lambda (c1)
             (c1 (lambda (bang) (lambda (get) ((lambda (ignore) (get c1)) (bang (quote 4)))))))
            (make-cell (quote 3))))
         (lambda (value)
           (((lambda (bang)
               (lambda (get)
                 (lambda (f)
                   ((f bang) get))))
              (lambda (new-value) (set! value new-value)))
             (lambda (dummy) value))))
      q))
  '(4))

(test "cell-guess-1"
  (run 1 (q)
    (fresh (code-bang code-get)
      (absento 4 code-bang)
      (absento 4 code-get)
      (== code-bang '(lambda (new-value) (set! value new-value)))
      (== code-get '(lambda (dummy) value))
      (evalo
        `((lambda (make-cell)
            ((lambda (c1)
               (c1 (lambda (bang) (lambda (get) ((lambda (ignore) (get c1)) (bang (quote 4)))))))
              (make-cell (quote 3))))
           (lambda (value)
             (((lambda (bang)
                 (lambda (get)
                   (lambda (f)
                     ((f bang) get))))
                ,code-bang)
               ,code-get)))
        '4)
      (== q `(,code-bang ,code-get))))
  '(((lambda (new-value) (set! value new-value))
     (lambda (dummy) value))))

(test "cell-guess-2"
  (run 1 (q)
    (fresh (code-bang code-get code-bang-part)
      (absento 4 code-bang)
      (absento 4 code-get)
      (== code-bang `(lambda (new-value) (set! value ,code-bang-part)))
      (== code-get '(lambda (dummy) value))
      (evalo
        `((lambda (make-cell)
            ((lambda (c1)
               (c1 (lambda (bang) (lambda (get) ((lambda (ignore) (get c1)) (bang (quote 4)))))))
              (make-cell (quote 3))))
           (lambda (value)
             (((lambda (bang)
                 (lambda (get)
                   (lambda (f)
                     ((f bang) get))))
                ,code-bang)
               ,code-get)))
        '4)
      (== q `(,code-bang ,code-get))))
  '(((lambda (new-value) (set! value new-value))
     (lambda (dummy) value))))

(test "cell-guess-3"
  (run 1 (q)
    (fresh (code-bang code-get code-bang-part code-get-part)
      (absento 4 code-bang)
      (absento 4 code-get)
      (== code-bang `(lambda (new-value) (set! value ,code-bang-part)))
      (== code-get `(lambda (dummy) ,code-get-part))
      (evalo
        `((lambda (make-cell)
            ((lambda (c1)
               (c1 (lambda (bang) (lambda (get) ((lambda (ignore) (get c1)) (bang (quote 4)))))))
              (make-cell (quote 3))))
           (lambda (value)
             (((lambda (bang)
                 (lambda (get)
                   (lambda (f)
                     ((f bang) get))))
                ,code-bang)
               ,code-get)))
        '4)
      (== q `(,code-bang ,code-get))))
  '(((lambda (new-value) (set! value new-value))
     (lambda (dummy) value))))

(test "cell-guess-4"
  (run 1 (q)
    (fresh (code-bang code-get code-bang-part)
      (absento 4 code-bang)
      (absento 4 code-get)
      (absento 'throw code-bang)
      (== code-bang `(lambda (new-value) ,code-bang-part))
      (== code-get `(lambda (dummy) value))
      (evalo
        `((lambda (make-cell)
            ((lambda (c1)
               (c1 (lambda (bang) (lambda (get) ((lambda (ignore) (get c1)) (bang (quote 4)))))))
              (make-cell (quote 3))))
           (lambda (value)
             (((lambda (bang)
                 (lambda (get)
                   (lambda (f)
                     ((f bang) get))))
                ,code-bang)
               ,code-get)))
        '4)
      (== q `(,code-bang ,code-get))))
  '(((lambda (new-value) (set! value new-value))
     (lambda (dummy) value))))

(test "cell-guess-5"
  (run 1 (q)
    (fresh (code-bang code-get code-bang-part code-get-part)
      (absento 4 code-bang)
      (absento 4 code-get)
      (== code-bang `(lambda (new-value) (set! . ,code-bang-part)))
      (== code-get `(lambda (dummy) ,code-get-part))
      (evalo
        `((lambda (make-cell)
            ((lambda (c1)
               (c1 (lambda (bang) (lambda (get) ((lambda (ignore) (get c1)) (bang (quote 4)))))))
              (make-cell (quote 3))))
           (lambda (value)
             (((lambda (bang)
                 (lambda (get)
                   (lambda (f)
                     ((f bang) get))))
                ,code-bang)
               ,code-get)))
        '4)
      (== q `(,code-bang ,code-get))))
  '(((lambda (new-value) (set! value new-value))
      (lambda (dummy) value))))

;;; mutable list

(test "mutable-list-1"
  (run* (q)
    (evalo
      `((lambda (new-list)
          ((lambda (l)
             (l (lambda (freeze) (lambda (set-first!) (lambda (set-second!) (freeze l))))))
            ((new-list (quote first)) (quote second))))
         (lambda (first)
           (lambda (second)
             ((lambda (freeze)
                ((lambda (set-first!)
                   ((lambda (set-second!)
                      (lambda (f)
                        (((f freeze) set-first!) set-second!)))
                     (lambda (new-second) (set! second new-second))))
                  (lambda (new-first) (set! first new-first))))
               (lambda (dummy) (list first second))))))
      q))
  '((first second)))

(test "mutable-list-2"
  (run* (q)
    (evalo
      `((lambda (new-list)
          ((lambda (l)
             (l (lambda (freeze) (lambda (set-first!) (lambda (set-second!)
                                              ((lambda (ignore) (freeze l))
                                               (set-first! (quote coming))))))))
            ((new-list (quote first)) (quote second))))
         (lambda (first)
           (lambda (second)
             ((lambda (freeze)
                ((lambda (set-first!)
                   ((lambda (set-second!)
                      (lambda (f)
                        (((f freeze) set-first!) set-second!)))
                     (lambda (new-second) (set! second new-second))))
                  (lambda (new-first) (set! first new-first))))
               (lambda (dummy) (list first second))))))
      q))
  '((coming second)))

(test "mutable-list-3"
  (run* (q)
    (evalo
      `((lambda (new-list)
          ((lambda (l)
             (l (lambda (freeze) (lambda (set-first!) (lambda (set-second!)
                                              ((lambda (ignore) (freeze l))
                                                ((lambda (ignore)
                                                   (set-first! (quote hello)))
                                                  (set-second! (quote world)))))))))
            ((new-list (quote first)) (quote second))))
         (lambda (first)
           (lambda (second)
             ((lambda (freeze)
                ((lambda (set-first!)
                   ((lambda (set-second!)
                      (lambda (f)
                        (((f freeze) set-first!) set-second!)))
                     (lambda (new-second) (set! second new-second))))
                  (lambda (new-first) (set! first new-first))))
               (lambda (dummy) (list first second))))))
      q))
  '((hello world)))

(test "mutable-list-4"
  (run* (q)
    (evalo
      `((lambda (new-list)
          ((lambda (l)
             (l (lambda (freeze) (lambda (set-first!) (lambda (set-second!)
                                              ((lambda (ignore) (freeze l))
                                                ((lambda (ignore)
                                                   (set-first! (quote coming)))
                                                  (set-first! (quote ignored)))))))))
            ((new-list (quote first)) (quote second))))
         (lambda (first)
           (lambda (second)
             ((lambda (freeze)
                ((lambda (set-first!)
                   ((lambda (set-second!)
                      (lambda (f)
                        (((f freeze) set-first!) set-second!)))
                     (lambda (new-second) (set! second new-second))))
                  (lambda (new-first) (set! first new-first))))
               (lambda (dummy) (list first second))))))
      q))
  '((coming second)))

(test "cesk-quote-a"
  (run* (q)
    (evalo '(quote x) q))
  '(x))

(test "cesk-quote"
  (run* (q)
    (evalo '(quote (lambda (x) x)) q))
  '((lambda (x) x)))

(test "cesk-list-0"
  (run* (q)
    (evalo '(list) q))
  '(()))

(test "cesk-closure"
  (run* (q)
    (evalo '(lambda (x) x) q))
  '((closure x x (() ()))))

(test "cesk-identity-a"
  (run* (q)
    (evalo '((lambda (x) x) (lambda (y) y)) q))
  '((closure y y (() ()))))

(test "cesk-identity-b"
  (run* (q)
    (evalo '((lambda (x) x) (quote foo)) q))
  '(foo))

(test "cesk-list-1"
  (run* (q)
    (evalo '(list (quote foo)) q))
  '((foo)))

(test "cesk-list-2"
  (run* (q)
    (evalo '(list (quote foo) (quote bar)) q))
  '((foo bar)))

(test "cesk-list-application-1"
  (run* (q)
    (evalo '((lambda (x) (quote bar)) (list (quote foo))) q))
  '(bar))

(test "combined-list-test-1"
  (length
   (run 50 (q)
    (fresh (expr env store k val)
      (== '(list (quote foo)) expr)
      (== empty-env env)
      (== empty-store store)
      (== `(,expr ,env ,store ,k ,val) q)      
      (eval-expo-simple
       expr
       env
       store
       k
       val)
      (condu
        [(eval-expo expr env store k val)]
        [(errorg 'combined-test-1 "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
  50)

(test "combined-test-1"
  (length
   (run 50 (q)
    (fresh (expr env store k val)
      (== `(,expr ,env ,store ,k ,val) q)
      (eval-expo-simple
       expr
       env
       store
       k
       val)
      (condu
        [(eval-expo expr env store k val)]
        [(errorg 'combined-test-1 "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
  50)

(test "combined-test-2"
  (length
   (run 50 (q)
    (fresh (expr env store k val)
      (== `(,expr ,env ,store ,k ,val) q)
      (eval-expo
       expr
       env
       store
       k
       val)
      (condu
        [(eval-expo-simple expr env store k val)]
        [(errorg 'combined-test-2 "eval-expo-simple can't handle state generated by eval-expo:\n\n~s\n\n" q)]))))
  50)

(test "cesk-list-1-backwards"
  (run 3 (q)
    (evalo q '(foo)))
  '('(foo)
    (list 'foo)
    (((lambda (_.0) '(foo)) '_.1)
     (=/= ((_.0 quote)))
     (sym _.0)
     (absento (closure _.1) (void _.1)))))

(test "cesk-list-2-backwards"
  (run 3 (q)
    (fresh (x body)
      (evalo `(lambda (,x) ,body) '(foo))))
  '())

(test "cesk-list-2b"
  (run 5 (q)
    (evalo q '(foo bar)))
  '('(foo bar)
    (list 'foo 'bar)
    (((lambda (_.0) '(foo bar)) '_.1)
     (=/= ((_.0 quote)))
     (sym _.0)
     (absento (closure _.1) (void _.1)))
    (((lambda (_.0) _.0) '(foo bar)) (sym _.0))
    (((lambda (_.0) '(foo bar)) (lambda (_.1) _.2))
     (=/= ((_.0 quote)))
     (sym _.0 _.1))))

(test "cesk-list-3"
  (run* (q)
    (evalo '(list (quote baz)
                  ((lambda (x) x) (list (quote foo) (quote bar)))
                  ((lambda (x) x) (list (quote quux))))
           q))
  '((baz (foo bar) (quux))))

(test "cesk-shadowing"
  (run* (q)
    (evalo '((lambda (x)
               ((lambda (quote)
                  (quote x))
                (lambda (y) (list y y y))))
             (quote bar))
           q))
  '((bar bar bar)))

(test "cesk-nested-lambda"
  (run* (q)
    (evalo '(((lambda (y)
                (lambda (x) y))
              (quote foo))
             (quote bar))
           q))
  '(foo))

(test "cesk-set!-0"
  (run 20 (q)
    (fresh (expr env store k val)
      (eval-expo
       expr
       env
       store
       k
       val)
       (fails-unless-contains env 'set!)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (empty-k) void) (=/= ((_.0 quote)) ((_.0 set!))) (num _.3) (sym _.0) (absento (closure _.1) '_.2 (set! _.2) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.0 . _.3) (_.4 _.5 . _.6)) (_.7 _.8) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!))) (num _.4 _.5) (sym _.0 _.2) (absento (closure _.1) '_.3 (set! _.3) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.0 . _.3) (_.4 . _.5)) (_.6 _.7) (empty-k) void) (=/= ((_.0 lambda)) ((_.0 set!))) (num _.4) (sym _.0 _.1) (absento (lambda _.3) (set! _.3)))
     (((set! _.0 '_.1) ((_.2 _.3 _.0 . _.4) (_.5 _.6 _.7 . _.8)) (_.9 _.10) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!))) (num _.5 _.6 _.7) (sym _.0 _.2 _.3) (absento (closure _.1) '_.4 (set! _.4) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.0 . _.5) (_.6 _.7 _.8 _.9 . _.10)) (_.11 _.12) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!))) (num _.6 _.7 _.8 _.9) (sym _.0 _.2 _.3 _.4) (absento (closure _.1) '_.5 (set! _.5) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.0 . _.4) (_.5 _.6 . _.7)) (_.8 _.9) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!))) (num _.5 _.6) (sym _.0 _.1 _.3) (absento (lambda _.4) (set! _.4)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.0 . _.6) (_.7 _.8 _.9 _.10 _.11 . _.12)) (_.13 _.14) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!))) (num _.10 _.11 _.7 _.8 _.9) (sym _.0 _.2 _.3 _.4 _.5) (absento (closure _.1) '_.6 (set! _.6) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.0 . _.7) (_.8 _.9 _.10 _.11 _.12 _.13 . _.14)) (_.15 _.16) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!))) (num _.10 _.11 _.12 _.13 _.8 _.9) (sym _.0 _.2 _.3 _.4 _.5 _.6) (absento (closure _.1) '_.7 (set! _.7) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.0 . _.5) (_.6 _.7 _.8 . _.9)) (_.10 _.11) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!))) (num _.6 _.7 _.8) (sym _.0 _.1 _.3 _.4) (absento (lambda _.5) (set! _.5)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.0 . _.8) (_.9 _.10 _.11 _.12 _.13 _.14 _.15 . _.16)) (_.17 _.18) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!))) (num _.10 _.11 _.12 _.13 _.14 _.15 _.9) (sym _.0 _.2 _.3 _.4 _.5 _.6 _.7) (absento (closure _.1) '_.8 (set! _.8) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.0 . _.9) (_.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 . _.18)) (_.19 _.20) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!))) (num _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17) (sym _.0 _.2 _.3 _.4 _.5 _.6 _.7 _.8) (absento (closure _.1) '_.9 (set! _.9) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.0 . _.6) (_.7 _.8 _.9 _.10 . _.11)) (_.12 _.13) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!))) (num _.10 _.7 _.8 _.9) (sym _.0 _.1 _.3 _.4 _.5) (absento (lambda _.6) (set! _.6)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.0 . _.10) (_.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 . _.20)) (_.21 _.22) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19) (sym _.0 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.10 (set! _.10) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.0 . _.11) (_.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 . _.22)) (_.23 _.24) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21) (sym _.0 _.10 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.11 (set! _.11) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.0 . _.7) (_.8 _.9 _.10 _.11 _.12 . _.13)) (_.14 _.15) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!))) (num _.10 _.11 _.12 _.8 _.9) (sym _.0 _.1 _.3 _.4 _.5 _.6) (absento (lambda _.7) (set! _.7)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.0 . _.12) (_.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 . _.24)) (_.25 _.26) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23) (sym _.0 _.10 _.11 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.12 (set! _.12) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.0 . _.13) (_.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 . _.26)) (_.27 _.28) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25) (sym _.0 _.10 _.11 _.12 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.13 (set! _.13) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.7 _.0 . _.8) (_.9 _.10 _.11 _.12 _.13 _.14 . _.15)) (_.16 _.17) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!)) ((_.7 lambda)) ((_.7 set!))) (num _.10 _.11 _.12 _.13 _.14 _.9) (sym _.0 _.1 _.3 _.4 _.5 _.6 _.7) (absento (lambda _.8) (set! _.8)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.0 . _.14) (_.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 . _.28)) (_.29 _.30) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27) (sym _.0 _.10 _.11 _.12 _.13 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.14 (set! _.14) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.0 . _.15) (_.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 . _.30)) (_.31 _.32) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.15 (set! _.15) (void _.1)))))

 (test "cesk-set!-1"
   (run 50 (q)
     (fresh (expr env store k val x e)
       (== `(set! ,x ,e) expr)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (empty-k) void) (=/= ((_.0 quote)) ((_.0 set!))) (num _.3) (sym _.0) (absento (closure _.1) '_.2 (set! _.2) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.0 . _.3) (_.4 _.5 . _.6)) (_.7 _.8) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!))) (num _.4 _.5) (sym _.0 _.2) (absento (closure _.1) '_.3 (set! _.3) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.0 . _.3) (_.4 . _.5)) (_.6 _.7) (empty-k) void) (=/= ((_.0 lambda)) ((_.0 set!))) (num _.4) (sym _.0 _.1) (absento (lambda _.3) (set! _.3)))
     (((set! _.0 '_.1) ((_.2 _.3 _.0 . _.4) (_.5 _.6 _.7 . _.8)) (_.9 _.10) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!))) (num _.5 _.6 _.7) (sym _.0 _.2 _.3) (absento (closure _.1) '_.4 (set! _.4) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.0 . _.5) (_.6 _.7 _.8 _.9 . _.10)) (_.11 _.12) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!))) (num _.6 _.7 _.8 _.9) (sym _.0 _.2 _.3 _.4) (absento (closure _.1) '_.5 (set! _.5) (void _.1)))
     (((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (set!-k _.7 ((_.7 . _.8) (_.9 . _.10)) (empty-k)) void) (=/= ((_.0 quote)) ((_.0 set!))) (num _.3 _.9) (sym _.0 _.7) (absento (closure _.1) '_.2 (set! _.2) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.0 . _.4) (_.5 _.6 . _.7)) (_.8 _.9) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!))) (num _.5 _.6) (sym _.0 _.1 _.3) (absento (lambda _.4) (set! _.4)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.0 . _.6) (_.7 _.8 _.9 _.10 _.11 . _.12)) (_.13 _.14) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!))) (num _.10 _.11 _.7 _.8 _.9) (sym _.0 _.2 _.3 _.4 _.5) (absento (closure _.1) '_.6 (set! _.6) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.0 . _.7) (_.8 _.9 _.10 _.11 _.12 _.13 . _.14)) (_.15 _.16) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!))) (num _.10 _.11 _.12 _.13 _.8 _.9) (sym _.0 _.2 _.3 _.4 _.5 _.6) (absento (closure _.1) '_.7 (set! _.7) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.0 . _.5) (_.6 _.7 _.8 . _.9)) (_.10 _.11) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!))) (num _.6 _.7 _.8) (sym _.0 _.1 _.3 _.4) (absento (lambda _.5) (set! _.5)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.0 . _.8) (_.9 _.10 _.11 _.12 _.13 _.14 _.15 . _.16)) (_.17 _.18) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!))) (num _.10 _.11 _.12 _.13 _.14 _.15 _.9) (sym _.0 _.2 _.3 _.4 _.5 _.6 _.7) (absento (closure _.1) '_.8 (set! _.8) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.0 . _.9) (_.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 . _.18)) (_.19 _.20) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!))) (num _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17) (sym _.0 _.2 _.3 _.4 _.5 _.6 _.7 _.8) (absento (closure _.1) '_.9 (set! _.9) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.0 . _.6) (_.7 _.8 _.9 _.10 . _.11)) (_.12 _.13) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!))) (num _.10 _.7 _.8 _.9) (sym _.0 _.1 _.3 _.4 _.5) (absento (lambda _.6) (set! _.6)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.0 . _.10) (_.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 . _.20)) (_.21 _.22) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19) (sym _.0 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.10 (set! _.10) (void _.1)))
     (((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (set!-k _.7 ((_.8 _.7 . _.9) (_.10 _.11 . _.12)) (empty-k)) void) (=/= ((_.0 quote)) ((_.0 set!)) ((_.7 _.8))) (num _.10 _.11 _.3) (sym _.0 _.7 _.8) (absento (closure _.1) '_.2 (set! _.2) (void _.1)))
     (((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (list-aux-inner-k _.7 (empty-k)) (_.7 . void)) (=/= ((_.0 quote)) ((_.0 set!))) (num _.3) (sym _.0) (absento (closure _.1) '_.2 (set! _.2) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.0 . _.3) (_.4 _.5 . _.6)) (_.7 _.8) (set!-k _.9 ((_.9 . _.10) (_.11 . _.12)) (empty-k)) void) (=/= ((_.0 _.2)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!))) (num _.11 _.4 _.5) (sym _.0 _.2 _.9) (absento (closure _.1) '_.3 (set! _.3) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.0 . _.11) (_.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 . _.22)) (_.23 _.24) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21) (sym _.0 _.10 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.11 (set! _.11) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.0 . _.3) (_.4 . _.5)) (_.6 _.7) (set!-k _.8 ((_.8 . _.9) (_.10 . _.11)) (empty-k)) void) (=/= ((_.0 lambda)) ((_.0 set!))) (num _.10 _.4) (sym _.0 _.1 _.8) (absento (lambda _.3) (set! _.3)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.0 . _.7) (_.8 _.9 _.10 _.11 _.12 . _.13)) (_.14 _.15) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!))) (num _.10 _.11 _.12 _.8 _.9) (sym _.0 _.1 _.3 _.4 _.5 _.6) (absento (lambda _.7) (set! _.7)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.0 . _.12) (_.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 . _.24)) (_.25 _.26) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23) (sym _.0 _.10 _.11 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.12 (set! _.12) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.0 . _.13) (_.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 . _.26)) (_.27 _.28) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25) (sym _.0 _.10 _.11 _.12 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.13 (set! _.13) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.7 _.0 . _.8) (_.9 _.10 _.11 _.12 _.13 _.14 . _.15)) (_.16 _.17) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!)) ((_.7 lambda)) ((_.7 set!))) (num _.10 _.11 _.12 _.13 _.14 _.9) (sym _.0 _.1 _.3 _.4 _.5 _.6 _.7) (absento (lambda _.8) (set! _.8)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.0 . _.14) (_.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 . _.28)) (_.29 _.30) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27) (sym _.0 _.10 _.11 _.12 _.13 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.14 (set! _.14) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.0 . _.15) (_.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 . _.30)) (_.31 _.32) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.15 (set! _.15) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.7 _.8 _.0 . _.9) (_.10 _.11 _.12 _.13 _.14 _.15 _.16 . _.17)) (_.18 _.19) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!)) ((_.7 lambda)) ((_.7 set!)) ((_.8 lambda)) ((_.8 set!))) (num _.10 _.11 _.12 _.13 _.14 _.15 _.16) (sym _.0 _.1 _.3 _.4 _.5 _.6 _.7 _.8) (absento (lambda _.9) (set! _.9)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.0 . _.16) (_.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 . _.32)) (_.33 _.34) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.16 (set! _.16) (void _.1)))
     (((set! _.0 _.0) ((_.0 . _.1) (_.2 . _.3)) ((_.2 . _.4) (_.5 . _.6)) (empty-k) void) (=/= ((_.0 set!))) (num _.2) (sym _.0) (absento (set! _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.0 . _.17) (_.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 . _.34)) (_.35 _.36) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.17 (set! _.17) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.7 _.8 _.9 _.0 . _.10) (_.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 . _.19)) (_.20 _.21) (empty-k) void) (=/= ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!)) ((_.7 lambda)) ((_.7 set!)) ((_.8 lambda)) ((_.8 set!)) ((_.9 lambda)) ((_.9 set!))) (num _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18) (sym _.0 _.1 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (lambda _.10) (set! _.10)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.0 . _.18) (_.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 . _.36)) (_.37 _.38) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.17)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.17 quote)) ((_.17 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.18 (set! _.18) (void _.1)))
     (((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (application-inner-k (closure _.7 '_.8 (_.9 _.10)) (empty-k) _.8) _.8) (=/= ((_.0 quote)) ((_.0 set!)) ((_.7 quote))) (num _.3) (sym _.0 _.7) (absento (closure _.1) (closure _.8) '_.2 '_.9 (set! _.2) (void _.1) (void _.8)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.0 . _.19) (_.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 . _.38)) (_.39 _.40) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.17)) ((_.0 _.18)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.17 quote)) ((_.17 set!)) ((_.18 quote)) ((_.18 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.19 (set! _.19) (void _.1)))
     (((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (set!-k _.7 ((_.8 _.9 _.7 . _.10) (_.11 _.12 _.13 . _.14)) (empty-k)) void) (=/= ((_.0 quote)) ((_.0 set!)) ((_.7 _.8)) ((_.7 _.9))) (num _.11 _.12 _.13 _.3) (sym _.0 _.7 _.8 _.9) (absento (closure _.1) '_.2 (set! _.2) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.0 . _.3) (_.4 _.5 . _.6)) (_.7 _.8) (set!-k _.9 ((_.10 _.9 . _.11) (_.12 _.13 . _.14)) (empty-k)) void) (=/= ((_.0 _.2)) ((_.0 quote)) ((_.0 set!)) ((_.10 _.9)) ((_.2 quote)) ((_.2 set!))) (num _.12 _.13 _.4 _.5) (sym _.0 _.10 _.2 _.9) (absento (closure _.1) '_.3 (set! _.3) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.0 . _.11) (_.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 . _.21)) (_.22 _.23) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 lambda)) ((_.0 set!)) ((_.10 lambda)) ((_.10 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!)) ((_.7 lambda)) ((_.7 set!)) ((_.8 lambda)) ((_.8 set!)) ((_.9 lambda)) ((_.9 set!))) (num _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20) (sym _.0 _.1 _.10 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (lambda _.11) (set! _.11)))
     (((set! _.0 '_.1) ((_.2 _.0 . _.3) (_.4 _.5 . _.6)) (_.7 _.8) (list-aux-inner-k _.9 (empty-k)) (_.9 . void)) (=/= ((_.0 _.2)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!))) (num _.4 _.5) (sym _.0 _.2) (absento (closure _.1) '_.3 (set! _.3) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.0 . _.20) (_.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 . _.40)) (_.41 _.42) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.17)) ((_.0 _.18)) ((_.0 _.19)) ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.17 quote)) ((_.17 set!)) ((_.18 quote)) ((_.18 set!)) ((_.19 quote)) ((_.19 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.20 (set! _.20) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.0 . _.3) (_.4 . _.5)) (_.6 _.7) (set!-k _.8 ((_.9 _.8 . _.10) (_.11 _.12 . _.13)) (empty-k)) void) (=/= ((_.0 lambda)) ((_.0 set!)) ((_.8 _.9))) (num _.11 _.12 _.4) (sym _.0 _.1 _.8 _.9) (absento (lambda _.3) (set! _.3)))
     (((set! _.0 '_.1) ((_.2 _.3 _.0 . _.4) (_.5 _.6 _.7 . _.8)) (_.9 _.10) (set!-k _.11 ((_.11 . _.12) (_.13 . _.14)) (empty-k)) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!))) (num _.13 _.5 _.6 _.7) (sym _.0 _.11 _.2 _.3) (absento (closure _.1) '_.4 (set! _.4) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.0 . _.3) (_.4 . _.5)) (_.6 _.7) (list-aux-inner-k _.8 (empty-k)) (_.8 . void)) (=/= ((_.0 lambda)) ((_.0 set!))) (num _.4) (sym _.0 _.1) (absento (lambda _.3) (set! _.3)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.0 . _.21) (_.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41 . _.42)) (_.43 _.44) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.17)) ((_.0 _.18)) ((_.0 _.19)) ((_.0 _.2)) ((_.0 _.20)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.17 quote)) ((_.17 set!)) ((_.18 quote)) ((_.18 set!)) ((_.19 quote)) ((_.19 set!)) ((_.2 quote)) ((_.2 set!)) ((_.20 quote)) ((_.20 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.2 _.20 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.21 (set! _.21) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.0 . _.4) (_.5 _.6 . _.7)) (_.8 _.9) (set!-k _.10 ((_.10 . _.11) (_.12 . _.13)) (empty-k)) void) (=/= ((_.0 _.3)) ((_.0 lambda)) ((_.0 set!)) ((_.3 lambda)) ((_.3 set!))) (num _.12 _.5 _.6) (sym _.0 _.1 _.10 _.3) (absento (lambda _.4) (set! _.4)))
     (((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (set!-k _.7 ((_.7 . _.8) (_.9 . _.10)) (set!-k _.11 ((_.11 . _.12) (_.13 . _.14)) (empty-k))) void) (=/= ((_.0 quote)) ((_.0 set!))) (num _.13 _.3 _.9) (sym _.0 _.11 _.7) (absento (closure _.1) '_.2 (set! _.2) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.0 . _.12) (_.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 . _.23)) (_.24 _.25) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 lambda)) ((_.0 set!)) ((_.10 lambda)) ((_.10 set!)) ((_.11 lambda)) ((_.11 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!)) ((_.7 lambda)) ((_.7 set!)) ((_.8 lambda)) ((_.8 set!)) ((_.9 lambda)) ((_.9 set!))) (num _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22) (sym _.0 _.1 _.10 _.11 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (lambda _.12) (set! _.12)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.0 . _.22) (_.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41 _.42 _.43 . _.44)) (_.45 _.46) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.17)) ((_.0 _.18)) ((_.0 _.19)) ((_.0 _.2)) ((_.0 _.20)) ((_.0 _.21)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.17 quote)) ((_.17 set!)) ((_.18 quote)) ((_.18 set!)) ((_.19 quote)) ((_.19 set!)) ((_.2 quote)) ((_.2 set!)) ((_.20 quote)) ((_.20 set!)) ((_.21 quote)) ((_.21 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.23 _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41 _.42 _.43) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.2 _.20 _.21 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.22 (set! _.22) (void _.1)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.0 . _.23) (_.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41 _.42 _.43 _.44 _.45 . _.46)) (_.47 _.48) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.17)) ((_.0 _.18)) ((_.0 _.19)) ((_.0 _.2)) ((_.0 _.20)) ((_.0 _.21)) ((_.0 _.22)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.17 quote)) ((_.17 set!)) ((_.18 quote)) ((_.18 set!)) ((_.19 quote)) ((_.19 set!)) ((_.2 quote)) ((_.2 set!)) ((_.20 quote)) ((_.20 set!)) ((_.21 quote)) ((_.21 set!)) ((_.22 quote)) ((_.22 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.24 _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41 _.42 _.43 _.44 _.45) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.2 _.20 _.21 _.22 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.23 (set! _.23) (void _.1)))
     (((set! _.0 (lambda (_.1) _.2)) ((_.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.0 . _.13) (_.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 . _.25)) (_.26 _.27) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 lambda)) ((_.0 set!)) ((_.10 lambda)) ((_.10 set!)) ((_.11 lambda)) ((_.11 set!)) ((_.12 lambda)) ((_.12 set!)) ((_.3 lambda)) ((_.3 set!)) ((_.4 lambda)) ((_.4 set!)) ((_.5 lambda)) ((_.5 set!)) ((_.6 lambda)) ((_.6 set!)) ((_.7 lambda)) ((_.7 set!)) ((_.8 lambda)) ((_.8 set!)) ((_.9 lambda)) ((_.9 set!))) (num _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24) (sym _.0 _.1 _.10 _.11 _.12 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (lambda _.13) (set! _.13)))
     (((set! _.0 '_.1) ((_.2 _.3 _.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.0 . _.24) (_.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41 _.42 _.43 _.44 _.45 _.46 _.47 . _.48)) (_.49 _.50) (empty-k) void) (=/= ((_.0 _.10)) ((_.0 _.11)) ((_.0 _.12)) ((_.0 _.13)) ((_.0 _.14)) ((_.0 _.15)) ((_.0 _.16)) ((_.0 _.17)) ((_.0 _.18)) ((_.0 _.19)) ((_.0 _.2)) ((_.0 _.20)) ((_.0 _.21)) ((_.0 _.22)) ((_.0 _.23)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 _.5)) ((_.0 _.6)) ((_.0 _.7)) ((_.0 _.8)) ((_.0 _.9)) ((_.0 quote)) ((_.0 set!)) ((_.10 quote)) ((_.10 set!)) ((_.11 quote)) ((_.11 set!)) ((_.12 quote)) ((_.12 set!)) ((_.13 quote)) ((_.13 set!)) ((_.14 quote)) ((_.14 set!)) ((_.15 quote)) ((_.15 set!)) ((_.16 quote)) ((_.16 set!)) ((_.17 quote)) ((_.17 set!)) ((_.18 quote)) ((_.18 set!)) ((_.19 quote)) ((_.19 set!)) ((_.2 quote)) ((_.2 set!)) ((_.20 quote)) ((_.20 set!)) ((_.21 quote)) ((_.21 set!)) ((_.22 quote)) ((_.22 set!)) ((_.23 quote)) ((_.23 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!)) ((_.5 quote)) ((_.5 set!)) ((_.6 quote)) ((_.6 set!)) ((_.7 quote)) ((_.7 set!)) ((_.8 quote)) ((_.8 set!)) ((_.9 quote)) ((_.9 set!))) (num _.25 _.26 _.27 _.28 _.29 _.30 _.31 _.32 _.33 _.34 _.35 _.36 _.37 _.38 _.39 _.40 _.41 _.42 _.43 _.44 _.45 _.46 _.47) (sym _.0 _.10 _.11 _.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 _.2 _.20 _.21 _.22 _.23 _.3 _.4 _.5 _.6 _.7 _.8 _.9) (absento (closure _.1) '_.24 (set! _.24) (void _.1)))
     (((set! _.0 _.1) ((_.1 _.0 . _.2) (_.3 _.4 . _.5)) ((_.3 . _.6) (_.7 . _.8)) (empty-k) void) (=/= ((_.0 _.1)) ((_.0 set!)) ((_.1 set!))) (num _.3 _.4) (sym _.0 _.1) (absento (set! _.2)))))

 (test "cesk-set!-1b"
   (length
    (run 50 (q)
     (fresh (expr env store k val x e)
       (== `(set! ,x ,e) expr)
       (== `(,expr ,env ,store ,k ,val) q)      
       (eval-expo-simple
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo expr env store k val)]
         [(errorg 'cesk-set!-1b "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
   50)

 (test "cesk-set!-1c"
   (length
    (run 30 (q)
      (fresh (expr env store k val x e)
        (== `(set! ,x ,e) expr)
        (== `(,expr ,env ,store ,k ,val) q)            
        (== `(,expr ,env ,store ,k ,val) q)      
        (eval-expo
         expr
         env
         store
         k
         val)
        (condu
          [(eval-expo-simple expr env store k val)]
          [(errorg 'cesk-set!-1c "eval-expo-simpl can't handle state generated by eval-expo:\n\n~s\n\n" q)]))))
   30)

 ;;; tests related to v-out
 (test "cesk-application-inner-k-1"
   (run 5 (q)
     (fresh (expr env store k val v-out datum env^ x datum^)
       (== `(quote ,datum) expr)
       (==
        `(application-inner-k
          (closure ,x (quote ,datum^) ,env^)
          (empty-k)
          ,v-out)
        k)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((('_.0 (_.1 _.2) (_.3 _.4) (application-inner-k (closure _.5 '_.6 (_.7 _.8)) (empty-k) _.6) _.6) (=/= ((_.5 quote))) (sym _.5) (absento (closure _.0) (closure _.6) '_.1 '_.7 (void _.0) (void _.6)))
     (('_.0 (_.1 _.2) ((_.3 . _.4) ((closure _.5 '_.6 (_.7 _.8)) . _.9)) (application-inner-k (closure _.10 '(lambda (_.11) _.12) ((quote . _.13) (_.3 . _.14))) (empty-k) _.6) _.6) (=/= ((_.10 lambda)) ((_.10 quote)) ((_.5 quote))) (num _.3) (sym _.10 _.11 _.5) (absento (closure _.0) (closure _.6) (lambda _.13) '_.1 '_.7 (void _.0) (void _.6)))
     (('_.0 (_.1 _.2) ((_.3 . _.4) ((closure _.5 (lambda (_.6) _.7) (_.8 _.9)) . _.10)) (application-inner-k (closure _.11 '(lambda (_.12) _.13) ((quote . _.14) (_.3 . _.15))) (empty-k) (closure _.6 _.7 ((_.5 . _.8) (_.16 . _.9)))) (closure _.6 _.7 ((_.5 . _.8) (_.16 . _.9)))) (=/= ((_.11 lambda)) ((_.11 quote)) ((_.16 _.3)) ((_.5 lambda))) (num _.16 _.3) (sym _.11 _.12 _.5 _.6) (absento (_.16 _.4) (closure _.0) (lambda _.14) (lambda _.8) '_.1  (void _.0)))
     (('(lambda (_.0) _.1) ((quote . _.2) (_.3 . _.4)) ((_.3 . _.5) ((closure _.6 '_.7 (_.8 _.9)) . _.10)) (application-inner-k (closure _.11 '_.12 (_.13 _.14)) (empty-k) _.12) _.12) (=/= ((_.11 quote)) ((_.6 quote))) (num _.3) (sym _.0 _.11 _.6) (absento (closure _.12) (closure _.7) (lambda _.2) '_.13 '_.8  (void _.12) (void _.7)))
     (('_.0 (_.1 _.2) ((_.3 . _.4) ((closure _.5 _.5 (_.6 _.7)) . _.8)) (application-inner-k (closure _.9 '(lambda (_.10) _.11) ((quote . _.12) (_.3 . _.13))) (empty-k) (closure _.10 _.11 ((_.9 quote . _.12) (_.14 _.3 . _.13)))) (closure _.10 _.11 ((_.9 quote . _.12) (_.14 _.3 . _.13)))) (=/= ((_.14 _.3)) ((_.9 lambda)) ((_.9 quote))) (num _.14 _.3) (sym _.10 _.5 _.9) (absento (_.14 _.4) (closure _.0) (lambda _.12) '_.1 (void _.0)))))

 (test "cesk-application-inner-k-1b"
   (length
    (run 10 (q)
     (fresh (expr env store k val datum x datum^ env^ v-out)
       (== `(quote ,datum) expr)
       (==
        `(application-inner-k
          (closure ,x (quote ,datum^) ,env^)
          (empty-k)
          ,v-out)
        k)
       (== `(,expr ,env ,store ,k ,val) q)      
       (eval-expo-simple
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo expr env store k val)]
         [(errorg 'cesk-application-inner-k-1b "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-application-inner-k-1c"
   (length
    (run 10 (q)
     (fresh (expr env store k val datum x datum^ env^ v-out)
       (== `(quote ,datum) expr)
       (==
        `(application-inner-k
          (closure ,x (quote ,datum^) ,env^)
          (empty-k)
          ,v-out)
        k)
       (== `(,expr ,env ,store ,k ,val) q)      
       (eval-expo
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo-simple expr env store k val)]
         [(errorg 'cesk-application-inner-k-1c "eval-expo-simpl can't handle state generated by eval-expo:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-application-inner-k-2"
   (run 4 (q)
     (fresh (expr k datum x y env^ env store val v-out)
       (== `(quote ,datum) expr)
       (symbolo y)
       (==
        `(application-inner-k
          (closure ,x ,y ,env^)
          (empty-k)
          ,v-out)
        k)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((('_.0 (_.1 _.2) (_.3 _.4) (application-inner-k (closure _.5 _.5 (_.6 _.7)) (empty-k) _.0) _.0) (sym _.5) (absento (closure _.0) '_.1 (void _.0)))
     (('_.0 (_.1 _.2) ((_.3 . _.4) (_.5 . _.6)) (application-inner-k (closure _.7 _.8 ((_.8 . _.9) (_.10 . _.11))) (empty-k) _.0) _.0) (=/= ((_.10 _.3)) ((_.7 _.8))) (num _.10 _.3) (sym _.7 _.8) (absento (_.10 _.4) (closure _.0) '_.1 (void _.0)))
     (('_.0 (_.1 _.2) ((_.3 . _.4) (_.5 . _.6)) (application-inner-k (closure _.7 _.8 ((_.8 . _.9) (_.3 . _.10))) (empty-k) _.5) _.5) (=/= ((_.7 _.8))) (num _.3) (sym _.7 _.8) (absento (closure _.0) '_.1 (void _.0)))
     (('_.0 (_.1 _.2) ((_.3 _.4 . _.5) (_.6 _.7 . _.8)) (application-inner-k (closure _.9 _.10 ((_.11 _.10 . _.12) (_.13 _.14 . _.15))) (empty-k) _.0) _.0) (=/= ((_.10 _.11)) ((_.10 _.9)) ((_.14 _.3)) ((_.14 _.4))) (num _.13 _.14 _.3 _.4) (sym _.10 _.11 _.9) (absento (_.14 _.5) (closure _.0) '_.1 (void _.0)))))

 (test "cesk-application-inner-k-2b"
   (length
    (run 10 (q)
     (fresh (expr env store k val datum x y env^ v-out)
       (== `(quote ,datum) expr)
       (symbolo y)
       (==
        `(application-inner-k
          (closure ,x ,y ,env^)
          (empty-k)
          ,v-out)
        k)
       (== `(,expr ,env ,store ,k ,val) q)      
       (eval-expo-simple
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo expr env store k val)]
         [(errorg 'cesk-application-inner-k-2b "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-application-inner-k-2c"
   (length
    (run 10 (q)
     (fresh (expr env store k val datum x y env^ v-out)
       (== `(quote ,datum) expr)
       (symbolo y)
       (==
        `(application-inner-k
          (closure ,x ,y ,env^)
          (empty-k)
          ,v-out)
        k)
       (== `(,expr ,env ,store ,k ,val) q)      
       (eval-expo
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo-simple expr env store k val)]
         [(errorg 'cesk-application-inner-k-2c "eval-expo-simple can't handle state generated by eval-expo:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-empty-list-backwards"
   (run 8 (q)
     (fresh (expr k datum x y env^ env store val v-out)
       (== '(list) expr)
       (=/= empty-k k)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.4 . _.5) (_.6 . _.7)) (empty-k)) void) (num _.6) (sym _.4) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.5 _.4 . _.6) (_.7 _.8 . _.9)) (empty-k)) void) (=/= ((_.4 _.5))) (num _.7 _.8) (sym _.4 _.5) (absento (list _.0)))
     (((list) (_.0 _.1) _.2 (list-aux-inner-k _.3 (empty-k)) (_.3)) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (application-inner-k (closure _.4 '_.5 (_.6 _.7)) (empty-k) _.5) _.5) (=/= ((_.4 quote))) (sym _.4) (absento (closure _.5) (list _.0) '_.6 (void _.5)))
     (((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.5 _.6 _.4 . _.7) (_.8 _.9 _.10 . _.11)) (empty-k)) void) (=/= ((_.4 _.5)) ((_.4 _.6))) (num _.10 _.8 _.9) (sym _.4 _.5 _.6) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.4 . _.5) (_.6 . _.7)) (set!-k _.8 ((_.8 . _.9) (_.10 . _.11)) (empty-k))) void) (num _.10 _.6) (sym _.4 _.8) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (application-inner-k (closure _.4 (lambda (_.5) _.6) (_.7 _.8)) (empty-k) (closure _.5 _.6 ((_.4 . _.7) (_.9 . _.8)))) (closure _.5 _.6 ((_.4 . _.7) (_.9 . _.8)))) (=/= ((_.4 lambda))) (num _.9) (sym _.4 _.5) (absento (_.9 _.2) (lambda _.7) (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.5 _.6 _.7 _.4 . _.8) (_.9 _.10 _.11 _.12 . _.13)) (empty-k)) void) (=/= ((_.4 _.5)) ((_.4 _.6)) ((_.4 _.7))) (num _.10 _.11 _.12 _.9) (sym _.4 _.5 _.6 _.7) (absento (list _.0)))))

 (test "cesk-empty-list-backwards-b"
   (length
    (run 10 (q)
     (fresh (expr env store k val)
       (== '(list) expr)
       (=/= empty-k k)
       (== `(,expr ,env ,store ,k ,val) q)      
       (eval-expo-simple
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo expr env store k val)]
         [(errorg 'cesk-empty-list-backwards-b "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-empty-list-backwards-c"
   (length
    (run 10 (q)
     (fresh (expr env store k val)
       (== '(list) expr)
       (=/= empty-k k)
       (== `(,expr ,env ,store ,k ,val) q)      
       (eval-expo
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo-simple expr env store k val)]
         [(errorg 'cesk-empty-list-backwards-c "eval-expo-simple can't handle state generated by eval-expo:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-empty-list-application"
   (run 4 (q)
     (fresh (expr k env store val)
       (== '((lambda (x) (quote (foo bar))) (list)) expr)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '(((((lambda (x) '(foo bar)) (list)) (_.0 _.1) (_.2 _.3) (empty-k) (foo bar)) (absento (lambda _.0) (list _.0) '_.0))
     ((((lambda (x) '(foo bar)) (list)) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.4 . _.5) (_.6 . _.7)) (empty-k)) void) (num _.6) (sym _.4) (absento (lambda _.0) (list _.0) '_.0))
     ((((lambda (x) '(foo bar)) (list)) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.5 _.4 . _.6) (_.7 _.8 . _.9)) (empty-k)) void) (=/= ((_.4 _.5))) (num _.7 _.8) (sym _.4 _.5) (absento (lambda _.0) (list _.0) '_.0))
     ((((lambda (x) '(foo bar)) (list)) (_.0 _.1) (_.2 _.3) (list-aux-inner-k _.4 (empty-k)) (_.4 foo bar)) (absento (lambda _.0) (list _.0) '_.0))))

 (test "cesk-empty-list-application-b"
   (length
    (run 10 (q)
     (fresh (expr env store k val)
       (== '((lambda (x) (quote (foo bar))) (list)) expr)
       (== `(,expr ,env ,store ,k ,val) q)
       (eval-expo-simple
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo expr env store k val)]
         [(errorg 'cesk-empty-list-application-b "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-empty-list-application-c"
   (length
    (run 10 (q)
     (fresh (expr env store k val)
       (== '((lambda (x) (quote (foo bar))) (list)) expr)
       (== `(,expr ,env ,store ,k ,val) q)
       (eval-expo
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo-simple expr env store k val)]
         [(errorg 'cesk-empty-list-application-c "eval-expo-simple can't handle state generated by eval-expo:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-empty-list-non-empty-answer-backwards-1"
   (run 1 (q)
     (fresh (expr k datum x y env^ env store val v-out)
       (== '(list) expr)
       (==
        `(application-inner-k
          (closure ,x (quote foo) ,env^)
          (empty-k)
          ,v-out)
        k)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((((list) (_.0 _.1) (_.2 _.3) (application-inner-k (closure _.4 'foo (_.5 _.6)) (empty-k) foo) foo)
      (=/= ((_.4 quote))) (sym _.4) (absento (list _.0) '_.5))))

 (test "cesk-empty-list-non-empty-answer-backwards-2"
   (run 7 (q)
     (fresh (expr k datum x y env^ env store val v-out a d)
       (== '(list) expr)
       (=/= '() val)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.4 . _.5) (_.6 . _.7)) (empty-k)) void) (num _.6) (sym _.4) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.5 _.4 . _.6) (_.7 _.8 . _.9)) (empty-k)) void) (=/= ((_.4 _.5))) (num _.7 _.8) (sym _.4 _.5) (absento (list _.0)))
     (((list) (_.0 _.1) _.2 (list-aux-inner-k _.3 (empty-k)) (_.3)) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (application-inner-k (closure _.4 '_.5 (_.6 _.7)) (empty-k) _.5) _.5) (=/= ((_.4 quote)) ((_.5 ()))) (sym _.4) (absento (closure _.5) (list _.0) '_.6 (void _.5)))
     (((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.5 _.6 _.4 . _.7) (_.8 _.9 _.10 . _.11)) (empty-k)) void) (=/= ((_.4 _.5)) ((_.4 _.6))) (num _.10 _.8 _.9) (sym _.4 _.5 _.6) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.4 . _.5) (_.6 . _.7)) (set!-k _.8 ((_.8 . _.9) (_.10 . _.11)) (empty-k))) void) (num _.10 _.6) (sym _.4 _.8) (absento (list _.0)))
     (((list) (_.0 _.1) (_.2 _.3) (application-inner-k (closure _.4 (lambda (_.5) _.6) (_.7 _.8)) (empty-k) (closure _.5 _.6 ((_.4 . _.7) (_.9 . _.8)))) (closure _.5 _.6 ((_.4 . _.7) (_.9 . _.8)))) (=/= ((_.4 lambda))) (num _.9) (sym _.4 _.5) (absento (_.9 _.2) (lambda _.7) (list _.0)))))

 (test "cesk-empty-list-non-empty-answer-backwards-b"
   (length
    (run 10 (q)
     (fresh (expr env store k val)
       (== '(list) expr)
       (=/= '() val)
       (== `(,expr ,env ,store ,k ,val) q)
       (eval-expo-simple
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo expr env store k val)]
         [(errorg 'cesk-empty-list-non-empty-answer-backwards-b "eval-expo can't handle state generated by eval-expo-simple:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-empty-list-non-empty-answer-backwards-c"
   (length
    (run 10 (q)
     (fresh (expr env store k val)
       (== '(list) expr)
       (=/= '() val)
       (== `(,expr ,env ,store ,k ,val) q)
       (eval-expo
        expr
        env
        store
        k
        val)
       (condu
         [(eval-expo-simple expr env store k val)]
         [(errorg 'cesk-empty-list-non-empty-answer-backwards-c "eval-expo-simple can't handle state generated by eval-expo:\n\n~s\n\n" q)]))))
   10)

 (test "cesk-nested-lists"
   (run 4 (q)
     (fresh (expr k datum x y env^ env store val v-out a d)
       (== '(list (list)) expr)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((((list (list)) (_.0 _.1) _.2 (empty-k) (())) (absento (list _.0)))
     (((list (list)) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.4 . _.5) (_.6 . _.7)) (empty-k)) void) (num _.6) (sym _.4) (absento (list _.0)))
     (((list (list)) (_.0 _.1) (_.2 _.3) (set!-k _.4 ((_.5 _.4 . _.6) (_.7 _.8 . _.9)) (empty-k)) void) (=/= ((_.4 _.5))) (num _.7 _.8) (sym _.4 _.5) (absento (list _.0)))
     (((list (list)) (_.0 _.1) _.2 (list-aux-inner-k _.3 (empty-k)) (_.3 ())) (absento (list _.0)))))

 (define quinec
   '((lambda (x)
       (list x (list (quote quote) x)))
     (quote
       (lambda (x)
         (list x (list (quote quote) x))))))

 (test "cesk-quinec-forwards"
   (run* (q)
     (evalo quinec q))
   `(,quinec))

 (test "cesk-quinec-both"
   (run 1 (q)
     (evalo quinec quinec))
   '(_.0))

 (test "cesk-quote-bkwards-0"
   (run 1 (q)
     (evalo (quote (quote x)) (quote x)))
   `(_.0))

 (test "cesk-quote-bkwards-1"
   (run 1 (q)
     (evalo `(quote (quote x)) `(quote x)))
   `(_.0))

 (test "cesk-quote-bkwards-2"
   (run 1 (q)
       (fresh (y)
         (== y 'x)
         (eval-expo `(quote ,y)
                    empty-env
                    empty-store
                    empty-k
                    q)))
   `(x))

 (test "cesk-quinec-bkwards-a"
   (run 1 (q)
     (== quinec q)
     (evalo q quinec))
   `(,quinec))

 (test "cesk-fresh-bkwards"
   (run 10 (q)
     (fresh (expr v)
       (evalo expr v)
       (== `(,expr ,v) q)))
   '((('_.0 _.0) (absento (closure _.0) (void _.0)))
     (((lambda (_.0) _.1) (closure _.0 _.1 (() ()))) (sym _.0))
     ((list) ())
     (((list '_.0) (_.0)) (absento (closure _.0) (void _.0)))
     (((list (lambda (_.0) _.1)) ((closure _.0 _.1 (() ())))) (sym _.0))
     ((((lambda (_.0) '_.1) '_.2) _.1) (=/= ((_.0 quote))) (sym _.0) (absento (closure _.1) (closure _.2) (void _.1) (void _.2)))
     ((((lambda (_.0) (lambda (_.1) _.2)) '_.3) (closure _.1 _.2 ((_.0) (_.4)))) (=/= ((_.0 lambda))) (num _.4) (sym _.0 _.1) (absento (closure _.3) (void _.3)))
     (((list '_.0 '_.1) (_.0 _.1)) (absento (closure _.0) (closure _.1) (void _.0) (void _.1)))
     ((((lambda (_.0) _.0) '_.1) _.1) (sym _.0) (absento (closure _.1) (void _.1)))
     ((((lambda (_.0) '_.1) (lambda (_.2) _.3)) _.1) (=/= ((_.0 quote))) (sym _.0 _.2) (absento (closure _.1) (void _.1)))))

 (test "cesk-quinec-bkwards-a"
   (run 50 (q)
     (fresh (expr env store k val)
       (eval-expo
        expr
        env
        store
        k
        val)
       (== `(,expr ,env ,store ,k ,val) q)))
   '((('_.0 (_.1 _.2) _.3 (empty-k) _.0) (absento (closure _.0) '_.1 (void _.0))) (((lambda (_.0) _.1) (_.2 _.3) _.4 (empty-k) (closure _.0 _.1 (_.2 _.3))) (sym _.0) (absento (lambda _.2))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.2 . _.4) (_.5 . _.6)) (empty-k) _.5) (num _.2) (sym _.0)) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.5 . _.6) (_.7 . _.8)) (empty-k)) void) (num _.7) (sym _.5) (absento (closure _.0) '_.1 (void _.0))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.2 . _.5) (_.6 _.7 . _.8)) (empty-k) _.7) (=/= ((_.2 _.4))) (num _.2 _.4) (sym _.0)) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.6 _.5 . _.7) (_.8 _.9 . _.10)) (empty-k)) void) (=/= ((_.5 _.6))) (num _.8 _.9) (sym _.5 _.6) (absento (closure _.0) '_.1 (void _.0))) ((_.0 ((_.1 _.0 . _.2) (_.3 _.4 . _.5)) ((_.4 _.6 . _.7) (_.8 _.9 . _.10)) (empty-k) _.8) (=/= ((_.0 _.1))) (num _.3 _.4 _.6) (sym _.0 _.1)) (('_.0 (_.1 _.2) _.3 (list-aux-inner-k _.4 (empty-k)) (_.4 . _.0)) (absento (closure _.0) '_.1 (void _.0))) (((lambda (_.0) _.1) (_.2 _.3) (_.4 _.5) (set!-k _.6 ((_.6 . _.7) (_.8 . _.9)) (empty-k)) void) (num _.8) (sym _.0 _.6) (absento (lambda _.2))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.2 . _.6) (_.7 _.8 _.9 . _.10)) (empty-k) _.9) (=/= ((_.2 _.4)) ((_.2 _.5))) (num _.2 _.4 _.5) (sym _.0)) (((list) (_.0 _.1) _.2 (empty-k) ()) (absento (list _.0))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.2 . _.7) (_.8 _.9 _.10 _.11 . _.12)) (empty-k) _.11) (=/= ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6))) (num _.2 _.4 _.5 _.6) (sym _.0)) ((_.0 ((_.1 _.0 . _.2) (_.3 _.4 . _.5)) ((_.6 _.4 . _.7) (_.8 _.9 . _.10)) (empty-k) _.9) (=/= ((_.0 _.1)) ((_.4 _.6))) (num _.3 _.4 _.6) (sym _.0 _.1)) (('_.0 (_.1 _.2) (_.3 _.4) (application-inner-k (closure _.5 '_.6 (_.7 _.8)) (empty-k) _.6) _.6) (=/= ((_.5 quote))) (sym _.5) (absento (closure _.0) (closure _.6) '_.1 '_.7 (void _.0) (void _.6))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.2 . _.8) (_.9 _.10 _.11 _.12 _.13 . _.14)) (empty-k) _.13) (=/= ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7))) (num _.2 _.4 _.5 _.6 _.7) (sym _.0)) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.6 _.7 _.5 . _.8) (_.9 _.10 _.11 . _.12)) (empty-k)) void) (=/= ((_.5 _.6)) ((_.5 _.7))) (num _.10 _.11 _.9) (sym _.5 _.6 _.7) (absento (closure _.0) '_.1 (void _.0))) (((lambda (_.0) _.1) (_.2 _.3) (_.4 _.5) (set!-k _.6 ((_.7 _.6 . _.8) (_.9 _.10 . _.11)) (empty-k)) void) (=/= ((_.6 _.7))) (num _.10 _.9) (sym _.0 _.6 _.7) (absento (lambda _.2))) (((set! _.0 '_.1) ((_.0 . _.2) (_.3 . _.4)) (_.5 _.6) (empty-k) void) (=/= ((_.0 quote)) ((_.0 set!))) (num _.3) (sym _.0) (absento (closure _.1) '_.2 (set! _.2) (void _.1))) ((_.0 ((_.1 _.2 _.0 . _.3) (_.4 _.5 _.6 . _.7)) ((_.6 _.8 _.9 . _.10) (_.11 _.12 _.13 . _.14)) (empty-k) _.11) (=/= ((_.0 _.1)) ((_.0 _.2))) (num _.4 _.5 _.6 _.8 _.9) (sym _.0 _.1 _.2)) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.5 . _.6) (_.7 . _.8)) (set!-k _.9 ((_.9 . _.10) (_.11 . _.12)) (empty-k))) void) (num _.11 _.7) (sym _.5 _.9) (absento (closure _.0) '_.1 (void _.0))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.2 . _.9) (_.10 _.11 _.12 _.13 _.14 _.15 . _.16)) (empty-k) _.15) (=/= ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8))) (num _.2 _.4 _.5 _.6 _.7 _.8) (sym _.0)) ((_.0 ((_.1 _.0 . _.2) (_.3 _.4 . _.5)) ((_.6 _.7 _.4 . _.8) (_.9 _.10 _.11 . _.12)) (empty-k) _.11) (=/= ((_.0 _.1)) ((_.4 _.6)) ((_.4 _.7))) (num _.3 _.4 _.6 _.7) (sym _.0 _.1)) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.9 _.2 . _.10) (_.11 _.12 _.13 _.14 _.15 _.16 _.17 . _.18)) (empty-k) _.17) (=/= ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8)) ((_.2 _.9))) (num _.2 _.4 _.5 _.6 _.7 _.8 _.9) (sym _.0)) (('_.0 (_.1 _.2) (_.3 _.4) (application-inner-k (closure _.5 (lambda (_.6) _.7) (_.8 _.9)) (empty-k) (closure _.6 _.7 ((_.5 . _.8) (_.10 . _.9)))) (closure _.6 _.7 ((_.5 . _.8) (_.10 . _.9)))) (=/= ((_.5 lambda))) (num _.10) (sym _.5 _.6) (absento (_.10 _.3) (closure _.0) (lambda _.8) '_.1 (void _.0))) (((set! _.0 '_.1) ((_.2 _.0 . _.3) (_.4 _.5 . _.6)) (_.7 _.8) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!))) (num _.4 _.5) (sym _.0 _.2) (absento (closure _.1) '_.3 (set! _.3) (void _.1))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.9 _.10 _.2 . _.11) (_.12 _.13 _.14 _.15 _.16 _.17 _.18 _.19 . _.20)) (empty-k) _.19) (=/= ((_.10 _.2)) ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8)) ((_.2 _.9))) (num _.10 _.2 _.4 _.5 _.6 _.7 _.8 _.9) (sym _.0)) (((lambda (_.0) _.1) (_.2 _.3) _.4 (list-aux-inner-k _.5 (empty-k)) (_.5 closure _.0 _.1 (_.2 _.3))) (sym _.0) (absento (lambda _.2))) ((_.0 ((_.1 _.0 . _.2) (_.3 _.4 . _.5)) ((_.6 _.7 _.8 _.4 . _.9) (_.10 _.11 _.12 _.13 . _.14)) (empty-k) _.13) (=/= ((_.0 _.1)) ((_.4 _.6)) ((_.4 _.7)) ((_.4 _.8))) (num _.3 _.4 _.6 _.7 _.8) (sym _.0 _.1)) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.2 . _.12) (_.13 _.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 . _.22)) (empty-k) _.21) (=/= ((_.10 _.2)) ((_.11 _.2)) ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8)) ((_.2 _.9))) (num _.10 _.11 _.2 _.4 _.5 _.6 _.7 _.8 _.9) (sym _.0)) (((set! _.0 (lambda (_.1) _.2)) ((_.0 . _.3) (_.4 . _.5)) (_.6 _.7) (empty-k) void) (=/= ((_.0 lambda)) ((_.0 set!))) (num _.4) (sym _.0 _.1) (absento (lambda _.3) (set! _.3))) ((_.0 ((_.1 _.2 _.0 . _.3) (_.4 _.5 _.6 . _.7)) ((_.8 _.6 _.9 . _.10) (_.11 _.12 _.13 . _.14)) (empty-k) _.12) (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.6 _.8))) (num _.4 _.5 _.6 _.8 _.9) (sym _.0 _.1 _.2)) (((set! _.0 '_.1) ((_.2 _.3 _.0 . _.4) (_.5 _.6 _.7 . _.8)) (_.9 _.10) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!))) (num _.5 _.6 _.7) (sym _.0 _.2 _.3) (absento (closure _.1) '_.4 (set! _.4) (void _.1))) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.6 _.7 _.8 _.5 . _.9) (_.10 _.11 _.12 _.13 . _.14)) (empty-k)) void) (=/= ((_.5 _.6)) ((_.5 _.7)) ((_.5 _.8))) (num _.10 _.11 _.12 _.13) (sym _.5 _.6 _.7 _.8) (absento (closure _.0) '_.1 (void _.0))) (((lambda (_.0) _.1) (_.2 _.3) (_.4 _.5) (application-inner-k (closure _.6 '_.7 (_.8 _.9)) (empty-k) _.7) _.7) (=/= ((_.6 quote))) (sym _.0 _.6) (absento (closure _.7) (lambda _.2) '_.8 (void _.7))) (((lambda (_.0) _.1) (_.2 _.3) (_.4 _.5) (set!-k _.6 ((_.7 _.8 _.6 . _.9) (_.10 _.11 _.12 . _.13)) (empty-k)) void) (=/= ((_.6 _.7)) ((_.6 _.8))) (num _.10 _.11 _.12) (sym _.0 _.6 _.7 _.8) (absento (lambda _.2))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.2 . _.13) (_.14 _.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 . _.24)) (empty-k) _.23) (=/= ((_.10 _.2)) ((_.11 _.2)) ((_.12 _.2)) ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8)) ((_.2 _.9))) (num _.10 _.11 _.12 _.2 _.4 _.5 _.6 _.7 _.8 _.9) (sym _.0)) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.5 . _.6) (_.7 . _.8)) (set!-k _.9 ((_.10 _.9 . _.11) (_.12 _.13 . _.14)) (empty-k))) void) (=/= ((_.10 _.9))) (num _.12 _.13 _.7) (sym _.10 _.5 _.9) (absento (closure _.0) '_.1 (void _.0))) ((_.0 ((_.1 _.0 . _.2) (_.3 _.4 . _.5)) ((_.6 _.7 _.8 _.9 _.4 . _.10) (_.11 _.12 _.13 _.14 _.15 . _.16)) (empty-k) _.15) (=/= ((_.0 _.1)) ((_.4 _.6)) ((_.4 _.7)) ((_.4 _.8)) ((_.4 _.9))) (num _.3 _.4 _.6 _.7 _.8 _.9) (sym _.0 _.1)) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.5 . _.6) (_.7 . _.8)) (list-aux-inner-k _.9 (empty-k))) (_.9 . void)) (num _.7) (sym _.5) (absento (closure _.0) '_.1 (void _.0))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.2 . _.14) (_.15 _.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 . _.26)) (empty-k) _.25) (=/= ((_.10 _.2)) ((_.11 _.2)) ((_.12 _.2)) ((_.13 _.2)) ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8)) ((_.2 _.9))) (num _.10 _.11 _.12 _.13 _.2 _.4 _.5 _.6 _.7 _.8 _.9) (sym _.0)) (('_.0 (_.1 _.2) (_.3 _.4) (set!-k _.5 ((_.6 _.5 . _.7) (_.8 _.9 . _.10)) (set!-k _.11 ((_.11 . _.12) (_.13 . _.14)) (empty-k))) void) (=/= ((_.5 _.6))) (num _.13 _.8 _.9) (sym _.11 _.5 _.6) (absento (closure _.0) '_.1 (void _.0))) (('_.0 (_.1 _.2) (_.3 _.4) (list-aux-inner-k _.5 (set!-k _.6 ((_.6 . _.7) (_.8 . _.9)) (empty-k))) void) (num _.8) (sym _.6) (absento (closure _.0) '_.1 (void _.0))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.2 . _.4) (_.5 . _.6)) (set!-k _.7 ((_.7 . _.8) (_.9 . _.10)) (empty-k)) void) (num _.2 _.9) (sym _.0 _.7)) (((lambda (_.0) _.1) (_.2 _.3) (_.4 _.5) (set!-k _.6 ((_.6 . _.7) (_.8 . _.9)) (set!-k _.10 ((_.10 . _.11) (_.12 . _.13)) (empty-k))) void) (num _.12 _.8) (sym _.0 _.10 _.6) (absento (lambda _.2))) (('_.0 (_.1 _.2) _.3 (list-aux-outer-k (_.4) _.5 (empty-k) ()) (_.0)) (absento (closure _.0) '_.1 (void _.0))) ((_.0 ((_.1 _.2 _.3 _.0 . _.4) (_.5 _.6 _.7 _.8 . _.9)) ((_.8 _.10 _.11 _.12 . _.13) (_.14 _.15 _.16 _.17 . _.18)) (empty-k) _.14) (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.0 _.3))) (num _.10 _.11 _.12 _.5 _.6 _.7 _.8) (sym _.0 _.1 _.2 _.3)) (((set! _.0 '_.1) ((_.2 _.3 _.4 _.0 . _.5) (_.6 _.7 _.8 _.9 . _.10)) (_.11 _.12) (empty-k) void) (=/= ((_.0 _.2)) ((_.0 _.3)) ((_.0 _.4)) ((_.0 quote)) ((_.0 set!)) ((_.2 quote)) ((_.2 set!)) ((_.3 quote)) ((_.3 set!)) ((_.4 quote)) ((_.4 set!))) (num _.6 _.7 _.8 _.9) (sym _.0 _.2 _.3 _.4) (absento (closure _.1) '_.5 (set! _.5) (void _.1))) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.2 . _.15) (_.16 _.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 . _.28)) (empty-k) _.27) (=/= ((_.10 _.2)) ((_.11 _.2)) ((_.12 _.2)) ((_.13 _.2)) ((_.14 _.2)) ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8)) ((_.2 _.9))) (num _.10 _.11 _.12 _.13 _.14 _.2 _.4 _.5 _.6 _.7 _.8 _.9) (sym _.0)) ((_.0 ((_.1 _.0 . _.2) (_.3 _.4 . _.5)) ((_.6 _.7 _.8 _.9 _.10 _.4 . _.11) (_.12 _.13 _.14 _.15 _.16 _.17 . _.18)) (empty-k) _.17) (=/= ((_.0 _.1)) ((_.10 _.4)) ((_.4 _.6)) ((_.4 _.7)) ((_.4 _.8)) ((_.4 _.9))) (num _.10 _.3 _.4 _.6 _.7 _.8 _.9) (sym _.0 _.1)) ((_.0 ((_.0 . _.1) (_.2 . _.3)) ((_.4 _.5 _.6 _.7 _.8 _.9 _.10 _.11 _.12 _.13 _.14 _.15 _.2 . _.16) (_.17 _.18 _.19 _.20 _.21 _.22 _.23 _.24 _.25 _.26 _.27 _.28 _.29 . _.30)) (empty-k) _.29) (=/= ((_.10 _.2)) ((_.11 _.2)) ((_.12 _.2)) ((_.13 _.2)) ((_.14 _.2)) ((_.15 _.2)) ((_.2 _.4)) ((_.2 _.5)) ((_.2 _.6)) ((_.2 _.7)) ((_.2 _.8)) ((_.2 _.9))) (num _.10 _.11 _.12 _.13 _.14 _.15 _.2 _.4 _.5 _.6 _.7 _.8 _.9) (sym _.0))))

 (test "cesk-quinec-bkwards-c"
   (run 10 (q)
     (evalo q quinec))
   '('((lambda (x) (list x (list 'quote x)))
     '(lambda (x) (list x (list 'quote x))))
   (list
     '(lambda (x) (list x (list 'quote x)))
     ''(lambda (x) (list x (list 'quote x))))
   (((lambda (_.0)
       '((lambda (x) (list x (list 'quote x)))
          '(lambda (x) (list x (list 'quote x)))))
      '_.1)
     (=/= ((_.0 quote)))
     (sym _.0)
     (absento (closure _.1) (void _.1)))
   (((lambda (_.0) _.0)
      '((lambda (x) (list x (list 'quote x)))
         '(lambda (x) (list x (list 'quote x)))))
     (sym _.0))
   (((lambda (_.0)
       '((lambda (x) (list x (list 'quote x)))
          '(lambda (x) (list x (list 'quote x)))))
      (lambda (_.1) _.2))
     (=/= ((_.0 quote)))
     (sym _.0 _.1))
   (list
     '(lambda (x) (list x (list 'quote x)))
     (list 'quote '(lambda (x) (list x (list 'quote x)))))
   (((lambda (_.0)
       (list
         '(lambda (x) (list x (list 'quote x)))
         ''(lambda (x) (list x (list 'quote x)))))
      '_.1)
     (=/= ((_.0 list)) ((_.0 quote)))
     (sym _.0)
     (absento (closure _.1) (void _.1)))
   (((lambda (_.0)
       ((lambda (_.1)
          '((lambda (x) (list x (list 'quote x)))
             '(lambda (x) (list x (list 'quote x)))))
         '_.2))
      '_.3)
     (=/= ((_.0 lambda)) ((_.0 quote)) ((_.1 quote)))
     (sym _.0 _.1)
     (absento (closure _.2) (closure _.3) (void _.2) (void _.3)))
   ((list
      '(lambda (x) (list x (list 'quote x)))
      ((lambda (_.0) ''(lambda (x) (list x (list 'quote x))))
        '_.1))
     (=/= ((_.0 quote)))
     (sym _.0)
     (absento (closure _.1) (void _.1)))
   (((lambda (_.0)
       '((lambda (x) (list x (list 'quote x)))
          '(lambda (x) (list x (list 'quote x)))))
      (list))
     (=/= ((_.0 quote)))
     (sym _.0))))

 (test "cesk-quinec-for-real"
   (run 1 (q)
     (evalo q q))
   '((((lambda (_.0) (list _.0 (list 'quote _.0)))
       '(lambda (_.0) (list _.0 (list 'quote _.0))))
      (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)) ((_.0 void)))
      (sym _.0))))

 (test "cesk-hard-quinec-bkwards-b"
   (run 1 (q)
     (evalo q quinec)
     (== quinec q))
   `(,quinec))

 (test "twines"
   (run 1 (r)
     (fresh (p q)
       (=/= p q)
       (evalo p q)
       (evalo q p)
       (== `(,p ,q) r)))
   '((('((lambda (_.0)
           (list 'quote (list _.0 (list 'quote _.0))))
         '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0)))))
       ((lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))
        '(lambda (_.0) (list 'quote (list _.0 (list 'quote _.0))))))
      (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)) ((_.0 void)))
      (sym _.0))))

 (test "cesk-quinec-for-real-3"
   (run 3 (q)
     (evalo q q))
   '((((lambda (_.0) (list _.0 (list 'quote _.0))) '(lambda (_.0) (list _.0 (list 'quote _.0)))) (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)) ((_.0 void))) (sym _.0))
     (((lambda (_.0) (list _.0 (list ((lambda (_.1) 'quote) '_.2) _.0))) '(lambda (_.0) (list _.0 (list ((lambda (_.1) 'quote) '_.2) _.0)))) (=/= ((_.0 closure)) ((_.0 lambda)) ((_.0 list)) ((_.0 quote)) ((_.0 void)) ((_.1 closure)) ((_.1 quote)) ((_.1 void))) (sym _.0 _.1) (absento (closure _.2) (void _.2)))
     (((lambda (_.0) (list _.0 ((lambda (_.1) (list 'quote _.0)) '_.2))) '(lambda (_.0) (list _.0 ((lambda (_.1) (list 'quote _.0)) '_.2)))) (=/= ((_.0 _.1)) ((_.0 closure)) ((_.0 lambda)) ((_.0 list)) ((_.0 quote)) ((_.0 void)) ((_.1 closure)) ((_.1 list)) ((_.1 quote)) ((_.1 void))) (sym _.0 _.1) (absento (closure _.2) (void _.2)))))

 #!eof

 ;;; comes back under full chez in about 48 seconds
 ;;; would probably be waiting at least 3x as long under petite, if it doesn't run out of memory.
 (test "thrine"
   (run 1 (x)
     (fresh (p q r)
       (=/= p q)
       (=/= q r)
       (=/= r p)
       (evalo p q)
       (evalo q r)
       (evalo r p)
       (== `(,p ,q ,r) x)))
   '(((''((lambda (_.0) (list 'quote (list 'quote (list _.0 (list 'quote _.0))))) '(lambda (_.0) (list 'quote (list 'quote (list _.0 (list 'quote _.0))))))
       '((lambda (_.0) (list 'quote (list 'quote (list _.0 (list 'quote _.0))))) '(lambda (_.0) (list 'quote (list 'quote (list _.0 (list 'quote _.0))))))
       ((lambda (_.0) (list 'quote (list 'quote (list _.0 (list 'quote _.0))))) '(lambda (_.0) (list 'quote (list 'quote (list _.0 (list 'quote _.0)))))))
      (=/= ((_.0 closure)) ((_.0 list)) ((_.0 quote)) ((_.0 void)))
      (sym _.0))))

;;; took eight minutes to find this under full chez with optimize-level 3 on casper (with only set! added to the quines language, not call/cc)
 (test "quine-with-set!"
   (run 1 (q)
     (evalo q q)
     (fails-unless-contains q 'set!))
   '((((lambda (_.0)
         (list
          _.0
          (list ((lambda (_.1) 'quote) (set! _.0 _.0)) _.0)))
       '(lambda (_.0)
          (list
           _.0
           (list ((lambda (_.1) 'quote) (set! _.0 _.0)) _.0))))
      (=/= ((_.0 closure)) ((_.0 lambda)) ((_.0 list)) ((_.0 quote))
           ((_.0 set!)) ((_.0 void)) ((_.1 closure)) ((_.1 quote))
           ((_.1 void)))
      (sym _.0 _.1))))
