#!/usr/bin/perl
#==============================================================================#
#                                                                              #
# Copyright 2011 Carlos Alberto da Costa Filho                                 #
#                                                                              #
# This program is free software: you can redistribute it and/or modify         #
# it under the terms of the GNU General Public License as published by         #
# the Free Software Foundation, either version 3 of the License, or            #
# (at your option) any later version.                                          #
#                                                                              #
# This program is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                 #
# GNU General Public License for more details.                                 #
#                                                                              #
# You should have received a copy of the GNU General Public License            #
# along with this program. If not, see <http://www.gnu.org/licenses/>.         #
#                                                                              #
#==============================================================================#
#                                                                              #
#         FILE:  generate_mask.pl                                              #
#                                                                              #
#        USAGE:  ./generate_mask.pl INPUT_PDF INPUT_MASK                       #
#                                                                              #
#  DESCRIPTION:  This script edits the default mask contained in file          #
#                INPUT_PDF_mask.tex to fit the INPUT_PDF. Optionally, a        #
#                custom mask can be used.                                      #
#                Once the notes are added to the mask, the user must run       #
#                         ./annotate_pdf.pl INPUT_PDF [INPUT_MASK]             #
#                in order to effectively stamp the pdf with the notes.         #
#                                                                              #
#      OPTIONS:  ---                                                           #
# REQUIREMENTS:  pdftk, pdfinfo                                                #
#         BUGS:  ---                                                           #
#        NOTES:  ---                                                           #
#       AUTHOR:  Carlos Alberto da Costa Filho                                 #
#      COMPANY:                                                                #
#      VERSION:  0.1                                                           #
#      CREATED:  08/03/2011 08:04:44 PM                                        #
#     REVISION:  ---                                                           #
#==============================================================================#

#use 5.010;
use strict;
use warnings;
use File::Spec;
use File::Copy;

# Preliminary hash for paper sizes. Incomplete.
my %paper_sizes;
$paper_sizes{"letter"} = "letterpaper";
$paper_sizes{"A4"} = "a4paper";


# File names
my $file = $ARGV[0];
die "No PDF given." unless ($file);
die "PDF does not exist." unless (-e $file);

my $mask = $ARGV[1];
die "No mask given." unless ($mask);
die "Mask does not exist." unless (-e $mask);

my $file_dir = dirname($file);
my $script_dir = dirname($0);

# Page numbers
my $pages_data;
if ($^O =~ m/win/i){
    chomp($pages_data = `pdftk $file dump_data`);
} else {
    chomp($pages_data = `pdftk '$file' dump_data`);
}
$pages_data =~ /NumberOfPages:\s*(\d+)/;
my $pages = $1;

# Page size
my $size_data;
if ($^O =~ m/win/i){
    chomp($size_data = `pdfinfo $file`);
} else {
    chomp($size_data = `pdfinfo '$file'`);
}
# The numbers are (?<width>\d+(\.\d+) and the paper size is (?<paper>\w+)
$size_data =~ /Page \s size: \s+ (?<width>\d+(\.\d+)?) \s x \s (?<len>\d+(\.\d+)?) \s pts \s+ ( \( (?<paper>\w+) \) )?/x;

my $width = $+{width};
my $len = $+{len};

my $paper;
$paper = $+{paper} if $+{paper};
my $doc_opts;
if ($paper_sizes{$paper}){
    $doc_opts = "\[$paper_sizes{$paper}\]";
} else {
    $doc_opts = "";
}

print "\nUpdating dimensions in $mask.\n";
open MASK_IN, '<', $mask or die "Cannot open $mask.";
my @mask_in = <MASK_IN>;
close MASK_IN;

open(MASK_OUT, '>', $mask) or die "Cannot open $mask.";

for (@mask_in){
    s/numberofpages\}\{\d*}/numberofpages\}\{$pages\}/g;
    s/pagewidth\}\{.*}/pagewidth\}\{$width\}/g;
    s/pagelength\}\{.*}/pagelength\}\{$len\}/;
    s/documentclass(\[?.*\]?){/documentclass$doc_opts\{/;
    print MASK_OUT $_;
}
close MASK_OUT;
print "Done.\n";
