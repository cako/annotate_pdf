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
#         FILE:  annotate_pdf.pl                                               #
#                                                                              #
#        USAGE:  ./annotate_pdf.pl [-n] INPUT_PDF [INPUT_MASK]                 #
#                                                                              #
#  DESCRIPTION:  This script stamps the INPUT_PDF file with the notes          #
#                contained in the INPUT_MASK. If no mask is provided, the      #
#                default mask will be used.                                    #
#                                                                              #
#      OPTIONS:  -n                                                            #
# REQUIREMENTS:  pdftk, pdflatex                                               #
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

my $NO_COMPILE;
if ($ARGV[0] eq "-n"){
    $NO_COMPILE = 1;
    shift @ARGV;
}
# File names
my $file = $ARGV[0];
my ($file_vol, $file_dir, undef) = File::Spec->splitpath($file);
my $mask;
if ($ARGV[1]){
    $mask = $ARGV[1];
} else {
    $file =~ /(.+)\.pdf/;
    $mask = $1 . "_mask.tex";
    my $default_mask = File::Spec->catfile($file_dir, "default_mask.tex");
    copy($default_mask, $mask) or die "Can't copy" unless (-e $mask);
}
$mask =~ /(.+)\.tex/;
my $mask_pdf = $1 . ".pdf";

$file =~ /(.+)\./;
my $output = $1 . "_annotated.pdf";

say $file_dir;
say $mask;
say $mask_pdf;
print $output;

unless ($NO_COMPILE){
    system "perl generate_mask.pl '$file' '$mask'";
    system "pdflatex --output-directory '$file_dir' '$mask'";
}
system "pdftk '$file' multistamp '$mask_pdf' output '$output'";
