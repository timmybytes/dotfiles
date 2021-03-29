#!/usr/bin/python3
# Script to load coding practice websites through default browser

import webbrowser
import subprocess
import time

tab_a = "https://www.codewars.com/dashboard"
tab_b = "https://www.codecademy.com/learn"
tab_c = "https://exercism.io/users/auth/github"
tab_d = "https://freecodecamp.org"

subprocess.run(
    ["open", "/Applications/Firefox.app"]
)

# Delay; ensures all tabs load in same window
time.sleep(.7)

webbrowser.open_new_tab(tab_a)
webbrowser.open_new_tab(tab_b)
webbrowser.open_new_tab(tab_c)
webbrowser.open_new_tab(tab_d)
