# c-sig users guide (release 3.8  date 1999/06/10)

## INDEX

1. What is c-sig?
2. How to install.
3. How to use.
    1. How to use insert-signature-eref
    2. Learning signatures
    3. Searching signature using regular expression
    4. How c-sig select default signature?
    5. Convert string in signature
4. Functions users can .
5. Variables users can change.
6. Functions users can write.
7. About distribution.
8. Afterword

## What is c-sig?

What is c-sig. In the beginning, it was just a tool for inputing a
signature to mails or news. After adding many features requested my
friends, now I guess c-sig is _ultra super deluxe sigature insertion
tool_.

OK, let me explain how c-sig is ultra super deluxe.

* Easy to create signatures.

    c-sig has function for generating a new signature called
    `add-signature` and function for deleting them called
    `delete-signature`. Users can create signatures interactively
    using these two functions. Also, "add-signature" can inport
    existing signatures while writing a new signature.

* Three insertion functions.

    Now c-sig has 3 insertion function. `insert-signature-eref` has
    dialog interface for selecting a
    signature. `insert-signature-automatically` selects and insert a
    signature using database. `insert-signature-randomly` insert a
    signature randomly.

* Powerful retrieval and learning function.

    c-sig has the function which selects a signature refering specific
    field using _reguler expression_ Also, c-sig has the function
    which learns selected a signature, so users can use _wise
    selection function_ without writting _reguler expression_.

* c-sig can convert text automatically when insertion.

    c-sig can convert texts in your signatures when it selected. This
    function support random selection from list. This should be useful
    when users want to write "my favorit word" in their signatures.

* signatures can be modified by emacs lisp.

    If users want to modify a signature in more complex way than
    random selection. They can do it by writing filter function with
    emacs lisp. Using this function, users can call outer program
    also. So they can do almost every thing the computer can do, when
    they insert a signature.

Now, do you agree c-sig is ultra super deluxe?  
No? c-sig doesn't have something you want to use?  
OK, please let me know what kind of feature you want (using simple and
easy English.)

## How to install

At first, add following statements to set up `autoload`. You don't
need all of last 3, if you don't use them.  
You may add two more function `write-sig-file` and `read-sig-file`,
if you want to use them.

```
(autoload 'add-signature "c-sig" "c-sig" t)
(autoload 'delete-signature "c-sig" "c-sig" t)
(autoload 'insert-signature-eref "c-sig" "c-sig" t)
(autoload 'insert-signature-automatically "c-sig" "c-sig" t)
(autoload 'insert-signature-randomly "c-sig" "c-sig" t)
```

If you don't mind to type `M-x insert-signature-XXXX` everytime you
want to insert a signature. These are enough.  
But you must want to bind c-sig function to keys, right?__
You can use `global-set-key` to do this, but it's not beautiful. It
should be better way to use `local-set-key` in proper
_hook_. (`mh-letter-mode-hook` for mh-e, `mail-mode-hook` for rmail
and `news-setup-hook` for gnus)__
If you can not understand what _local-set-key_ or _hook_ means, don't
mind. Please ask anyone who is using same emacs tools with you. As
always, this must be best way for those who don't know emacs lisp.  

To gnus users, gnus automatically insert a signature using
`.signature` or `.signature-*`. If you want stop this, set `nil` to
`gnus-signature-file`.  
But you should remove all existing `.signature` or `.signature-*,` I
think. Now you have c-sig and c-sig can do anything without them.

If you want to use function which use randomness, you may need to add
`(random t)` to `~/.emacs` or you may get everytime a same signature
even you are using random function. (Newer emacs may not use this, I
am not sure.)

## How to use.

### How to use insert-signature-eref

_`insert-signature-eref`_ is a function to insert a signature
  interactively. When you call this funcction, buffer `*sig-buffer*`
  appears and a default signature is displayed there. (I will explain
  how to decide a default signature later.)

Key assign in `*sig-buffer*`

```
p	Display a previous signature
P	Display a previous signature
n	Display a next signature
N	Display a next signature
q	Quit inserting a signature
Q	Quit inserting a signature
RET	Insert a signature currently displayed
x	Insert a signature currently displayed
X	Insert a signature currently displayed
```

When you call `insert-signature-eref` with argument (for example, `C-u
M-x insert-signature-eref`, or `C-u <assinged key>`), the signature
you selected will be moved to a top of signature list. Doing this
sometimes, you can change order of singatures in signature list.

### Learning signatures

When you select non default signature using `insert-signature-eref`
and the valule of `sig-save-to-sig-name-alist` is non-nil, c-sig
learns the relation of the signature and the mail address (or
newsgroup name) to chose the signature as default from next time.
When you chose a new signature, the message "Regster this signature
for XXXXXX ? (y or n) " in mini buffer. If you type "y", this relation
is saved to learning database. (or modifies entry already existing.)

### Searching signature using regular expression

Setting data to the variable `sig-regexp-alist`, you can find
signature using regular expression.

Format of `sig-regexp-alist` is like this. (Even the name of the
variable contains "alist", it is not alist)

```
((<Field name>
  (<Regular expression> . <signature name>)
   ...
  (<Regular expression> . <signature name>))
   ...
 (<Field name>
  (<Regular expression> . <signature name>)
   ...
  (<Regular expression> . <signature name>)))
```

Usually, you will set "To" or "Newsgroups" to `<Field name>`. (Off
cause, you can use other fields, but I am not sure it is useful.)  
C-sig recognize string in the field as address or newsgroup name, and
try to separate it using "," as separator.
C-sig does matching as the order of the list, so you need to set the
variable carefully. In general, it should be detail address first, and
vague address last.

Ex) If you want to set `jp$` and `foo.bar.jp$`, you need to
`foo.bar.jp$` first or `jp$` matches faster than `foo.bar.jp$`.


`sig-regexp-alist` is saved in `~/.signature.alist`, but running emacs
  may also have it in memory. So, when you want to modify it, you
  should run `write-sig-file` to refresh the file.  
And don't forget to run `read-sig-file` after modifying it.

### How c-sig select a default signature?

C-sig calls functions in list `sig-search-functions` when it select
a default signature.__
As default, is is "search using learning database" -> "search using
reguler expression" -> "the signature defined in "sig-default-name".  
Searching from learning dabase is like this.  
c-sig have a list of signatures name and mail address (or news group
name) (usually, it is added by `insert-signature-eref` when you
selected non default signature. )  
c-sig cuts mail address or newsgroup name from "To" or "Newsgroup"
fileld, and search it from this database.  
If you find it, return the signature name to finish searching.  
When c-sig can not find mail address or newsgroup name in learning
database, c-sig will check reguler expression database secondly. This
dababase have information which header should be checked, so c-sig
check the header only.  

As a sample example function for "sig-search-functions", I put
`sig-get-random-signature` into c-sig package. If you add it to the
end of `sig-search-functions`, searching order is "search using
learning database" -> "search using reguler expression" -> "get a
randome signature".  
So, when c-sig find no information for a default signature in both
learning database or reguler expression database, c-sig will use a
random signature.  
  When you want to use a random signature for specific persons, See
section C-1 in `c-sig-eng.faq`.

### Convert string in signatures

For example, anyone who changes company offten need to change their
signatures so offen and this must be really tough job. (I am not
talking about me.)  
c-sig have a feature for these kind of ..... special ..... people.  
You can write any string like `%%my-address%%` or `<<my-shozoku>>`
in stead of your address and c-sig changes it to your really address.  
This converion is disabled as default. To enable this, add following
statement tot `~/.emacs`.

```
(setq sig-replace-string t)
```

Conversion table is `sig-replace-list` in `~/.signature.replace`
(You can change the name of the file using `sig-replace-string-file`.)  
`sig-replace-list` is like this.

```
(
 (<Original String> (<New String>
                     <New String>
					  ...
					 <New String>))
 (<Original String> (<New String>
                     <New String>
					 ...
					 <New String>))
 ...
 )
```

  If you specify some strings as targets, one of them is randomly
selected.  
  This is example of `sig-replace-list`. 

```
(setq sig-replace-list '(
                         ("%%my-address%%" 
						  ("kshibata@tky.3web.ne.jp"))
						 ("<<kotowaza>>" 
						  ("Cast not pearls before swine"
						   "Cast not golds before cat (japanese proverb)"
						   "Cast not c-sig before vi users"))
						 ))
```

Attention: `insert-signature-eref` convert strings when it insert a
  signature. (not when a default signature is displayed.) 

By the way, don't you wan to use specific rules instead of randomness?
I know, I know, I got a lot of requests like that.  
Yes, I have already add the feature already. Just write function name
instead of a name of list.
  
```
(setq sig-replace-list '(
                         ("%%my-address%%" 
						  ("kshibata@tky.3web.ne.jp"))
						 ("<<kotowaza>>" 
						  ("Cast not pearls before swine"
						   "Cast not golds before cat (japanese proverb)"
						   "Cast not c-sig before vi users"))
						 ("**shiteru-koto**" 
						  shiteru-koto
						  )))
```

By this setting, `**shiteru-koto**` in your signature will converted
to return value of function `shiteru-koto`. (This means return value
of "shiteru-koto" must be in string.)  
Example of `shiteru-koto` is like this.

```
(defun shiteru-koto ()
  (let
      ((wtime (string-to-number (substring (current-time-string) 11 13))))
    (cond
     ((< wtime 9) "I am Sleeping.")
     ((< wtime 12) "I am reading mails.")
     ((< wtime 13) "I am eating lanch.")
     ((< wtime 17) "I am reading news.")
     (t "I am playing games."))))
```

Using same manner, you can make a signature depending day of the
week or month.

## Functions users can use.

* `insert-signature-eref`

    Using this function, but users can select a signature by
	themselves.  
	When a default signature is displayed, use "n" or "p"
	to select an other signature, "ret" to decide and "q" to
	cancel. c-sig can learn retationship of a signature and an address
	(or news group name), if you want.

* `insert-signature-randomly`

    Select and insert signauture randomly.

* `insert-signature-automatically`

    Select a signature automatically and insert it.  
    A default signature for "insert-signature-eref" is inserted.

* `add-signature`

    Create a new signature.  
	When you call this function, editor screen comes up.  
	After writing a signature, typing C-c C-c will ask you the name of
	the signature. If you specify it, signature will be registed. If
	you want to cancel, type C-c C-q. You can also type C-c C-i to
	import existing signatures.

* `delete-signature`

    Delete unnecessary signatures.  
	When use call delete-signature, selection screen appears. "n" or
    "p" to selecte a signature. "ret" to decide and "q" to
    quit. Confirmation message will appear when you type "ret" and "y"
    to remove it.

* `sig-purge-void-lines`

    Remove blank lines at the end of the mail and new line code ("\n")
	at the end of the mail if it doesn't exist.  
	If sig-purge has non-nil value, insert-signature-* call this
	function automatically, so c-sig users doesn't need to use this
	function directly.  
	I made this function public for users who don't like these blank
    line but don't want to use c-sig and don't know emacs lisp well.

* `read-sig-file`

    Read signature database from files. When use modified signature
    database in files using editor, please call this function.

* `write-sig-file`

    Write signature database if necessary. When you want to modify
    singature database using editor, please call this function.

## Variables users can change.

* `sig-replace-string`

    If non-nil (t for example), replace using sig-replace-list is
	activated.  
	Default value is nil.

* `sig-insert-end`

    If non-nil, c-sig insert a signature at the end of mail (like
	rmail.)  
	If nil, c-sig insert a signature just before current line. (not
	current position.)  
	Default value is nil

* `sig-purge`

    If non-nil, blank lines at the end of mail are removed before
	inserting a signature, and if there is no New line code ("\n") at
	the end of mail, it is inserted.  
	If value of this variable is string, it will be inserted at the
	end of mail.  
	Default value is t.

* `sig-separator`

    `sig-separator` will be inserted just before the signature you
	chose.  
	If you want to add one null line and "--" before the signature,
	please set "\n--\n". (need "\n" at the end, if you want new line.)  
	Default value is nil.

* `sig-save-to-sig-name-alist`

    If non-nil, c-sig saves selected a signature to database relating
	mail address or newsgroup name.  
	When you select non default signature, you will asked "save this
	relation to database?" and if you answer "Yes", it will be saved.  
	Default value is t.

* `sig-default-name`

    Name of a default signature.  
	When c-sig can not find a signature from database, c-sig select
    this signature.  
	If nil, c-sig select the top signature in list.  
	Default value is nil.

* `sig-save-file-every-change`

    If non-nil, c-sig saves all information everytime database is
	changed. (If nil, save only on exiting emacs)  
	Default is t. (I suggest  not to change this.)

* `sig-make-backup-files`

    If non nil, c-sig make backup file when it saves database. (c-sig
	doesn't refer make-backup-files.)  
	Default value is t.

* `sig-end-of-headers`

    Regular expression to look for the end of headers.  
	If you are using special mailer, you may need to change this.  
	Default value is "^$\\|^--".

* `sig-search-functions`

    List of functions to retrieve a signature.  
	Default value is `(list 'sig-search-name-alist 'sig-search-regexp)`.  
	This means "search address name from database first and search
	reguler expression database second.  
	If you add 'sig-get-random-signature to the end of the list, c-sig
    select arandom signature when it can not find signature using
    above two function.

* `sig-random-sig-list`

    List of signatures which can be selected randomly.  
    `insert-signature-randomly` and `sig-get-random-signature` select
	a signature randomly from all signature you have, but if you set
	list of signatures to "sig-random-sig-list", these function choses
	a signature from the list.  
	Default value is nil.

* `sig-alist-file`

    File name for alist database.  
	Default value is `~/.signature.alist`.

* `sig-replace-string-file`

    File name for replace strings.  
	Default value is `~/.signature.replace`.


* `sig-regexp-alist`

    Database for reguler expression, which is saved to
    `~/.signature.alist`.  
	Example of setting.

```
(setq sig-regexp-alist 
      '(("To"
	 ("jp$" . "Japanese")
	 ("com$" . "English"))
	("Newsgroups"
	 ("^fj" . "japanese")
	 ("^comp" . "English"))))
```

## Functions users can write.


* `sig-filter-function`

    When this function is defined, c-sig calls this function with
    setting the signature as argument, and insert return value as the
    signature. This function is not defined as default.  
	I implemented this function in order to change some part of a
	signature randomly, but I add new function for this perpose. So I
	guess only a few people will use this function.  
	If you are a kind a guru and want to use a special signature which
    contains output of extra outer command (or a more complexed
    signature), this function may be useful.  

Example of `sig-filter-function`

Using this function, %name% in the signature will be changed to "MY
NAME" and %title% will be changed to "MY TITLE".

```
(defun   sig-filter-function (sig)
  (let ((work)
	(buffer (get-buffer-create "*temp buffer*")))
    (save-excursion
      (set-buffer buffer)
      (erase-buffer)
      (insert-string sig)
      (goto-char (point-min))
      (replace-string "%name%" "MY NAME")
      (goto-char (point-min))
      (replace-string "%title%" "MY TITLE")
      (setq work (buffer-substring (point-min) (point-max)))
      (kill-buffer buffer)
      work)))
```

Since c-sig already has this function, this function is not worth to
use. (sorry for this bad example)

## About distribution.

  You must know about GNU General Public License very well, right?
  If no or only a little, pelase read it. It's very very exciting
document. I guarantee.


## Afterword

Long time ago, far far away, yes, actually it's in far east. there
lived a young guy who joined many mailing list and read many internet
news.  
He thought he wanted to use specific signatures to specific ML or
news group and started writing a little emacas function only for his
own use.  
But he made a big big mistake. Accidentally, he talked about his
tool at the offline meeting of a ML he joined. He didn't realize, but
every other ML member also awaited this kind of tool.  
He forced to release his tool in the ML and to add new features
requested form the members.

Yes, this is a really begining of c-sig.  
Was this story interesting? Actually, I don't.  
Anyway you have c-sig now and I hope you like it. But be aware,
don't spend to much time for creating a new signatures. That's a
really really bad manner. I know it very well.

Oh, I have one more thing. There is "c-sig official home page".  
http://www.threeweb.ad.jp/~kshibata/c-sig/english  
But this page is rarelly updated.  
Oh, I meant I would update offen this page from now on.

```
(defvar after-five-hook				;	    Ken Shibata
  '((lambda ()					;
      (while (<= (current-time) mid-night)	;    kshibata@tky.3web.ne.jp
	(drink beer)))))			;
```
