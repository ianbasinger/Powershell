All of powershell functions I'm working on that I find useful. A lot of them follow a similar naming convention. Main idea is to put them in your PS profile so you can use them like you would with any PS cmdlet. Mostly QOL functions that save you time or help you get things done quicker for daily tasks. Naming convention is similar to PS cmdelts.

Current Projects :

1. Get-NetTest - This will run a small script to test common tier 1 network troubleshooting. Checks loopback if functional, pulls IPv4 route table and gets default gateway with highest metric, pings it, checks DNS resolution and checks a few external IPs for reachability

2. Get-NetworkTroubleshoot - This is a longer script that can do some of the functionality of Get-NetTest but with more specific options. You can choose a few options from loopback, DNS, external IP, check neighbors with ARP, get network information to name a few.

3. Get-StrongPassword - This will generate a new, random, strong password that checks to see if it's within your orgs password policy. Will return and try again if not.

4. Get-ADPasswordReset - This will reset a single AD account, input from samAccountName and resets to a specified password, will force to change on next login.

5. Get-ADPasswordResetBulk - This will reset a multiple AD accounts, basically same as Get-ADPasswordReset but imports .csv for a bulk reset on list of users.

6. Get-ADPasswordResetBulkComplex - This will reset a multiple AD accounts but with a complex, strong, random password, basically same as Get-ADPasswordResetBulk but with a strong random password

7. Get-ADLockoutCheck - This checks an AD user with samAccountName and will check their last login attempts to a domain computer, will check for bad password attempts, lockout status, and when their AD password was last set. Very useful to quickly check account issues. Functionality to check expiration attribute isn't present in the script currently.

8. Get-ADGroupCompare - This will compare 2 AD users, with samAccountName and will tell you which AD group membership they have in common, and also tells you different groups they are in, in comparison to eachother.

9. Get-ADComputerInfo - This gets basic computer info of a domain joined computer, it will get you TPM, BIOS, Monitor stats, CPU, RAM, HDD, Network stats and a basic overview of the computer.

Want to add the functions to a profile? So you don't have to add them in everytime. Just add them to a .ps1 profile.

if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
}

That will create a new .ps1 profile where you can store all the functions into memory so you can call on them anytime while using PS.
