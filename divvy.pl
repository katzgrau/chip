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

# If you make a new handler in the handler section, add it here
# Will hold keys to arrays of index ids to handers
my @handler_types = qw/log exec screen/;

# Will hold the patterns that we're looking for
my %patterns = ();

# Will hold the functions for dealing with lines matching patterns
my %handlers = ();

my %index_to_handler = ();

# Will hold whether to print the lines to STDOUT
my $opt_out = 0;

# Will hold whether to keep the log file open and follow it like tail -f
my $opt_tail = 0;

# Will hold whether to send all matches set to be mailed at once
my $opt_mail_once = 0;

# ------------------------------------------------------------
# Section: Core function definitions
#  If you want to add new handlers or things like that, add them 
#  in the section below this one.
# ------------------------------------------------------------

# Validate all of the command line arguments, parse them
#  and store them in global vars for later use
sub validate_args() {
  # Go through each argument
  foreach (@ARGV) {
    # Does it look like a valid argument?
    if(my ($handler, $index, $argument) = /\-\-([a-zA-Z]+)(\d+)=(?:["']?)([^'"]*)(?:["']?)/) {
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

# This is the main program loop. Roll through standard input
#  and try matching each line with any patterns that have
#  been specified as arguments. If we have matches, execute
#  the handlers for that match.
sub main {
  # Roll through each line of STDIN, and if it matches a pattern,
  # execute any corresponding handlers
	# Allocate a bunch of hashes to hold arguments
 
	# Initialize, the handler array!
	foreach(@handler_types) {
    $handlers{$_} = {};
  }
 
	# Second, validate the args!
	validate_args;

	# Now do the handywork
  while(my $line = <STDIN>) {
    chomp($line);
    foreach my $idx (keys %patterns) {
      $_ = $line;
      if(/$patterns{$idx}/) {
        execute_all_handlers($idx, $line);
      }
    }  
  }
}

# Given the index of a matching pattern (specified by user
#  at the command line), and the line of matching input
#  execute all handlers that may have been specified.
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

# Given the type of handler, and the index of the match,
#  get the argument/paramater that was specified by the 
#  user. Ex, a param looks like: --[type][index]=[arg]
sub get_arg {
  my ($type, $index) = @_;
  return $handlers{$type}{$index};
}

# Print out a message and exit the script. Basically used
#  for errors
sub fatal {
  my ($message) = @_;
  print $message . "\n";
  exit;
}

# ------------------------------------------------------------
# Section: Match Handlers
#  Any match specified by a user can (and should) have a
#  corresponding handler assigned to it. If an arg is passed
#  on the command line like --foo25=mammajamma, then it's
#  expected that there is a handle_foo function.
#  Access to the 'mammajamma' arg can be retrieved by get_arg()
# ------------------------------------------------------------

# Allow a user to specify an arbitrary unix command to execute
# if a line is find. Allow them to specify {{LINE}} if they
# want that line somehow inserted in that command
sub handle_exec {
  my ($index, $line) = @_;
  my $cmd = get_arg("exec", $index);
  $cmd =~ s/\{\{LINE\}\}/$line/g;
  print `$cmd`;  
}

# A handler for allowing the user to log a matching line to a
# file. The argument passed on the command line should be
# the filepath to log to.
# Define log_files here to keep this handler all in one place
my %log_files = (); 
sub handle_log {
  my ($index, $line) = @_;
  # Is there a file stream already open?
	#  If not, open it
	if(!defined($log_files{$index})) {
		$log_files{$index} = "file_handle_$index"; 
		my $filename = get_arg("log", $index);
		open($log_files{$index}, '>', $filename);
	}
  # Write to the log file
	print {$log_files{$index}} $line."\n";
}

# A handler for letting the user log matching lines to the
# screen. Useful to see important stuff go by, or to perhaps
# specify .* (any) as an argument and use this script like `tee` 
sub handle_screen {
  my ($index, $line) = @_;
  print $line."\n";
}

# ------------------------------------------------------------
# Kickoff the main program loop
main;

#print Dumper(@ARGV);
#print Dumper(\%patterns) . "\n" ;
#print Dumper(\%handlers) . "\n" ;
#print Dumper(\%index_to_handler) . "\n" ;
