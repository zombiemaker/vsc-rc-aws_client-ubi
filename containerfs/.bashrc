################# CUSTOM PROMPT START
# http://ezprompt.net/

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[36m\]AZURE\[\e[m\] \[\e[35m\]\d\[\e[m\] \[\e[35m\]\t\[\e[m\] [\[\e[36m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[36m\]\h\[\e[m\]][\[\e[33m\]\w\[\e[m\]]\n> "
############### CUSTOM PROMPT END

export PATH=./:~/bin:~/scripts:$PATH

alias tf="terraform"
alias k="kubectl"

# This .bashrc file will be COPIED to ~/.bashrc EVERY TIME a container is created from this image
# Use the ~/.mybashrc file to add alias and functions
if [ ! -f ~/.mybashrc ]
then
	echo "Creating ~/.mybashrc file."
	touch ~/.mybashrc
	echo "#!/bin/bash" >> ~/.mybashrc
	echo "# Put your bash customizations in this file not in the ~/.bashrc file" >> ~/.mybashrc
fi
source ~/.mybashrc
. /etc/profile.d/bash_completion.sh
