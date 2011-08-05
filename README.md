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
* [perl](http://www.perl.org/get.html)
* [pdftk](http://www.pdflabs.com/docs/install-pdftk/)
* [pdfinfo](http://www.foolabs.com/xpdf/) (Part of the xpdf utilities for PDF files)
* pdflatex

Installation
------------
The tricky part here is the installation of the requirements, and not the program itself.

### Ubuntu

    sudo apt-get install perl pdftk poppler-utils texlive

### Windows

    Download Strawberry Perl [here](http://strawberryperl.com/) and install it.
    Download `pdftk` [here](http://strawberryperl.com/). To install it, copy
    the two files (a `.exe` and a `.dll`) to the
    `C:\WINDOWS\system32\` folder.
    Download `pdfinfo` from
    [here](http://www.foolabs.com/xpdf/download.html),
    and copy `pdfinfo.exe` to the `C:\WINDOWS\system32\` folder.
    Finally, install a LaTeX distribution such as
    [Miktex](http://miktex.org/2.9/setup) if you
    don't already have one.
    
Instructions
------------

You will need a mask file, which will be used to
stamp the PDF. The default mask is
`default_mask.tex`. Edit it with your notes and
save it to file `INPUT_MASK`.

Then simply run
    
    perl annotate_pdf.pl INPUT_PDF INPUT_MASK

This will generate a file with `_annotated` appended
to the filename of `INPUT_PDF`. You are done!

### Options

If you want the leftover files from the pdflatex
compilation run with option -a. 

If, for some reason, your mask it too complicated to
be rendered by a simple `pdflatex` compilation, you
can run

    perl generate_mask.pl INPUT_PDF INPUT_MASK

then compile the `.tex` using whatever method want,
and finally run

    perl -n annotate_pdf.pl INPUT_PDF INPUT_MASK

Please Contribute!
------------------
