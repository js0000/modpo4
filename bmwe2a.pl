#! /usr/bin/env perl


# bmwe2a.pl
# Bernadette Mayer Writing Experiments 2a
# http://www.writing.upenn.edu/library/Mayer-Bernadette_Experiments.html

# since i've written this program
# i'm going to specify a license for it
# even though most of it is only error checking
# copyright 2012 john saylor
# released under the terms of the GNU general public license v3.0


use strict;
use warnings;

use Getopt::Std;

# check command line
our $options = {};
getopts( 'f:l:', $options );

# no switches, print usage
if( scalar( keys %$options ) < 1 ) {
    die( join( "\n",
        "$0 -f <file> -l <letter>",
	'  removes all words starting with <letter> from <file>',
	'  if <letter> is missing, it will be randomly assigned',
	''
    ) );
}
# can't continue without file
elsif( ( ! exists( $options->{f} ) ) || ( $options->{f} !~ /\w+/ ) ) {
    die 'cannot continue, invalid file';
}

# generate random letter
if( ( ! exists( $options->{l} ) ) || ( length( $options->{l} ) == 0 ) ) {
    my @alphabet = ( 'a'..'z' );
    # using constant 26 because this is how many letters are in the english alphabet [and it is a constant!]
    $options->{l} = $alphabet[rand 26];
}
# more than one letter
elsif( length( $options->{l} ) > 1 ) {
    die "cannot continue, more than one letter specified: $options->{l}";
}
# non alpha character
elsif( lc( $options->{l} ) !~ /^[a-z]$/ ) {
    die "cannot continue, must enter alphabet character not: $options->{l}";
}


# read in file
use IO::File;
my $fh = IO::File->new( $options->{f}, 'r' );
if( ! defined( $fh ) ) {
    die "could not read $options->{f}: $!";
}

# could just print output, but putting it in an array 
#   makes it easy to print out or do something else with it later
# array initialized with header text
my @modified = ( 
    '# original filename: ' . $options->{f} . "\n",
    '# words removed begining with: ' . $options->{l} . "\n",
    '# time of processing: ' . scalar( localtime() ) . "\n",
    '#   2012 john saylor' . "\n\n\n\n"
);

# loop through file line by line
while( <$fh> ) {

    my $line = $_;

    # remove words starting with specified letter from line
    # here is an explanation of the pattern specified below:
    #   word boundary
    #   inital letter of word matches
    #   one or more non-white-space characters
    #     [i decided one letter words don't get removed, 
    #     so i specified there has to be at least one more character 
    #     after initial match]
    #   one or zero white space characters
    $line =~ s/(\b)$options->{l}\S+\s?/$1/gi;
    
    # fix if end of line break is
    #   white-space character that gets removed by
    #   pattern matching
    if( $line !~ /\n$/ ) { $line .= "\n" };

    # save modified $line
    push( @modified, $line );
}

# print out header text + all saved $lines + ending space
print( join( "", @modified ), "\n\n" );

# good bye
exit;
