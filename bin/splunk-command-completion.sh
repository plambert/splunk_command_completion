#!/usr/bin/env bash

# Paul M. Lambert
# Based on the script by Vainstein K 12aug2013

DEBUG="${SPLUNK_BASH_COMPLETION_DEBUG:-}"
completion_function=__splunk
# # # Check a few prereqs.
# feature='"splunk <verb> <object>" tab-completion'
if [ "${BASH_VERSION}x" == x ]; then
	echo 1>&2 "${SHELL}: Cannot use this shell, this script requires bash"
	return 1 >/dev/null 2>&1 || exit 1
fi

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
	sourced=""
else
	sourced=-YES-
fi

if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
	printf 1>&2 '\e[31m%s: requires bash 4.0.0 or higher, you have %s\e[0m\n' "$0" "${BASH_VERSION}"
	return 1 >/dev/null 2>&1 || exit 1
fi

if ! builtin complete >/dev/null 2>&1; then
	printf 1>&2 $'\e[31m%s: the `complete` builtin must be included in your bash\e[0m\n' "$0"
	return 1 >/dev/null 2>&1 || exit 1
fi

### YOU MUST CALL THIS LIKE SO: eval "$(FAIL 1 "%s: failed" "blah")"
### This is because we cannot _return_ from the caller, so if the script has been sourced, you need to do that
### yourself.
### You can also repeat the return code, if you like: FAIL 1 "%s: failed" "blah"; return 1 >/dev/null 2>&1; exit 1
FAIL() {
	_RC="$1"; shift
	local fmt='%s'
	[[ $# -gt 1 ]] && fmt="$1" && shift
	printf 1>&2 '\e[31m%s [ERROR] '"${fmt}"'\e[0m\n' "${0##*/}" "$@"
	[[ -t 1 ]] || printf 'return %d >/dev/null 2>&1; exit %d' "$_RC" "$_RC"
	return "$_RC"
}

DEBUG() {
	[[ -z "$DEBUG" ]] && return
	local fmt='%s'
	[[ $# -gt 1 ]] && fmt="$1" && shift
	printf '\e[34;1m%s [DEBUG] '"${fmt}"'\e[0m\n' "$0" "$@"
}

_write() {
	local fmt='%s\n'
	[[ $# -gt 1 ]] && fmt="$1\\n" && shift
	# shellcheck disable=SC2059
	printf "$fmt" "$@"
}

_compgen() {
	local word="$1"; shift
	case "$1" in
		-* ) printf $'    %-16s ) mapfile -t COMPREPLY < <(compgen %s -- "$wordCur") ;;\n' "$word" "$*" ;;
		 * ) printf $'    %-16s ) mapfile -t COMPREPLY < <(compgen -W "%s" -- "$wordCur") ;;\n' "$word" "$*" ;;
	esac
}

write_temp_file() {
	local tempfile="$1"; shift
	DEBUG "%s: writing tempfile" "$tempfile"

	# # # If anything goes wrong, at least we don't pollute cwd with our tempfile.
	[[ -n "$DEBUG" ]] || trap 'rm -f "$tempfile"' SIGINT SIGQUIT SIGTERM SIGABRT SIGPIPE
	touch "$tempfile" || { FAIL 3 "%s: cannot touch tempfile" "$tempfile"; return "$_RC" >/dev/null 2>&1; exit "$_RC"; }

  [[ -n "$SPLUNK_HOME" ]] || eval "$(FAIL 4 "SPLUNK_HOME is not defined")"

	local splunk="${SPLUNK_HOME}/bin/splunk"
  [[ -x "$splunk" ]] || eval "$(FAIL 5 "%s: no bin/splunk executable found" "${SPLUNK_HOME}")"

  DEBUG "%s: found SPLUNK_HOME" "$SPLUNK_HOME"

	# # # Find the file with object->{verb1,verb2,...} map.
	local splunk_commands_xml="${SPLUNK_HOME}/etc/system/static/splunkrc_cmds.xml"
	[[ -f "$splunk_commands_xml" ]] || eval "$(FAIL 7 "%s: cannot find splunk command xml" "$splunk_commands_xml")"
	DEBUG "%s: found splunk commands xml description" "$splunk_commands_xml"

	# # # Parse the map file, and generate our internal verb->{objA,objB,...} map.
	local -A verb_to_objects
	local line object verb lineno=0
	local in_item=""
	local regex_depr='\<depr\>'
	local regex_verb='\<verb\>'
	local regex_synonym='\<synonym\>'
	while read -r line; do
		lineno=$((lineno+1))

		if [[ -n "$in_item" ]]; then
			if [[ $line =~ '</item>' ]]; then
				DEBUG "%s: exited item tag at line %d" "$object" "$lineno"
				in_item=""
				object=""
			elif [[ "$line" =~ '<cmd name' ]] && [[ ! "$line" =~ $regex_depr ]] && [[ ! "$line" =~ $regex_synonym ]]; then
				[[ -z "$object" ]] && eval "$(FAIL 9 "line %d: no object within item tag" "$lineno")"
				verb="${line#*\"}"  # remove shortest match of .*" from the front
				verb="${verb%%\"*}" # remove longest match of ".* from the back
				[[ "$verb" == _internal ]] && continue
				verb_to_objects[$verb]+=" $object"
				DEBUG "%d: mapped object '%s' to verb '%s'" "$lineno" "$object" "$verb"
			fi

		else # ! in_item
			if [[ "$line" =~ '<item obj' ]] && [[ ! "$line" =~ $regex_depr ]] && [[ ! "$line" =~ $regex_verb ]] && [[ ! "$line" =~ $regex_synonym ]]; then
				in_item=true
				object="${line#*\"}"  # remove shortest match of .*" from the front
				object="${object%%\"*}" # remove longest match of ".* from the back
				DEBUG "%d: entered item tag for object '%s'" "$lineno" "$object"
				if [[ "$object" == on ]] || [[ "$object" == help ]]; then
					in_item=""
				fi
			fi
		fi

	done < "$splunk_commands_xml"

	for verb in reload enable disable display; do
		verb_to_objects[$verb]+=" deploy-server"
	done

	mapfile -t verbs < <(for key in "${!verb_to_objects[@]}"; do printf "%s\n" "$key"; done | sort)

	DEBUG "processed %d lines." "$lineno"
	for key in "${verbs[@]}"; do
		verb_to_objects[$key]="$(perl -E 'print join " ", sort grep { /\S/ } split / +/, shift @ARGV' "${verb_to_objects[$key]}")"
		DEBUG "%s: values: [%s]" "$key" "${verb_to_objects[$key]}"
	done

  # return 0

	# # # Find the file with topics understood by 'splunk help <topic>' command, and extract list of topics.
	local python_script="${SPLUNK_HOME}/lib/python2.7/site-packages/splunk/clilib/literals.py"
	[[ -e "$python_script" ]] || eval "$(FAIL 10 "%s: cannot find expected python script file" "$python_script")"
	DEBUG "%s: found python script with help topics" "$python_script"
	local help_topics=( )
	eval "$(perl -E 'undef $/; $_=<>; push @list, $1 while (m{addHelp\(\s*["'\'']([^"'\'']+?)["'\'']}g); printf "help_topics=(%s)", join " ", map { "\"$_\"" } sort @list' "$python_script")"
	DEBUG "found %d help topics" "${#help_topics[@]}"
	DEBUG "help topics: %s" "${help_topics[*]}"
	# return 0
	(
		_write $'function %s() {' "$completion_function"
		_write $'  local wordCur=${COMP_WORDS[COMP_CWORD]}'
		_write $'  local wordPrev=${COMP_WORDS[COMP_CWORD-1]}'
		_write $'  case "$wordPrev" in'
		_compgen splunk "${verbs[*]}" help ftr start startnoss stop restart restartss status rebuild train fsck clean-dispatch clean-srtemp validate verifyconfig anonymize find clean createssl juststopit migrate --version -version version httpport soapport spool ftw envvars _RAW_envvars _port_check cmd _rest_xml_dump search dispatch rtsearch livetail _normalizepath _internal logout btool pooling _web_bootstart offline clone-prep-clear-config diag
		_compgen _internal http mgmt https pre-flight-checks check-db call rpc rpc-auth soap-call soap-call-auth prefixcount totalcount check-xml-files first-time-run make-splunkweb-certs-and-var-run-merged
		_compgen clean all eventdata globaldata userdata inputdata locks deployment artifacts raft
		_compgen fsck scan repair clear-bloomfilter make-searchable
		_compgen migrate input-records to-modular-inputs rename-cluster-app
		_compgen help "${help_topics[@]}"
		_compgen cmd -o default -o filenames -G "'${SPLUNK_HOME}/bin/*'"
		for verb in "${verbs[@]}"; do
			_compgen "$verb" "${verb_to_objects[$verb]#\ }"
		done
		_compgen '*' -f
		_write $'  esac'
		_write $'}'
		_write $'complete -r splunk 2>/dev/null'
    _write $'complete -F %q splunk' "$completion_function"
	) > "$tempfile"

	unset -f "$completion_function"
	# shellcheck disable=SC1090
	. "$tempfile" || eval "$(FAIL $? "sourcing the completion function failed")"
}

if [[ -n "$sourced" ]]; then
	tmpfile="$(mktemp)"
	write_temp_file "$tmpfile"
	# shellcheck disable=SC1090
	. "$tmpfile"
	rm -f "$tmpfile"
	DEBUG "SOURCED!"
elif [[ -n "$1" ]]; then
	write_temp_file "$1"
else
	write_temp_file /dev/stdout
fi


