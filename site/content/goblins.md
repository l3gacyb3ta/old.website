---
title: "Spritely's Goblins and How They're Gonna Steal the Future"
permalink: "/goblins"
comments: "false"
code: "true"
postid: "goblins"
---

# Spritely's Goblins and How They're Gonna Steal the Future

So, the [Spritely Institute](https://spritely.institute/) has been working on
some very interesting tech in the distributed computing ^1 space.

I want to introduce y'all to goblins, so here's an intro through the writing of
a little program.

(Note, because I love to do this, if you just copy and paste the code as it is
presented in this article into a file, it should work with no modifications.
That being said, the whole source is linked at the bottom ;3 )

(Also, this post relies heavily on code, it might look bad on mobile)

## The intro

```lisp
#lang racket

(require goblins
         goblins/actor-lib/methods
         racket/struct)
```

Well, now that we've got what we need, let's write smth!

...

wait what are we going to write?  
A todo app of course!

```lisp
(define a-vat
  (make-vat))
```

Well that's not a todo app. It's goblins! In goblins, different objects need to
live in a vat. Objects in vats can interact with eachother synchronously
(through the `$` operator), or asynchronously (through the `<-` operator).
Objects in the same vat can be connected synchronously or asynchronously, whereas
objects in seperate vats have to be connected asynchronously.

Goblins is [capability-based](https://en.wikipedia.org/wiki/Capability-based_security)
, which means that we define what the program can do with data, rather than just
what the data can do.

Capability-Based Security follows the priniciple of least authority:

> The Principle of Least Authority (POLA) says that code should be granted only
> the authority it needs to perform its task and no more.
> Code has a lot of power. Code can read your files, encrypt your files,
> delete your files, send your files (and all of the information within them) to
> someone else, record your keystrokes, use your laptop camera, steal your
> identity, hold your computer for ransom, steal your cryptocurrency, drain your
> bank account, and more. But most of the code that we write doesn't need to do
> any of those things – so why do we give it the authority to do so?  
> POLA is ultimately about eliminating both ambient and excess authority.
> It's not a motto that is meant to be inspirational;
> POLA can actually be achieved. But how?

– Kate Sills, [POLA Would Have Prevented the Event-Stream Incident](https://medium.com/agoric/pola-would-have-prevented-the-event-stream-incident-45653ecbda99)

The official Goblins spec has a great [explination](https://spritely.institute/static/papers/spritely-core.html#caps-as-programming)
of this system.

Back to the code!

Let's make a function that will give us the capabilites to edit and read a list
of todos!

```lisp
(define (spawn-todo-reader-and-writer)
  (define todos (spawn ^cell '())) ;; Here's a big list of all the todos. Note that I can't actually get at this from the normal environment.

  (struct todo (id value completed) ;; We need todos to track some info, so here we have 3 fields: id (a number), value (the thing to do), and completed (a bool to track the status)!
    #:methods gen:custom-write
    [(define write-proc ;; Over here we'll write some racket to make pretty printing work.
       (make-constructor-style-printer
        (lambda (obj) 'todo)
        (lambda (obj) (list (todo-id obj) (todo-value obj) (todo-completed obj)))
        )
       )
     ]
    )
  
  (define counter (spawn ^cell 0)) ;; I don't want todos to have the same index, so let's make a counter!
```

So now we've got all the data storage of the todo list. Let's write some capabilities!

First, let's think about what we need to be able to do with a todo list:

1. Read them, so we can check what we've done
2. Write them, so we can update them and add new ones!

Ok. Reading seems simpler, so let's write a reader.

```lisp
(define (^reader _bcom) ;; A reader can read all the todos, just like we want.
  (methods
    [ (read-todos) ($ todos) ] ;; Because `todos` is an object, we need to tell the computer we're acting on it! (the `$` operation from earlier)
    )
  )
```

And that's it! That was supprisingly simple.
One thing I don't go through here is the `bcom` (become) mechanism.
It basically allows goblins objects to mutate themselves by "becomeing" a new version!

Here's a cool little demo from the docs (written in [wisp](https://www.draketo.de/software/wisp))

```wisp
define (^cell bcom val)
  methods            ; syntax for first-argument-symbol-based dispatch
    (get)            ; takes no arguments
      . val          ; returns current value
    (set new-val)    ; takes one argument, new-val
      bcom : ^cell bcom new-val  ; become a cell with the new value
```

Ok. Now that we've got the reader, let's write the editor! This will be a tad
more complex :3

```lisp
(define (^editor _bcom) ;; An editor can edit all the todos, because of course we need to be able to update them!
  (methods
    [(add-item valye) ;; Just slap a new todo onto there!
     (define old-todos ($ todos)) ;; Get the old values
     (define old-counter ($ counter)) ;; Get the old counter
     ($ counter (+ old-counter 1)) ;; Increment the counter
     ($ todos (append old-todos (list (todo (+ old-counter 1) value #f))))] ;; add the new todo
```

While the comments  are great (in my unbiased opinion /s), let's walk through that!

1. First we define a capability, in this case the editor.
2. `methods` will let us define a bunch of methods for the capability!
3. We create an add-item function
    - This takes in a value (the description)
    - It keeps copies of the old state
    - Update to the new state!

Ok, so it seems like we're forgetting something... oh right! We need to be able
to change the status of items.

Here is some pseudocode that describes how that works:

```python
def update(index, new completion):
    old-todos = current todos
    old-item = get index from old-todos

    set todos to old-todos where:
        the value at index is a todo item with:
          the same id
          the same name
          and the new completion value
```

and here we go in racket!

```lisp
[(update-item index new-completed) ;; this will set the todo list to a todo list with the newer value
  (define old-todos ($ todos))
  (define old-item (list-ref old-todos index))
  ($ todos (
            list-set old-todos index ;; Set the todo at the index that we want to update to...
                      (todo ;; a todo ...
                      (todo-id old-item) ;; with the same id ...
                      (todo-value old-item) ;; same value ...
                      new-completed) ;; and the new completion!
                      )
      )
]))
```

Now all we have to do is return it!

```lisp
  ;; Now that we have the actually buisness, we need ot actually give the end user something! So here we give ...
  (define editor (spawn ^editor)) ;; the capability to edit all the todos ...
  (define reader (spawn ^reader)) ;; and the capability to read the todos!

  (values editor reader)) ;; Then, return!
```


### Let's use it :3

To be able to interact with this, let's enter into the vat we created earlier!

```lisp
(a-vat 'run (lambda () 
```

Ok, now it's time to create our list!

```lisp
(define-values (todo-editor todo-reader) (spawn-todo-reader-and-writer))
```

Oh right! We don't actually get the list, we get a reader and an editor.

Let's add a couple of todos :3

```lisp
($ todo-editor 'add-item "finish code")
($ todo-editor 'add-item "write blog post")
($ todo-editor 'add-item "shop for groceries")
```

And now we wanna read what we've got so far!

```lisp
(println ( $ todo-reader 'read-todos ))
;; $- '(#<todo: 1 "finish code" #f> #<todo: 2 "write blog post" #f> #<todo: 3 "shop for groceries" #f>)
```

Wow, it's working :3

A bit later... and we've finished the blog post!

```lisp
($ todo-editor 'update-item 1 #t) ;; (Don't forget to index from 0!)
(println ( $ todo-reader 'read-todos ))
;; $- '(#<todo: 1 "finish code" #f> #<todo: 2 "write blog post" #f> #<todo: 3 "shop for groceries" #t>)
```
Great :3

Well hm. We've got a problem! I want my partner to be able to update a specific
task, but I don't want them to accidentally overwrite all my other todos!
We should write some code to fix this :3

```lisp
(define (spawn-editor-for-one-item index editor) ;; So we need an editor for one thing, that means that we need to have an editor that can edit that one thing to start with! as well as the thing we want to edit.
  (define (^single-editor _bcom index) ;; here's that editor, we don't need to be able to spawn it outside this function, so we'll define it here.
    (methods
    [(update-item value) ;; all it needs to be able to do is update one thing
      ($ editor 'update-item index value) ;; index is hard-coded into this call! that means that my partner can't just edit anything.
      ]
    )
    )

  (define s-editor (spawn ^single-editor index)) ;; create the new editor
  (values s-editor) ;; and give it back!
  )
```

This is the magic of capabilities. Just by writing some code, we can make it so
that all you need to create new behavior is existing behaviour!

Let's give my partner this ability using this new restricted editor.

```lisp
(define-values (grocery-editor-for-partner) (spawn-editor-for-one-item 2 todo-editor))
```

Look! they can edit index number two only.

Theoretically, we could have now sent that capability over the network
(I'm not going to write netcode yet).

#### On their computer after shopping

```lisp
($ grocery-editor-for-partner 'update-item #t)
```

And it works!

#### Back at home

```lisp
(println ( $ todo-reader 'read-todos ))))
;; '(#<todo: 1 "finish code" #f> #<todo: 2 "write blog post" #f> #<todo: 3 "shop for groceries" #t>)
```

Oh perfect! They finished the shopping. :3

## The end!

Thank you so much for reading, if you have any index, just send me some feedback!
My contact info is on my [index](/) page

## All of the code

[Here it is](https://paste.sr.ht/~arcade/bd22683e8a1c082e811fca173a2546ba017fcb40)
in case you want to run it yourself!

## Thanks sm :3

This was all introduced to me by Christine Lemmer-Webber
(Here's her introduction, she's awesome!)
[](mastodon:octodon.social/109388563865627081)

^1: The part of computer science dealing with systems of computers that are
heterogynous, that is to say, they are made of many different, seperate parts
that all have to work together.
