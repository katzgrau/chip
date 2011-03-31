# divvy

`divvy` is a log parsing and monitoring tool for system admins and developers. 
It wraps the functionality of `tee`, `tail`, `grep`, `ccze` and `mail` all into one,
with some extras.

## One line install

Want to jump right into it? This will work on most *nix systems. You _may_ have to execute it with `sudo`.

`perl -e "$(curl -fsSL https://gist.github.com/raw/895149/install-divvy)"`

Now read all about what you've just installed :)

## The basics

`divvy` starts up and tries to open a log file. If one isn't specified, it reads from standard input.
It goes through each line looking for patterns that _you_ have specified as arguments. When
it finds a match, divvy does whatever you told it to do with that match.

Maybe you'd want to:

1. Show the match(es) on the screen (like grep)
2. Colorize matches (like a colorizer)
3. Follow the file (like tail)
4. Log it to a file (like output redirection)
5. Have the line emailed to you (maybe for _really_ important stuff)
6. Kick off another program
7. Any combination of the above, with any number of matches, all at once

## Examples

### Split matches into different files

You have a long-running process that prints out its progress. Some items
might be errors (maybe prefixed with 'ERROR'), others are warnings.

`$ ./lame-process | divvy --match0=ERROR --log0=errors.txt --match1=WARN --log1=warnings.txt`

### View some matches in your terminal, stick others in a file

You're about to run a script that does something nasty, like importing 1,000s
of email addresses into an email service that rhymes with 'mailpimp'. A whole
bunch of status lines get output, along with occasional errors.

You want to run the script, see only the errors on the screen, and at the same time, 
send all output to one file and all errors to another.

`$ ./email-import | divvy --match0='.*' --log0=output.txt --match1='ERROR' --log1=errors.txt --screen1`

### Highlight matches in a terminal, and have errors emailed to you, and logged

Want to get notified whenever a fatal (like an HTTP 500) error occurs and is logged to some file? 
Want to log them separately too? Want to view all output as it goes by (like `tail`), but highlight 
fatal errors in red? No prob.

`$ divvy --follow --match0='HTTP 500' --screen0='red' --mail0=katzgrau@gmail.com --log0=fatal.txt --match1='.*' --screen1 error_log.txt` 

## More Fun Stuff

How about kicking off some process every time something specific shows up in the log?

`$ divvy --follow --match0='out of space' --exec0='rm -rf tmp/*' maillog`

How about being notified of when a script ends too?

`$ ./alter-table | divvy --complete=katzgrau@gmail.com --match0=ERROR --log0=errors.txt`

How about color-coding your output?

`$ divvy --follow --match0=ERROR --screen0='bold red on_black' --match1=WARN --screen1=yellow --match2=INFO --screen2=blue ap_log.txt` 

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

This project was written and is maintained by Kenny Katzgrau <katzgrau@gmail.com> at [CodeFury.net](http://codefury.net)

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
