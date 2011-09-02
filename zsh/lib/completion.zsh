# Turns on completion for . and .. directories.
# Here's a bug report on the issue:
#    http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514152
zstyle ':completion:*' special-dirs true

# Setup a cache so that apt and dpkg completions are usable
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zcache

# Remove the trailing slash when a directory is used as an argument
zstyle ':completion:*' squeeze-slashes true

set show-all-if-ambiguous on
set completion-query-items 1000
set expand-tilde off