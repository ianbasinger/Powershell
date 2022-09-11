All of powershell scripts I'm working on that I find useful. A lot of them follow a similar naming convention. Main idea is to put them in your PS profile so you can use them like you would with any PS cmdlet. Mostly QOL scripts that save you time or help you get things done quicker for daily tasks

Vast majority of them are for AD useage such as resetting a password, bulk resetting a password list, and other stuff. Also network troubleshooting for WAN or LAN issues, WLAN as well.

Want to add the functions to a profile?

if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}

Create new .ps1 profile where you can offload all the functions into one profile for ease of use and store the new functions into memory.
