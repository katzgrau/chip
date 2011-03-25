#!/usr/bin/env perl -w

# divvy is a command line utility for splitting text lines (like those from log files) into separate files based on pattern matching.  
#
# Laziness, Impatience, Hubris: Yes!
#
# Written and maintained by: 
#   Kenny Katzgrau 
#   katzgrau@gmail.com
#   http://codefury.net
# Project maintained at:
#   http://github.com/katzgrau/divvy

use strict;
no strict 'refs';

use Data::Dumper;

# Will hold the patterns that we're looking for
my %patterns = ();

# Will hold the functions for dealing with lines matching patterns
my %handlers = ();

my %index_to_handler = ();

# Will hold keys to arrays of index ids to handers
my @handler_types = qw/log exec screen/;

# Will hold whether to print the lines to STDOUT
my $opt_out = 0;

# Will hold whether to keep the log file open and follow it like tail -f
my $opt_tail = 0;

# Will hold whether to send all matches set to be mailed at once
my $opt_mail_once = 0;

# Allocate a bunch of hashes to hold arguments
foreach(@handler_types) {
  $handlers{$_} = {};
}

# Function definitions
sub validate_args() {
	# Go through each argument
	foreach (@ARGV) {
		# Does it look like a valid argument?
		if(my ($handler, $index, $argument) = /\-\-([a-zA-Z]+)(\d+)=(.*)/) {
		  if($handler eq "match") {
			  # It's a 'match' argument specifying a pattern
			  $patterns{$index} = $argument; 
			} elsif (defined $handlers{$handler}) {
				# It's a handler specifying what to do with a match
				$handlers{$handler}{$index} = $argument;	  
        if(!defined($index_to_handler{$index})) {
				  $index_to_handler{$index} = [];
				}
				push(@{$index_to_handler{$index}}, $handler);
			} else {
				# It's not anything. Quit wasting my time
			  fatal("Handler '$handler' is not recognized.");
			}
		} else {
		  fatal("Invalid arguments: $_"); 
		}
	}	
}

sub get_arg {
  my ($type, $index) = @_;
	return $handlers{$type}{$index};
}

sub handle_exec {
	my ($index, $line) = @_;
  my $cmd = get_arg("exec", $index);
  $cmd =~ s/\{\{LINE\}\}/$line/g;
  print `$cmd`;	
}

sub handle_log {
	# Is there a file stream already open?
	my ($index, $line) = @_;
}

sub handle_screen {
	my ($index, $line) = @_;
	print "Screen: $line\n";
}

sub execute_all_handlers {
  my ($matching_index, $line) = @_;
  foreach my $handler (@{$index_to_handler{$matching_index}}) {
	  my $func = "handle_$handler";
		if(defined(\$func)) {
			# Use eval until we don't need use strict;
		   &$func($matching_index, $line); 
		} else { print "NOT DEFINED!\n"; }
	}
}

sub fatal {
  my ($message) = @_;
	print $message . "\n";
	exit;
}

validate_args;

# Roll through each line of STDIN, and if it matches a pattern,
# execute any corresponding handlers
while(my $line = <STDIN>) {
	chomp($line);
  foreach my $idx (keys %patterns) {
		$_ = $line;
		if(/$patterns{$idx}/) {
			execute_all_handlers($idx, $line);
		}
	}	
}


#print Dumper(\%patterns) . "\n" ;
#print Dumper(\%handlers) . "\n" ;
#print Dumper(\%index_to_handler) . "\n" ;
