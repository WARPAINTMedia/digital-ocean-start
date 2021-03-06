# .bashrc

export GIT_EDITOR=vim
export VISUAL=vim
export EDITOR=vim

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.
shopt -s autocd # auto cd is boss

# Source global definitions
if [ -f /etc/bashrc ]; then
. /etc/bashrc
fi

alias htdocs="cd /var/www/"
alias restart-server="sudo service apache2 restart"
alias apache-config="vi /etc/apache2/apache2.conf"
alias myip="ifconfig eth0 | grep inet | awk '{ print $2 }'"

alias start-apache="sudo service apache2 start"
alias stop-apache="sudo service apache2 stop"

function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
    *.tar.gz)    tar xvzf $1     ;;
    *.bz2)       bunzip2 $1      ;;
    *.rar)       unrar x $1      ;;
    *.gz)        gunzip $1       ;;
    *.tar)       tar xvf $1      ;;
    *.tbz2)      tar xvjf $1     ;;
    *.tgz)       tar xvzf $1     ;;
    *.zip)       unzip $1        ;;
    *.Z)         uncompress $1   ;;
    *.7z)        p7zip x $1         ;;
    *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
    else
        echo "'$1' is not a valid file!"
            fi
}


# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}$HOST"
        echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
        echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
        cut -d " " -f1 | sort | uniq
        echo -e "\n${BRed}Current date :$NC " ; date
        echo -e "\n${BRed}Machine stats :$NC " ; uptime
        echo -e "\n${BRed}Memory stats :$NC " ; free
        echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
        echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
        echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}

# goes out, grabs wordpress, unzips, moves to root of dir, and then cleans
download-wordpress() {
    wget http://wordpress.org/latest.tar.gz;
    tar xfz latest.tar.gz;
    mv wordpress/* ./
                   rmdir ./wordpress/
                   rm -f latest.tar.gz
                   echo 'wordpress installed'
                   }

#################################3
## File used for defining $PS1

bash_prompt_command() {
# How many characters of the $PWD should be kept
local pwdmaxlen=25
# Indicate that there has been dir truncation
local trunc_symbol=".."
local dir=${PWD##*/}
        pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
        NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
        if [ ${pwdoffset} -gt "0" ]
            then
                NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
    NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

bash_prompt() {
    local NONE="\[\033[0m\]"    # unsets color to term's fg color

# regular colors
        local K="\[\033[0;30m\]"    # black
        local R="\[\033[0;31m\]"    # red
        local G="\[\033[0;32m\]"    # green
        local Y="\[\033[0;33m\]"    # yellow
        local B="\[\033[0;34m\]"    # blue
        local M="\[\033[0;35m\]"    # magenta
        local C="\[\033[0;36m\]"    # cyan
        local W="\[\033[0;37m\]"    # white

# empahsized (bolded) colors
        local EMK="\[\033[1;30m\]"
        local EMR="\[\033[1;31m\]"
        local EMG="\[\033[1;32m\]"
        local EMY="\[\033[1;33m\]"
        local EMB="\[\033[1;34m\]"
        local EMM="\[\033[1;35m\]"
        local EMC="\[\033[1;36m\]"
        local EMW="\[\033[1;37m\]"

# background colors
        local BGK="\[\033[40m\]"
        local BGR="\[\033[41m\]"
        local BGG="\[\033[42m\]"
        local BGY="\[\033[43m\]"
        local BGB="\[\033[44m\]"
        local BGM="\[\033[45m\]"
        local BGC="\[\033[46m\]"
        local BGW="\[\033[47m\]"

        local UC=$W                 # user's color
        [ $UID -eq "0" ] && UC=$R   # root's color

# without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
# extra backslash in front of \$ to make bash colorize the prompt

#Nat's Colored Prompt
        PS1="${W}[${UC}\u${EMY} @ ${UC}\h ${EMY}\${NEW_PWD}${W}]\\$ ${NONE}"


}

PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt


alias check-gzip="curl -I -H 'Accept-Encoding: gzip,deflate'"

function enable-site() {
    sudo a2ensite "$1" && echo "\nServer Restart:\n" && service apache2 reload
}

alias htdocs="cd /var/www/html/"
alias php-ini="vi /etc/php5/apache2/php.ini"
alias apache-sites="cd /etc/apache2/sites-available"
alias apache-errors="cat /var/log/apache2/error.log"

# take in a table name and then dump the backup file
# you must have p7zip installed for this to work
function sql-dump() {
    NOW=$(date +"%m%d%Y")
    FILE="$1_$NOW_backup.sql"
    mysqldump -u root -p $1 > $FILE
    echo "$FILE created"
    p7zip "$FILE"
}

function sql-import() {
    USER=$1
    DATABASE=$2
    FILE=$3
    mysql -u $USER -p -h localhost $DATABASE < $FILE
}

function full-mysql-dump() {
    mysqldump --all-databases > dump-$( date '+%Y-%m-%d_%H-%M-%S' ).sql -u root -p
}

# git aliases
# tj git aliases
alias gd="git diff | vim"
alias ga="git add"
alias gaa="git add --all ."
alias gbd="git branch -D"
alias gs="git status"
alias gca="git commit -a -m"
alias gm="git merge --no-ff"
alias gpt="git push --tags"
alias gp="git push"
alias grh="git reset --hard"
alias gb="git branch"
alias gcob="git checkout -b"
alias gco="git checkout"
alias gba="git branch -a"
alias gcp="git cherry-pick"
alias gl="git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
alias gpom="git pull origin master"
alias gcd='cd "`git rev-parse --show-toplevel`"'

# my aliases
# remove files that are not under version control
alias gcf="git clean -fd"
# discard changes in the working directory
alias gcod="git checkout -- ."
# grab the latest upstream version
alias gpum="git pull upstream master"
# delete branch from github. follow with branch name
alias gpod="git push origin --delete"
# show git status without untracked files
alias gsu="git status -uno"
# commit -m
alias gcm="git commit -m"
# remove staged file
alias grm="git reset HEAD"
# add current files, commit those files
alias gacm="git add . --all && git commit -m"

# generate a changelog based on the content of the commit messages
function changelog() {
  git log --pretty=format:"%ar %s" | > changelog.md && echo "created changelog.md"
}

gitrdone () {
  git commit -m $1 && git push
}

git-purge() {
  FN="git rm --cached --ignore-unmatch $1"
  git filter-branch --force --index-filter $FN --prune-empty --tag-name-filter cat -- --all
  echo "\n run git push -f in order to overwrite the remote files you purged."
}

# clone a remote branch without any other branches
git-get-tree() {
  REPO=$1
  NAME=$2
  BRANCH=$3
  # git-get-tree Swipe kimwz touch-swipe-improve
  git remote add -t $BRANCH -f $NAME "https://github.com/$NAME/$REPO/"
  git checkout -b $BRANCH
  git pull $NAME
}

filesize () {
	if du -b /dev/null > /dev/null 2>&1
	then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]
	then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

function create-site-conf() {
    OLD="example.com"
    echo "Enter the name of the new site:"
    read SITENAME
    cat ~/.vhost.conf > "$SITENAME.conf"
    sed "s/$OLD/$SITENAME/g" "$SITENAME.conf"
    echo "created $SITENAME.conf"
}

# create a new git enabled project
function new-project() {
  #where are we starting from?
  LOCATION="$(pwd)"
  # get the sitename
  SITENAME="$1"
  # setup the directories
  mkdir -p /var/www/html/$SITENAME # && cd /var/www/html/$SITENAME
  mkdir -p /var/www/git/$SITENAME.git && cd /var/www/git/$SITENAME.git
  git init --bare && cd hooks
  # create post-receive file and own it
  echo "git --work-tree=/var/www/html/$SITENAME --git-dir=/var/www/git/$SITENAME.git checkout -f" > post-receive
  chmod +x post-receive
  # go back to where we started
  cd $LOCATION
  # get the IP for this server
  IP="$(curl -sS http://myip.dnsomatic.com)"
  # tell us how to clone this repo, we assume the username is the default `root`
  echo "git remote add dev ssh://root@$IP:/var/www/git/$SITENAME.git"
}

function apache-setup() {
  a2enmod rewrite expires mime headers deflate filter file_cache cache cache_disk cache_socache mime setenvif
}

# generats a password for the proftpd mysql database
function proftpd-password() {
  /bin/echo "{md5}"`/bin/echo -n "$1" | openssl dgst -binary -md5 | openssl enc -b    ase64`                                                                            
}

# download composer and install it globally
function get-composer() {
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin
  echo "composer installed and alias created"
}

# make `composer` work by itself
alias composer="php /usr/bin/composer.phar"
