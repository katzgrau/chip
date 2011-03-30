# Divvy

Divvy is a log parsing and monitoring tool for system admins and developers. 
It wraps the functionality of `tee`, `tail`, `grep`, and `mail` all into one.

## Its like grep

You have a big ol log file from some web application that uses the conventions
of starting lines with ERROR, WARN, INFO, DEBUG, etc. You want to place all of
the errors in one file, and all of the WARNS in another.

`$ divvy --match0=ERROR --log=error.txt --match1=WARN --log=warns.txt biglog.txt`

Cool. But yeah, you could do that with a couple grep commands.

## Its like tee, grep, and output redirection

You are about to run a script that does something nasty, like importing 1,000s
of email addresses into an email service that rhymes with 'mailpimp'. A whole
bunch of status lines get output, along with occaisional errors.

You want to run the script, see only the errors on the screen, and at the same time, 
send all output to one file, and all errors to another.

`$ ./email-import | divvy --match0='.*' --log0=output.txt --match1='ERROR' --log1=errors.txt --screen1`

That should be at least fairly intriguing, especially since you can attach as many match conditions
and corresponding handlers as youd like!

## Its like tail and mail

Time for best part!

Want to get notified whenever a fatal error occurs? Want to log them too? Want
to view all output as it goes by? No prob.

`$ divvy --follow --match0='FATAL' --mail0=katzgrau@gmail.com --log0=fatal.txt --match1='.*' --screen1 error_log.txt` 

## More Fun Stuff

How about kicking off some process every time something shows up in the log?

`$ divvy --follow --match0='New Package Submission' --exec0='./some-script' app_log.txt`

How about being notified of when a script ends?

`$ ./alter-table | divvy --complete=katzgrau@gmail.com --match0=ERROR --log0=errors.txt`

## Usage

## About

## Maintainer

This project was written and is maintained by Kenny Katzgrau <katzgrau@gmail.com>.

## About

Written in Perl. Inspired by my work at Yahoo!.
