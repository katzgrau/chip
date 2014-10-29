# chip

`chip` is a local and remote log parsing and monitoring tool for system admins and developers. 
It wraps the features of `swatch`, `tee`, `tail`, `grep`, `ccze`, and `mail`
into one, with some extras. Still an 'alpha'. Watch the [screencast](http://codefury.net/2011/04/video-chip-a-log-file-monitor-multiplexer/)!

## One line install

Want to jump right in? This will work on most *nix systems. You _may_ have to execute it with `sudo`.

`perl -e "$(curl -fsSL https://gist.githubusercontent.com/katzgrau/940608/raw/4fe8b9ae09ea12e31979406f28b8a6e3f06e86df/install-chip)"`

Now read all about what you've just installed :)

## What chip can do for you, really quickly

* Tail multiple logs at once, even remote logs
* Search multiple logs (even remote ones) for patterns. Like grep across n hosts/files
* Monitor multiple logs for occurrences of some match. Ie, log a certain line, send an email, start a process, more.

## The basics

`chip` starts up and tries to open log file(s), either local or remote. If one isn't specified, it reads from standard input.
It goes through each line looking for patterns that _you_ have specified as arguments. When it finds a match, chip does 
whatever you told it to do with that match.

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

`$ ./lame-process | chip --match0=ERROR --log0=errors.txt --match1=WARN --log1=warnings.txt`

### View some matches in your terminal, stick others in a file

You're about to run a script that does something nasty, like importing 1,000s
of email addresses into an email service that rhymes with 'mailpimp'. A whole
bunch of status lines get output, along with occasional errors.

You want to run the script, see only the errors on the screen, and at the same time, 
send all output to one file and all errors to another.

`$ ./email-import | chip --match0='.*' --log0=output.txt --match1='ERROR' --log1=errors.txt --screen1`

### Highlight matches in a terminal, and have errors emailed to you, and logged

Want to get notified whenever a fatal (like an HTTP 500) error occurs and is logged to some file? 
Want to log them separately too? Want to view all output as it goes by (like `tail`), but highlight 
fatal errors in red? No prob. This time, in shorthand:

`$ chip -f -m0='HTTP 500' -s0='red' -e0=katzgrau@gmail.com -L0=fatal.txt -m1='.*' -s1 error_log.txt` 

### The kicker: Do all of the above on multiple, remote files

chip can tail multiple files too. It will also tail files over ssh! Ever want to monitor multiple logs and separate
boxes behind a load balancer? Let's do the last example again but with two remote files:

`$ chip -f -m0='HTTP 500' -s0='red' -e0=katzgrau@gmail.com -L0=fatal.txt -m1='.*' -s1 username@www1.example.com:/var/log/errors.log username@www2.example.com:/var/log/errors.log` 

## Power users

Here are some tips for making chip super-useful:

### When dealing with remote servers, set up ssh keys (authorized_keys)

Your chip commands will run quickly without prompting you for your password every time you run a chip command

### alias chip for an easy remote grep

In .bashrc, put something like:

`alias grepprod='chip -s0 username@www1.example.com:/var/log/errors.log username@www2.example.com:/var/log/errors.log'` 

Then from the prompt, all you need to grep through *all* of your prod logs is:

`grepprod -m0=[pattern]`

### Command not working? Try -d

Type out an entire `chip` command, and tack on -d. Chip will tell you exactly what it was about to do.

`./chip -f -i0='(error|fatal)' -s0=red -e0=katzgrau@gmail.com,moo@moo.com -c=katzgrau@gmail.com log.txt example.com:/tmp/log.txt -d`

    chip is planning to open ...
    -------------------------------------------------
      File: log.txt
      SSH : [none] @ example.com => /tmp/log.txt
    with these patterns and associated handlers
    -------------------------------------------------
      Pattern #0 => /(error|fatal)/i
      - screen => red
      - email => katzgrau@gmail.com,moo@moo.com
    with these options
    -------------------------------------------------
      follow => 1
      debug => 1
      complete => katzgrau@gmail.com

## More Fun Stuff

How about kicking off some process every time something specific shows up in the log?

`$ chip --follow --match0='out of space' --exec0='rm -rf tmp/*' maillog`

How about being notified of when a script ends too?

`$ ./alter-table | chip --complete=katzgrau@gmail.com --match0=ERROR --log0=errors.txt`

How about color-coding your output?

`$ chip --follow --match0=ERROR --screen0='bold red on_black' --match1=WARN --screen1=yellow --match2=INFO --screen2=blue ap_log.txt` 

## Feature List

* Input by STDIN or file
* Open local or remote files (piggybacks on `ssh`)
* `tail`-ing of input files
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

`$ chip --help`

## Maintainer

This project was written and is maintained by Kenny Katzgrau at [codefury.net](http://codefury.net). Twitter: [@\_kennyk\_](http://twitter.com/_kennyk_).

## Naming

`chip` used to be named `stalk`. Before that, it was named `divvy`. I found out 
there was a window manager named 'Divvy'. This fact ate at my sanity for weeks, and I finally gave in. 

`stalk` was harder to pronounce and much creepier, but I appreciated the double-meaning. 
Since `stalk` monitored multiple remote files, the new name reflected the expanded
scope of the project.

... One hour later, I realized I would now be receiving emails from `stalk`. This bothered
me to the point that I knew another name change was iminent. `stalk` was just too creepy.

The utility is now named `chip`. Chip is everybody's innocent pal, right? He's no 
`stalk`er, that's for sure. `chip` has a similar play on words (log chipper).
Couldn't you trust `chip` to keep an eye on things while you're away?

## About

Written in Perl. Inspired by my work at Yahoo!. First presented at [Hack and Tell](http://hackandtell.org/) in NYC. 

Special thanks to Andrew Gwozdziewycz (co-organizer of H & T) for the contribution of cowsay.

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
