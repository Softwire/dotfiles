export PATH="$PATH:~/bin"

# start in E:\work
cd /e/Work

# export PS1="$"

function proml {
local BLUE="\[\033[0;34m\]"
local RED="\[\033[0;31m\]"
local LIGHT_RED="\[\033[1;31m\]"
local WHITE="\[\033[1;37m\]"
local NO_COLOUR="\[\033[0m\]"
case $TERM in
    xterm*|rxvt*)
        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
        ;;
    *)
        TITLEBAR=""
        ;;
esac

PS1="${TITLEBAR}\
$BLUE[$RED\$(date +%H%M)$BLUE]\
$BLUE[$NO_COLOUR\u@\h:\w$BLUE]\
$NO_COLOUR
\$ "
PS2='> '
PS4='+ '
}

proml

## CVS aliases:
alias cvs="cvs -q"
alias cvschangedfiles="cvs -q diff -N --brief | grep '^\(Index\|\?\)' | sed 's/^Index: \(.*\)/M \1/'"
alias cvsc="cvschangedfiles"
alias cvsdiff="cvs diff -U 10 -N"

## SVN aliases and functions
alias svndiff="svn diff --diff-cmd diff --extensions '-U 10 -N'"
alias svnwdiff="svn diff --diff-cmd diff --extensions '-U 10 -N -w'"
alias svndiffw=svnwdiff
alias svnst='svn st | tr \\\\ /'
alias svnup='svn up --accept postpone'
alias svnswitch='svn switch --accept postpone'

# re-does a diff using the same files which were included in the specified
# diff.
# e.g. "svnrediff ~/diff.txt > ~/diff2.txt"
function svnrediff() {
    IFS='
'
    for f in `grep ^Index "$*" | sed 's/^Index: //'`; do
	svndiff "$f"
    done
    unset IFS
}

function svnrediffu3() {
    IFS='
'
    for f in `grep ^Index "$*" | sed 's/^Index: //'`; do
	svn diff "$f"
    done
    unset IFS
}

# gives a diff between the specified diff and a diff produced by svnrediff
function svnrediffdiff() {
    svnrediff "$1" | diff -u "$1" - | less
}

# attempts to get a list of all files which were included in the specified
# patch file, in a format suitable to use as an argument list
function svnfiles() {
    IFS='
'
    for f in `grep -a ^Index "$*" | sed -e 's/^Index: //'`; do
	printf '%q ' "$f"  # n.b. previously had "%q", but that causes "Error resolving case" in SVN
    done
    unset IFS
}

function svnuplockopen() {
    if [ $# -ne 1 ]; then
	echo "svnuplockopen: expecting one argument"
    else
        # svn lock returns 0 on success or failure:
        # have to use "grep ." to detect error messages on stderr
	svn up "$1" && svn lock "$1" 2>&1 > /dev/null | grep . || cygstart "$1"
    fi
}

# does an "svn mv $1 $2" if you've already done a "mv $1 $2"
function svnpostmove() {
    if [ $# -ne 2 ]; then
	echo "svnpostmove: expecting two arguments 'from' and 'to'"
    else
	mv -i "$2" "$2_" || return 1
	svn up "$1" # (can't test return code; svn always returns 0)
	svn mv "$1" "$2"
	mv "$2_" "$2"
    fi
}

# do an `svn info` on the server-side copy of a file in a local checkout
# (e.g. to see who has it locked)
function svninfoserver()
{  
  if [ $# -ne 1 ] ; then
    echo "svninfoserver: wrong number of arguments"
    echo "svninfoserver: Usage: svninfoserver path"
  else
    url=`svn info "$1" | grep ^URL | egrep -o '[^ ]+$' | tr -d [:space:]`
    svn info "$url"
  fi
}

## GIT aliases and functions
alias gti=git
alias gs="git status"

## TAN stuff (only works in root dir of TAN)

alias getApplicationInstance="grep \<ApplicationInstance\> SWTConfig.xml | sed 's/.*<ApplicationInstance>\([^<]*\)<\/ApplicationInstance>.*/\1/'"
alias getApplicationName="grep \<ApplicationName\> SWTConfig.xml | sed 's/.*<ApplicationName>\([^<]*\)<\/ApplicationName>.*/\1/'"

#alias svnstatusTAN='svn status . SWT Deployment/`getApplicationInstance` | tr \\ /'
#alias svndiffTAN='svndiff . SWT Deployment/`getApplicationInstance`'
#alias svnupTAN='svn up . SWT Deployment/`getApplicationInstance`'

# softwire SVN root

export softwireSVNroot='http://svn.zoo.lan/svn/rwrepos'
export SVNrootSoftwire=$softwireSVNroot

export svnRW='http://svn.zoo.lan/svn/rwrepos'
export svnDOC='http://svn.zoo.lan/svn/swdocsrepos'
export svnSW='http://svn.zoo.lan/svn/swrepos'

# xtitle
function xtitle ()
{
    case "$TERM" in
        *term | rxvt)
            echo -n -e "\033]0;$*\007" ;;
        *)  
	    ;;
    esac
}

## other aliases:
alias ..="cd .."
alias ls="ls --color=auto"
alias ll="ls -lh"
alias la="ls -a"
alias l=less

alias miffs="java -cp \"c:\\Documents and Settings\\RTB\\My Documents\\personal\\MIFFS.jar\" rich.miffs.frontends.SwingFront"
alias cmiffs="stty -icanon min 1 -echo; xtitle miffs; java -cp \"c:\\Documents and Settings\\RTB\\My Documents\\personal\\MIFFS.jar;c:\\Documents and Settings\\RTB\\My Documents\\personal\\jline-0.9.94.jar\" -Djline.terminal=jline.UnixTerminal jline.ConsoleRunner rich.miffs.frontends.CmdLineFront; stty icanon echo"

alias lynx='xtitle lynx; lynx'

# windows shell launcher (knows windows file associations)
alias start='cygstart'
alias s=start

alias handleCount="handle -s | grep ^Total | sed 's/.*: //'"

function emacs ()
{
    filename=`readlink -f "$1"`
    wfilename=`cygpath -w "$filename"`
    /c/emacs-23.2/bin/emacsclientw.exe -n "$wfilename"
}
alias e=emacs

alias gerp=grep

export EDITOR=vi
export SVN_EDITOR="svn_editor.bat"

function man ()
{
    for i ; do
	xtitle The $(basename $1|tr -d .[:digit:]) manual
	command man -F -a "$i"
    done
}

#bash completion helpers

# too slow :-( . ~/bin/bash_completion/bash_completion.sh


# cmds:

# find . | grep \\.svn$ | xargs -IX echo X X | sed s/\.svn\$/_svn/ | xargs -IX echo mv X

# http://www.saltycrane.com/blog/2008/05/how-to-paste-in-cygwin-bash-using-ctrl/
stty lnext ^q stop undef start undef

# Add git style "less" wrappers to the following commands.
# This means that they will auto-scroll if the output is too long.
#
# The "-F" opt means that less will not scroll if the output will
# fit on the current screen.
# The "-X" opt means not to clear the screen before and after the output.
# It doesn't seem necessary on my cygwin, but it is useful on linux boxes.
#
# Less will notice if it is in a pipeline and revert to passthru.
#
# "command" means to run the command without using function lookups. It is
# needed here to avoid an infinite loop.

svn() {
    if [ "$1" = "log" -o "$1" = "diff" ]
    then
        command svn "$@" | less -FX
    else
        command svn "$@"
    fi
}
diff() {
    command diff "$@" | less -FX
}
grep() {
    command grep "$@" | less -FX
}
