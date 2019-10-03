# Splunk command completion for bash

Splunk comes with `$SPLUNK_HOME/share/splunk/cli-command-completion.sh` which attempts to set up
bash completion for the splunk command.

This script is fragile, and often fails to run.  (For example, because it uses SHLVL to decide
if it has been sourced or executed, it cannot be sourced from a script that isn't the top level
script...)

I've rewritten it somewhat and also, to make it faster, I include the generated completion function
in this repository for direct use.

# How to use

Source the splunk-bash-completion.bash script into your shell:

```bash
% source ./splunk-bash-completion.bash
```

# How to rebuild

Make sure SPLUNK_HOME is set and exported, and then run the bin/splunk-command-completion.sh script:

```bash
% bin/splunk-command-completion.sh ./splunk-bash-completion.bash
```


