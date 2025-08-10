config = config # type: ignore
c = c # type: ignore

config.load_autoconfig(False)

# Settings
config.set("colors.webpage.darkmode.enabled", True)
config.set("fonts.default_size", "16pt")
config.set("fonts.default_family", "Agave")
config.set("tabs.padding", {"bottom": 10, "left": 10, "right": 10, "top": 10})
config.set("statusbar.padding", {"bottom": 10, "left": 10, "right": 10, "top": 10})
config.set("completion.shrink", True)
config.set("confirm_quit", ["always"])

# Keybindings
config.bind("<Cmd-d>", "scroll-page 0 2.0")
config.bind("<Cmd-u>", "scroll-page 0 -2.0")

config.unbind('d')
config.bind('d', 'cmd-set-text :tab-close')

config.bind('td', 'open -t about:blank ;; home')
config.bind('tt', 'open -t about:blank ;; cmd-set-text --space :open')
config.bind('tb', 'open -t about:blank ;; cmd-set-text --space :bookmark-load')

config.bind('<Cmd-e>r', 'config-source ;; message-info "Reloaded config"')

config.bind("<Cmd-,>", "tab-prev")
config.bind("<Cmd-.>", "tab-next")

for m in ['command', 'prompt']:
    config.bind('<Cmd-n>', 'completion-item-focus next', mode=m)
    config.bind('<Cmd-p>', 'completion-item-focus prev', mode=m)
    config.bind('<Ctrl-n>', 'completion-item-focus next', mode=m)
    config.bind('<Ctrl-p>', 'completion-item-focus prev', mode=m)

# Theme
import catppuccin
catppuccin.setup(c, 'mocha', True)
