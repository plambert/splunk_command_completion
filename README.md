# Splunk command completion for bash

Splunk comes with `$SPLUNK_HOME/share/splunk/cli-command-completion.sh` which sets up bash completion for the splunk command.

Many thanks to "Vainstein K" for the original script.

This script is intended to reduce fragility, and avoid many common reasons the original might not run.  (For example, because it uses SHLVL to decide
if it has been sourced or executed, it cannot be sourced from a script that isn't the top level script...)

I've rewritten it somewhat and also, to make it faster, I include the generated completion function in this repository for direct use.

# How to install and use on Mac OS X

The easiest way to install it and keep it up to date is with [Homebrew](https://brew.sh):

```bash
% brew install plambert/splunk/splunk-bash-completion
```

# How to use on Linux (or Mac OS X without Homebrew):

Source the `splunk` script into your shell:

```bash
% source ./splunk
```

# How to rebuild

Make sure SPLUNK_HOME is set and exported, and then run the bin/splunk-command-completion.sh script:

```bash
% bin/splunk-command-completion.sh ./splunk-bash-completion.bash
```

