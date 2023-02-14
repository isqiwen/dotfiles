local wezterm = require("wezterm")

return {
    default_prog = {"/usr/bin/zsh", "-l"},

    default_cwd = "~/",

    font = wezterm.font_with_fallback({
        "Cascadia Code",
        "MesloLGS NF",
    }),
    font_size = 15,


    window_background_opacity = 0.6,
    text_background_opacity = 1.0,

    -- color_scheme = "Batman",
    line_height = 1.0,
    harfbuzz_features = { "ss13" },

    -- some custom styled
    allow_square_glyphs_to_overflow_width = "Always",
    font_antialias = "Subpixel",
    color_scheme = "Gruvbox Dark Hard",
    color_schemes = {
        ["Gruvbox Dark Hard"] = {
            -- The default text color
            foreground = "#ebdbb2",
            -- The default background color
            background = "#1d2021",
            -- Overrides the cell background color when the current cell is occupied by the
            -- cursor and the cursor style is set to Block
            cursor_bg = "#ebdbb2",
            -- Overrides the text color when the current cell is occupied by the cursor
            cursor_fg = "#333333",
            -- Specifies the border color of the cursor when the cursor style is set to Block,
            -- of the color of the vertical or horizontal bar when the cursor style is set to
            -- Bar or Underline.
            cursor_border = "#ebdbb2",
            -- the foreground color of selected text
            selection_fg = "#333333",
            -- the background color of selected text
            selection_bg = "#ebdbb2",
            -- The color of the scrollbar "thumb"; the portion that represents the current viewport
            scrollbar_thumb = "#333333",
            -- The color of the split lines between panes
            split = "#333333",
            ansi = {
                "#282828",
                "#cc241d",
                "#98971a",
                "#d79921",
                "#458588",
                "#b16286",
                "#689d6a",
                "#a89984",
            },
            brights = {
                "#928374",
                "#fb4934",
                "#b8bb26",
                "#fabd2f",
                "#83a598",
                "#d3769b",
                "#8ec07c",
                "#ebdbb2",
            },
        },
    },

    window_frame = {
        -- The font used in the tab bar.
        -- Roboto Bold is the default; this font is bundled
        -- with wezterm.
        -- Whatever font is selected here, it will have the
        -- main font setting appended to it to pick up any
        -- fallback fonts you may have used there.
        font = wezterm.font({ family = "Cascadia Code Semibold" }),

        -- The size of the font in the tab bar.
        -- Default to 10. on Windows but 12.0 on other systems
        font_size = 13.0,

        -- The overall background color of the tab bar when
        -- the window is focused
        active_titlebar_bg = "#333333",

        -- The overall background color of the tab bar when
        -- the window is not focused
        inactive_titlebar_bg = "#333333",

        -- The color of the inactive tab bar edge/divider
        inactive_tab_edge = "#575757",
    },

    colors = {
        tab_bar = {
            -- The color of the strip that goes along the top of the window
            -- (does not apply when fancy tab bar is in use)
            background = "#0b0022",

            -- The active tab is the one that has focus in the window
            active_tab = {
                -- The color of the background area for the tab
                bg_color = "#2b2042",
                -- The color of the text for the tab
                fg_color = "#c0c0c0",

                -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
                -- label shown for this tab.
                -- The default is "Normal"
                intensity = "Normal",

                -- Specify whether you want "None", "Single" or "Double" underline for
                -- label shown for this tab.
                -- The default is "None"
                underline = "None",

                -- Specify whether you want the text to be italic (true) or not (false)
                -- for this tab.  The default is false.
                italic = false,

                -- Specify whether you want the text to be rendered with strikethrough (true)
                -- or not for this tab.  The default is false.
                strikethrough = false,
            },

            -- Inactive tabs are the tabs that do not have focus
            inactive_tab = {
                bg_color = "#1b1032",
                fg_color = "#808080",

                -- The same options that were listed under the `active_tab` section above
                -- can also be used for `inactive_tab`.
            },

            -- You can configure some alternate styling when the mouse pointer
            -- moves over inactive tabs
            inactive_tab_hover = {
                bg_color = "#3b3052",
                fg_color = "#909090",
                italic = true,

                -- The same options that were listed under the `active_tab` section above
                -- can also be used for `inactive_tab_hover`.
            },

            -- The new tab button that let you create new tabs
            new_tab = {
                bg_color = "#1b1032",
                fg_color = "#808080",

                -- The same options that were listed under the `active_tab` section above
                -- can also be used for `new_tab`.
            },

            -- You can configure some alternate styling when the mouse pointer
            -- moves over the new tab button
            new_tab_hover = {
                bg_color = "#3b3052",
                fg_color = "#909090",
                italic = true,

                -- The same options that were listed under the `active_tab` section above
                -- can also be used for `new_tab_hover`.
            },
        },
    },

    native_macos_fullscreen_mode = true,

    initial_cols = 160,
    initial_rows = 50,

    launch_menu = {
        {
            args = { 'top' },
        },
        {
            -- Optional label to show in the launcher. If omitted, a label
            -- is derived from the `args`
            label = 'Bash',
            -- The argument array to spawn.  If omitted the default program
            -- will be used as described in the documentation above
            args = { 'bash', '-l' },

            -- You can specify an alternative current working directory;
            -- if you don't specify one then a default based on the OSC 7
            -- escape sequence will be used (see the Shell Integration
            -- docs), falling back to the home directory.
            -- cwd = "/some/path"

            -- You can override environment variables just for this command
            -- by setting this here.  It has the same semantics as the main
            -- set_environment_variables configuration option described above
            -- set_environment_variables = { FOO = "bar" },
        },
    },

    keys = {
        { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
    },

}
