#!/bin/bash

DIR="$(dirname $(readlink -f "$0"))"
FILE="files/quotes-$(date +%Y-%m)"
quote=`mktemp`

[ ! -d "$DIR" ] && mkdir -p "$DIR"

if [ -f "${DIR}/${FILE}" ]; then
    echo "%" >> ${DIR}/${FILE}
fi

while read line; do
	echo "${line}"
done | fmt -w 2500 | tee "$quote" >> "${DIR}/${FILE}"

if [ "$1" = "-p" ]; then
	# I'm adding it to my pile (github.com/goodevilgenius/pile)
	shift

	title=""
	coms=( )
	while [ "$1" = "-i" ]; do
		shift
		if [ "$1" = "title" ]; then
			shift
			title="$1"
			shift
		else
			coms=( "${coms[@]}" -i "$1" "$2" )
			shift
			shift
		fi
	done
	[ -z "$title" -a -n "$1" ] && title="Quote by $*"
	[ -z "$title" -a -z "$1" ] && title="Quote"
	if [ -n "$1" ]; then
		coms=( "${coms[@]}" -i source "$*" )
	fi
	coms=( "${coms[@]}" -i text "$(cat "$quote")" -i type quote "$title" )
	drop-a-log pile "${coms[@]}"
fi 

if [ -n "$1" ]; then
	echo -n "     -- " >> "${DIR}/${FILE}"
	echo "$@" >> "${DIR}/${FILE}"
fi

if [ -d "$DIR/.git" ]; then
	git --work-tree="$DIR" --git-dir="$DIR/.git" add "$FILE"
	git --work-tree="$DIR" --git-dir="$DIR/.git" commit -m "Added quote by $*"
fi 

##
## addfortune.sh
## 
## Made by Dan Jones
## Email   <dan@danielrayjones.com>
## 
## Last update Sat Apr 16 08:57:23 CDT 2016
##
## Copyright (c) 2013, Daniel Ray Jones
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice, this
##    list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
##    this list of conditions and the following disclaimer in the documentation
##    and/or other materials provided with the distribution. 
##
## 3. The name of the author may not be used to endorse or promote products derived
##    from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
## WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
## SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
## OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
## IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
## OF SUCH DAMAGE.
