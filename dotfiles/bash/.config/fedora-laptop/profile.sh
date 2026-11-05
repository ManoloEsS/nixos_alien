profile_env="${XDG_CONFIG_HOME:-$HOME/.config}/fedora-laptop/profile.env"
if [[ -r "$profile_env" ]]; then
  # shellcheck disable=SC1090
  source "$profile_env"
fi
