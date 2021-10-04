local wezterm = require 'wezterm';
return {
  -- color_schme = "Tomorrow Night Bright",

  colors = {
      -- The default text color
      foreground = "#eaeaea",
      -- The default background color
      background = "black",

      -- Overrides the cell background color when the current cell is occupied by the
      -- cursor and the cursor style is set to Block
      cursor_bg = "white",
      -- Overrides the text color when the current cell is occupied by the cursor
      cursor_fg = "black",
      -- Specifies the border color of the cursor when the cursor style is set to Block,
      -- of the color of the vertical or horizontal bar when the cursor style is set to
      -- Bar or Underline.
      cursor_border = "white",

      -- the foreground color of selected text
      selection_fg = "black",
      -- the background color of selected text
      selection_bg = "#fffacd",

      -- The color of the scrollbar "thumb"; the portion that represents the current viewport
      scrollbar_thumb = "#222222",

      -- The color of the split lines between panes
      split = "#444444",

      ansi = {"#000000", "#d54e53", "#b9ca4a", "#e6c547", "#7aa6da", "#c397d8", "#70c0ba", "#eaeaea"},
      brights = {"#666666", "#ff3334", "#9ec400", "#e7c547", "#7aa6da", "#b77ee0", "#54ced6", "#ffffff"},
  },
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  disable_default_key_bindings = true,
  use_ime = true,
  font_size = 9,
  font = wezterm.font_with_fallback({
    "Sarasa Mono SC"
      -- "Iosevka",
      -- "Microsoft Yahei"
  }),
  keys = {
    {key="Insert", mods="CTRL|SHIFT", action="Paste"},
    {key="Insert", mods="SHIFT", action="PastePrimarySelection"},
  },
  scrollback_lines = 10000,
  -- default_prog = {"/usr/bin/tmux", "new-session"},
  window_padding = {
    left = 20,
    right = 20,
    top = 10,
    bottom = 10,
  }
}
