$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.PROMPT_INDICATOR = " ➜ "
$env.PROMPT_MULTILINE_INDICATOR = "➝ "

$env.PROMPT_COMMAND_RIGHT = {
  let output = (acpi | awk -F': ' '{print $2}' | cut -d',' -f1,2)
  let state = ($output | split row "," | get 0 | str trim)
  let percent = ($output | split row "," | get 1 | str trim | str replace '%' '' | into int)

  let color = match $state {
    "Charging" => (if $percent < 25 { "yellow" } else if $percent < 90 { "green" } else { "blue" })
    "Discharging" => (if $percent < 25 { "red" } else if $percent < 45 { "yellow" } else { "purple" })
    _ => "grey"
  }

  $"(ansi $color)($state) ($percent)%(ansi reset)"
}
