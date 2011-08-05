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
#        USAGE:  ./annotate_pdf.pl [-n] [--no-aux] INPUT_PDF INPUT_MASK        #
#                                                                              #
#  DESCRIPTION:  This script stamps the INPUT_PDF file with the notes          #
#                contained in the INPUT_MASK. If no mask is provided, the      #
#                default mask will be used.                                    #
#                                                                              #
#      OPTIONS:  -n         Do not run generate_mask.pl or pdflatex            #
#                --no-aux   Remove auxiliary files
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
use File::Basename;

my $NO_COMPILE;
my $AUX;
if (($ARGV[0] eq "-n") or ($ARGV[0] eq "-a")){
    if ($ARGV[0] eq "-n"){
        $NO_COMPILE = 1;
        if ($ARGV[1] eq "-a"){
            $AUX = 1;
            shift @ARGV;
        }
    } else {
        $AUX = 1;
        if ($ARGV[1] eq "-n"){
            $NO_COMPILE = 1;
            shift @ARGV;
        }
    }
    shift @ARGV;
}

# File names
my $file = $ARGV[0];
die "No PDF given." unless ($file);
die "PDF does not exist." unless (-e $file);

my $mask = $ARGV[1];
die "No mask given." unless ($mask);
die "Mask does not exist." unless (-e $mask);

my $file_dir = dirname($file);
my $script_dir = dirname($0);

$mask =~ /(.+)\.tex/;
my $mask_pdf = $1 . ".pdf";

unless ($NO_COMPILE){
    print "\nGenerating $mask.\n";
    my $generate_mask_file = File::Spec->catfile($script_dir, "generate_mask.pl");
    system "perl", $generate_mask_file, $file, $mask;
    print "Done.\n";

    print "\nCompiling $mask.\n";
    system "pdflatex", "--output-directory", $file_dir, $mask;
    print "Done.\n";
}

print "\nStamping $file with $mask_pdf.\n";
$file =~ /(.+)\./;
my $output = $1 . "_annotated.pdf";
system "pdftk", $file, "multistamp", File::Spec->catfile($file_dir, $mask_pdf), "output", $output;
print "Done.\n";

unless($AUX and $NO_COMPILE){
    print "\nRemoving auxiliary files.\n";
    $mask =~ /(.+)\.tex/;
    for my $aux ( "$1.aux", "$1.log", "$1.out", "$1.pdf" ){
        unlink File::Spec->catfile($file_dir, $aux);
    }
    print "Done.\n";
}
