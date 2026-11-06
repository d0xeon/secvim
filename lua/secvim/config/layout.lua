return {
  -- Commands for the three terminal panes. Leave a value empty to open an
  -- interactive shell in that pane instead.
  --
  --   run   = top-right     (build / execute / dev server)
  --   tests = bottom-right  (test runner / watch mode)
  --   logs  = bottom-left   (logs, AI CLI, notes)
  commands = {
    run = '',
    tests = '',
    logs = '',
  },
  -- Width of the code pane, 0.0-1.0. 0.5 gives an even 2x2 grid.
  code_width = 0.5,
  -- Start typing immediately when focus enters a terminal pane.
  focus_insert = true,
}
