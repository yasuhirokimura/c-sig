EMACS?=		emacs
INSTALL?=	install
MKDIR?=		mkdir -p
RM?=		rm -f

PREFIX?=	$(shell $(EMACS) -Q --batch --eval \
		"(princ (expand-file-name \"../../../..\" data-directory))")
LISPDIR?=	${PREFIX}/share/emacs/site-lisp

TARGETS=	c-sig.el c-sig.elc

all: ${TARGETS}

c-sig.elc: c-sig.el
	${EMACS} -batch -q -f batch-byte-compile c-sig.el

install: ${TARGETS}
	${MKDIR} ${DESTDIR}${LISPDIR}
	${INSTALL} -p -m 0644 ${TARGETS} ${DESTDIR}${LISPDIR}

clean:
	${RM} c-sig.elc

