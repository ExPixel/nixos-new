{ config, lib, pkgs, ... }:
let
    cfg = config.expixel.home.tmux;
in {
    options.expixel.home.tmux = {
        enable = lib.mkEnableOption "Tmux";
    };

    config = lib.mkIf cfg.enable {
        programs.tmux.enable = true;
        programs.tmux.shell = "${config.home.profileDirectory}/bin/fish";
        programs.tmux.plugins = [
            {
                plugin = pkgs.tmuxPlugins.gruvbox;
                extraConfig = ''
                    set -g @tmux-gruvbox 'dark'
                '';
            }
            pkgs.tmuxPlugins.sensible
        ];
        programs.tmux.extraConfig = ''
            unbind C-b
            set-option -g prefix C-a
            bind-key C-a send-prefix

            set   -g  mouse on
            set   -g  history-limit 5000
            set   -g  base-index 1
            setw  -g  pane-base-index 1
            set   -g  renumber-windows on
            set   -g  default-terminal "tmux-256color"
            set   -gs escape-time 10
            set-option -sa terminal-features ',xterm-256color:RGB'

            ### keybindings
            bind-key r    source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux configuration"
            bind-key k    send-keys -R \; clear-history
            bind-key \`   switch-client -t'{marked}'
            bind-key "|"  split-window -h -c "#{pane_current_path}"
            bind-key "\\"   split-window -fh -c "#{pane_current_path}"
            bind-key "-"  split-window -v -c "#{pane_current_path}"
            bind-key "_"  split-window -fv -c "#{pane_current_path}"
            bind-key c    new-window -c "#{pane_current_path}"
            bind-key Space  last-window
            bind-key z    resize-pane -Z

            bind-key h select-pane -L; bind-key C-h select-pane -L
            bind-key j select-pane -D; bind-key C-j select-pane -D
            bind-key k select-pane -U; bind-key C-k select-pane -U
            bind-key l select-pane -R; bind-key C-l select-pane -R

            bind-key -r C-S-J resize-pane -D 15
            bind-key -r C-S-K resize-pane -U 15
            bind-key -r C-S-H resize-pane -L 15
            bind-key -r C-S-L resize-pane -R 15

            bind-key -n C-S-Left  swap-window -t -1\; select-window -t -1
            bind-key -n C-S-Right swap-window -t +1\; select-window -t +1

            bind -T root F12  set prefix None \; set key-table off \; if -F '#{pane_in_mode}' 'send-keys -X cancel' \; refresh-client -S \;
            bind -T off F12 set -u prefix \; set -u key-table \; refresh-client -S

            ### keybindigs-copy-mode
            set-window-option -g mode-keys vi
            bind-key -T copy-mode-vi v send -X begin-selection
            bind-key -T copy-mode-vi V send -X select-line
            bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
        '';
    };
}
