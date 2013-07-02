#!/bin/sh

echo '{"version":1}'

# Begin endless array
echo '['

# Send empty array first to make loop simpler
echo '[],'

# No send information
exec conky -c $HOME/.config/conky/conkyrc
