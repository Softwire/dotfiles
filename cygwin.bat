@echo off

C:
chdir %HOME%

set PATH=C:\cygwin\bin;C:\cygwin\usr\X11R6\bin;%PATH%

rem If you have char encoding issues, try this:
rem
rem # It might be better to use utf-8, which is the new cygwin default, but rxvt doesn't support it (!)
rem # See http://omgili.com/mailinglist/cygwin/cygwin/com/4067829B4871054DB7E77A511FCE9224013E3E5Bexch-empcampusgeorgefoxedu.html
rem
rem Previously I had set LANG=en_UK.Windows-1252
rem and set LC_CTYPE=C
rem
rem # you may want to set PERL_BADLANG=0

rem extra options didn't use to be necessary!
rem old = rxvt -sl 2000 -sr -title bash -e bash --login -i

rxvt -fg black -bg white -fn 7x14 -sl 2000 -sr -title bash -e bash  --login -i  
