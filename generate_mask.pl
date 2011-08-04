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
#        USAGE:  ./generate_mask.pl INPUT_PDF [INPUT_MASK]                     #
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

use 5.010;
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
my $mask;
    if ($ARGV[1]){
    $mask = $ARGV[1];
} else {
    $file =~ /(.+)\.pdf/;
    $mask = $1 . "_mask.tex";
    my ($default_mask_vol, $default_mask_dir, undef) = File::Spec->splitpath($file);
    my $default_mask = File::Spec->catfile($default_mask_dir, "default_mask.tex");
    copy($default_mask, $mask) or die "Can't copy" unless (-e $mask);
}

# Page numbers
chomp(my $pages_data = `pdftk '$file' dump_data`);
$pages_data =~ /NumberOfPages:\s*(\d+)/;
my $pages = $1;
my $regex = 's/numberofpages}{\d*}/numberofpages}{'."$pages}/";
system "perl -pi -e '$regex' '$mask'";

# Page size
chomp(my $size_data = `pdfinfo '$file'`);
# The numbers are (?<width>\d+(\.\d+) and the paper size is (?<paper>\w+)
$size_data =~ /Page \s size: \s+ (?<width>\d+(\.\d+)?) \s x \s (?<len>\d+(\.\d+)?) \s pts \s+ ( \( (?<paper>\w+) \) )?/x;

my $width = $+{width};
my $len = $+{len};
my $paper;
$paper = $+{paper} if $+{paper};


$regex = 's/pagewidth}{.*}/pagewidth}{'."$width}/";
system "perl -pi -e '$regex' '$mask'";

$regex = 's/pagelength}{.*}/pagelength}{'."$len}/";
system "perl -pi -e '$regex' '$mask'";

if ($paper_sizes{$paper}){
    $regex = 's/documentclass(\[?.*\]?){/documentclass'."[$paper_sizes{$paper}]{/";
    system "perl -pi -e '$regex' '$mask'";
} else {
    $regex = 's/documentclass(\[?.*\]?){/documentclass{/';
    system "perl -pi -e '$regex' '$mask'";
}
