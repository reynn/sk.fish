# Because of scoping rules, to capture the shell variables exactly as they are, we must read
# them before even executing _sk_search_variables. We use psub to store the
# variables' info in temporary files and pass in the filenames as arguments.
# # This variable is global so that it can be referenced by sk_configure_bindings and in tests
set --global _sk_search_vars_command '_sk_search_variables (set --show | psub) (set --names | psub)'

# Install the default bindings, which are mnemonic and minimally conflict with fish's preset bindings
sk_configure_bindings

# If SK_DEFAULT_OPTS is not set, then set some sane defaults. This also affects sk outside of this plugin.
# See https://github.com/junegunn/sk#environment-variables
if not set --query SK_DEFAULT_OPTS
    # cycle allows jumping between the first and last results, making scrolling faster
    # layout=reverse lists results top to bottom, mimicking the familiar layouts of git log, history, and env
    # border makes clear where the sk window begins and ends
    # height=90% leaves space to see the current command and some scrollback, maintaining context of work
    # preview-window=wrap wraps long lines in the preview window, making reading easier
    # marker=* makes the multi-select marker more distinguishable from the pointer (since both default to >)
    # set --global --export SK_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
end

# Doesn't erase sK_DEFAULT_OPTS BECAUSE Too hard to tell if it was set by the user or by this plugin
# Doesn't erase autoloaded _sk_* functions because they are not easily accessible once key bindings are erased
function _sk_uninstall --on-event sk_uninstall
    _sk_uninstall_bindings

    set --erase _sk_search_vars_command
    functions --erase _sk_uninstall _sk_uninstall_bindings sk_configure_bindings

    set_color --italics cyan
    echo "sk.fish uninstalled"
    set_color normal
end
