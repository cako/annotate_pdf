README
======

Introduction
------------

Annotating PDF files is hard. There are a few
options, but none of them are good enough for the
technically inclined. Most PDF annotators use either
ASCII text or free form tools.

The question arises: How does one annotate a PDF
with LaTeX notation. The answer is, you simply
don't.

This little script might be the beginning of a
positive answer. The idea of the solution is to
create another PDF with the annotations, then
"stamp" it on the original PDF one needs to
annotate.

The manual process was first described on [this
blog](http://3diagramsperpage.wordpress.com/2011/07/29/mathematical-annotations-in-pdf-documents/).
After the author contacted me, I took it upon myself
to automate the process a bit, and the result are
these two perl scripts. Hopefully, I won't stop
here, and will find even better ways to quickly
annotate PDFs.

Requirements
------------
* perl
* pdftk
* pdfinfo
* pdflatex

Instructions
------------

You will need a mask file, which will be used to
stamp the PDF. Hopefully in the near future I'll be
able to provide a mask that I've been using. For
now, one can obtain it
[here](http://3diagramsperpage.files.wordpress.com/2011/07/mask.doc).
(For some reason the author has to provide it in
`.doc`, so open it and save its contents as a `.tex`).

Then simply run
    
    perl annotate_pdf.pl INPUT_PDF INPUT_MASK

This will generate a file with `_annotated` appended
to the filename of `INPUT_PDF`. You are done!

### Options

If, for some reason, your mask it too complicated to
be rendered by a simple `pdflatex` compilation, you
can run

    perl generate_mask.pl INPUT_PDF INPUT_MASK

compile the `.tex` using whatever method want, and then
run

    perl -n annotate_pdf.pl INPUT_PDF INPUT_MASK

Finally, one may simply omit the mask if it's named
`INPUT_PDF` with `_mask` appended, or if it's named
`default_mask.tex`.

Please Contribute!
------------------
