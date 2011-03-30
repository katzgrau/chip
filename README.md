# divvy

Divvy is a log parsing and monitoring tool for system admins and developers. 
It wraps the functionality of `tee`, `tail`, `grep`, and `mail` all into one.

## One line install

Want to jump right into it? This will work on most *nix systems. You _may_ have to execute it with `sudo`.

`perl -e "$(curl -fsSL https://gist.github.com/raw/895149/install-divvy)"`

Now read all about what you just installed :)

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
to view all output as it goes by, but highlight fatal errors in red? No prob.

`$ divvy --follow --match0='FATAL' --screen0='red' --mail0=katzgrau@gmail.com --log0=fatal.txt --match1='.*' --screen1 error_log.txt` 

## More Fun Stuff

How about kicking off some process every time something shows up in the log?

`$ divvy --follow --match0='New Package Submission' --exec0='./some-script' app_log.txt`

How about being notified of when a script ends?

`$ ./alter-table | divvy --complete=katzgrau@gmail.com --match0=ERROR --log0=errors.txt`

How about color-coding your output?

`$ divvy --follow --match0=ERROR --screen0='bold red' --match1=WARN --screen1=yellow --match2=INFO --screen2=blue ap_log.txt` 

## Feature List

* Input by STDIN or file
* 'Tailing' of input files
* Pattern-based matching of lines
* Email notification on matches all-at-once or per-line
* Color-coded screen output for matches
* Logging of matches in separate files
* Arbitrary command execution for matches
* Adding as many command per match as needed
* Email notification on script completion
* Very portable, fast (perl)

## Usage

To view the usage:

`$ divvy --help`

## Maintainer

This project was written and is maintained by Kenny Katzgrau <katzgrau@gmail.com>.

## About

Written in Perl. Inspired by my work at Yahoo!.

## License

Copyright (c) 2011 Kenny Katzgrau

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
