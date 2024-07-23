# I have grown tired of copying my dotvim to remote servers
# and never wanted to do that with a shared account (e.g., root)
#
# Run gawk -f generate_tame_vim.awk home/.vimrc
#
# And then copy the output into a Command Snippet like described
# here for Windows Terminal (or similar for iTerm2, Konsole, etc.)
#
# https://github.com/microsoft/terminal/issues/6412#issuecomment-964343941
#

/^" keep_for_tame_vim$/ {
	keep=1
	next
}

/^\s*$/ {
	keep=0
}

{
	if(keep==1) {
		printf "%s\\r",
		       gensub(/^(.*\S)\s[^\"]*\".*$/,
		              "\\1",
		              1)
	}
}

END {
	print ":echo 'Vim successfully tamed'\\r"
}
