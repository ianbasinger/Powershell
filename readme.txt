All of powershell scripts I'm working on that I find useful.

Vast majority of them are for AD useage such as resetting a password, bulk resetting a password list, and other stuff.

Want to add the functions to a profile?

if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}

Create new .ps1 profile where you can offload all the functions into one profile for ease of use and store the new functions into memory.
