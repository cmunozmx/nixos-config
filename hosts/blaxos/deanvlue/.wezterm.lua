-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Wezterm status plugin with Clock - jcmm
wezterm.plugin
.require("https://github.com/yriveiro/wezterm-status")
.apply_to_config(config, {
  cells = {
    hostname = { enabled = true },
    date = { format = '%H:%M'}
  }
})

-- This is where you actually apply your config choices.
config.ssh_domains = {
	{
		-- Identify the domain server
		name = "mm",
		-- The hostname or address to connect to
		remote_address = "devmacmini.home",
		-- username in the remote host
		username = "deanvlue",
	},
}

config.leader={
  key = 's',
  mods = 'CTRL',
  timeout_miilliseconds = 2000,
}

config.keys = {
  {
    key = ".",
    mods ="LEADER",
    action  = wezterm.action.ActivateCopyMode
  },
  {
    key = "f",
    mods = 'ALT',
    action = wezterm.action.TogglePaneZoomState,
  },
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
  {
    key = 'H',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'J',
    mods = 'LEADER',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },
	{
		key = "UpArrow",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Prev"),
	},
	{
		key = "DownArrow",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
    {
    key = 'l',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = '!',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(win, pane)
      local mux = wezterm.mux
      local current_window_id = win:mux_window():window_id()
      local choices = {}

      for _, w in ipairs(mux.all_windows()) do
        local wid = w:window_id()
        if wid ~= current_window_id then
          local title = w:get_title()
          local tab_count = #w:tabs()
          table.insert(choices, {
            id = tostring(wid),
            label = 'Window ' .. wid .. ': ' .. title .. ' (' .. tab_count .. ' tabs)',
          })
        end
      end

      if #choices == 0 then
        wezterm.log_info('No other windows to move tab to')
        return
      end

      win:perform_action(
        wezterm.action.InputSelector {
          title = 'Move tab to window',
          choices = choices,
          action = wezterm.action_callback(function(_win, _pane, id, label)
            if not id then
              return
            end
            wezterm.run_child_process {
              'wezterm', 'cli', 'move-pane-to-new-tab',
              '--pane-id', tostring(_pane:pane_id()),
              '--window-id', id,
            }
          end),
        },
        pane
      )
    end),
  },
}

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

config.prefer_egl = true

-- or, changing the font size and color scheme.
config.font_size = 11
-- config.color_scheme = 'AdventureTime'
config.color_scheme = "Liquid Carbon (Gogh)"
config.window_background_opacity = 0.955555

-- tab bar at bottom
config.tab_bar_at_bottom = true

config.window_frame = {
  -- Font used in tab bar
  font = wezterm.font{ family = 'JetBrains Mono', weight='Bold'},
  -- Size of the font
  font_size = 8.0,
  active_titlebar_bg = '#ee8d08',
  inactive_titlebar_bg = '#323232',
}

-- Change titlebar color when connected via SSH
wezterm.on('update-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local domain = pane:get_domain_name()

  if domain ~= 'local' then
    overrides.window_frame = {
      font = wezterm.font{ family = 'JetBrains Mono', weight='Bold'},
      font_size = 8.0,
      active_titlebar_bg = '#2e86c1',
      inactive_titlebar_bg = '#323232',
    }
  else
    overrides.window_frame = nil
  end

  window:set_config_overrides(overrides)
end)

config.colors = {
  tab_bar = {
    -- color of innactive tab bar edge/divider
    inactive_tab_edge = '#576453'
  }
}

-- Disable notifications

config.notification_handling = "NeverShow"

-- Finally, return the configuration to wezterm:
return config
