#====================================================================Start of function====================================================================#
# Function is a switch condition setup for troubleshooting. Basic stuff that you can do with some number commands to conduct some troubleshooting
# If you wish to use the WLAN portion, you need to launch PS with elevated admin privledges
function Get-NetworkTroubleshoot
    {
        ipconfig /all

        # Quick ipconfig to show us some basic starting info before proceeding, check for APIPA or any other issues here for example, check DNS and DHCP etc and more

        do  {   
                try {$ip_address_ethernet = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet).IPAddress}
                catch {Write-Host "No Ethernet adapter detected, unable to get IPv4 address" -ForegroundColor Red}
                # This gets our IPv4 address for the Ethernet interface to use for troubleshooting
                $Title = 'Network Troubleshooting'
                Write-Host "================$Title================" -ForegroundColor Cyan
                Write-Host "Your IPv4 Ethernet address is: $ip_address_ethernet" -ForegroundColor Green
                Write-Host "1: Press '1' to Ping loopback address on local computer" -ForegroundColor Yellow
                Write-Host "2: Press '2' to Ping a destination IP" -ForegroundColor Yellow
                Write-Host "3: Press '3' for a Tracert on a destination IP" -ForegroundColor Yellow
                Write-Host "4: Press '4' for a Ping from local computer to 3 DNS servers to check DNS resolution" -ForegroundColor Yellow
                Write-Host "5: Press '5' for a Ping from local computer to Ping 3 external destination IP addresses to check connectivity" -ForegroundColor Yellow
                Write-Host "6: Press '6' for WLAN report of local computer" -ForegroundColor Yellow
                Write-Host "7: Press '7' for Network Adapters of local computer" -ForegroundColor Yellow
                Write-Host "8: Press '8' for List of reachable neighbors on network" -ForegroundColor Yellow
                Write-Host "9: Press '9' to get IPv4 address of local computer" -ForegroundColor Yellow
                Write-Host "10: Press '10' to get a full ipconfig report" -ForegroundColor Yellow
                Write-Host "11: Press '11' to get IP addresses that were leased by DHCP" -ForegroundColor Yellow
                Write-Host "Q: Press 'Q' to quit." -ForegroundColor Red
                $selection = Read-Host "Please make a selection"

            switch ($selection)
                    {

                    '1' {
                            Test-Connection 127.0.0.1 | Write-Output
                            # ICMP Ping to check physical layer problems, checks loopback or localhost interface
                            pause
                        }
                    
                    '2' {
                            $hostname1 = Read-Host "Please enter the destination IP you want to ping"
                            Test-NetConnection $hostname1 -InformationLevel Detailed | Write-Output
                            # ICMP Ping to check a destination IP address, can use this to ping default gateway for example # $hostname1 is the destination IP

                            pause
                        }

                    '3' {

                            $hostname2 = Read-Host "Please enter the destination IP you want to conduct a trace on"
                            Test-NetConnection $hostname2 -TraceRoute |
                                Select -ExpandProperty TraceRoute |
                                ForEach-Object {
                                    Resolve-DnsName $_ -type PTR -ErrorAction SilentlyContinue
                                    # Conducts tracert on a destination IP address or DNS name  # $hostname2 is the destination IP
                            }
                        }

                    '4' {
                            Write-Host "Attempting to resolve DNS names..."
                            # Start of ICMP ping to external DNS names to see if DNS resolution is working
                                if (Test-Connection -Quiet google.com)
                                        {
                                        Write-Host "DNS Resolution for Google.com was successfull, stopping test" -ForegroundColor Green
                                        }
                                        else
                                        {
                                        Write-Host "DNS Resolution for Google.com was unsuccessfull, trying another.." -ForegroundColor Red
                                if (Test-Connection -Quiet quad9.com)
                                        {
                                        Write-Host "DNS Resolution for Quad9.com was successfull, stopping test" -ForegroundColor Green
                                        }
                                        else
                                        {
                                        Write-Host "DNS Resolution for Quad9.com was unsuccessfull, trying another.." -ForegroundColor Red
                                if (Test-Connection -Quiet one.one.one.one)
                                        {
                                        Write-Host "DNS Resolution for Cloudflare.com was successfull, stopping test" -ForegroundColor Green
                                        }
                                        else
                                        {
                                        Write-Host "DNS Resolution for Cloudflare.com was unsuccessfull, that is 3 providers with this issue. DNS is most likely not working on this device" -ForegroundColor Red
                                        }
                                    }
                                }
                            }
                        # End of ICMP ping to external DNS names to see if DNS resolution is working
                    '5'{
                        Write-Host "Attempting to ping an external destination IP address.."
                        # Beginning of ICMP ping external destination IP addresses to check for network connectivity
                            if (Test-Connection -Quiet 1.1.1.1)
                                    {
                                    Write-Host "Ping for 1.1.1.1 was successfull, stopping test" -ForegroundColor Green
                                    }
                                    else
                                    {
                                    Write-Host "Ping for 1.1.1.1 was unsuccessfull, trying another.." -ForegroundColor Red
                            if (Test-Connection -Quiet 8.8.8.8)
                                    {
                                    Write-Host "Ping for 8.8.8.8 was successfull, stopping test" -ForegroundColor Green
                                    }
                                    else
                                    {
                                    Write-Host "Ping for 8.8.8.8 was unsuccessfull, trying another.." -ForegroundColor Red
                            if (Test-Connection -Quiet 9.9.9.9)
                                    {
                                    Write-Host "Ping for 9.9.9.9 was successfull, stopping test" -ForegroundColor Green
                                    }
                                    else
                                    {
                                    Write-Host "Ping for 3 seperate destination IPs was unsuccessfull, most likely issue with device" -ForegroundColor Red
                                    }
                                }
                            }
                        }
                        # End of ICMP ping external destination IP addresses to check for network connectivity
                    '6'{
                        netsh wlan show wlanreport
                        # Generates a WLAN report (Wireless only) and saves to C:\ProgramData\Microsoft\Windows\WlanReport -- saves .html file and open on browser of choice to view WLAN report
                            }

                    '7' {
                        Get-NetAdapter
                        # Gets network adapters
                            }
                    '8' {
                        Get-NetNeighbor
                        # Gets nearest neighbors with ARP
                            }
                    '9' {
                        Get-NetIPConfiguration Select-Object -Property IPv4Address | Write-Output
                        # Grabs local IPv4 addresses
                            }
                    '10' {
                        Get-NetIPConfiguration | Write-Output
                        # Gets all IP addresses
                            }
                    '11' {
                        Get-NetIPAddress -PrefixOrigin Dhcp | Select PSComputerName, IPAddress | Write-Output
                        # Get all IP addresses that were leased via DHCP and filter 2 parameters
                            }
                        
                        pause {
                        }
                } # end >>> switch ($selection)
                } # end >>> do
                until ($selection -eq 'q')
        # End of entire function
    }
#====================================================================End of function====================================================================#

#====================================================================Start of function====================================================================#
# This function will conduct some common network troubleshooting, and is meant to be ran locally on the computer. It goes in order from the OSI layer starting at the physical layer
function Get-NetworkTest
    {
        Write-Host "This will conduct network troubleshooting in order from : Loopback test, Gateway test, RFC1918 Public IP Ping test, DNS resolving test, and will stop at whichever step it failed" -ForegroundColor Yellow

        try {$ip_address_ethernet = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet).IPAddress}
                catch {Write-Host "No Ethernet adapter detected, unable to get IPv4 address" -ForegroundColor Red}

                if ($ip_address_ethernet.StartsWith('169.254'))
                {
                    Write-Host "You have an APIPA link local address, check DHCP scope or other issues relating to DHCP, your address won't be routable and you can only reach intranet"
                }


        Write-Host "Your IPv4 Ethernet address is: $ip_address_ethernet" -ForegroundColor Green
        #====================================================================Start of loopback test====================================================================#
        Write-Host "Conducting loopback test to 127.0.0.1..."
        
        if (Test-Connection -Quiet 127.0.0.1)
            # ICMP Ping to check physical layer problems, checks loopback or localhost interface, if this is down then most likely issue with NIC or drivers potentially
            {
            Write-Host "Loopback test to 127.0.0.1 successfull, loopback is working" -ForegroundColor Green
            }
            else
            {
            Write-Host "Loopback test to 127.0.0.1 unsuccessfull, loopback isn't working" -ForegroundColor Red
            }
        #====================================================================End of loopback test====================================================================#

        #====================================================================Start default gateway test====================================================================#
        $defaultgateway = Get-WmiObject -Class Win32_IP4RouteTable | 
        where { $_.destination -eq '0.0.0.0' -and $_.mask -eq '0.0.0.0'} | 
        Sort-Object metric1 | select nexthop, metric1, interfaceindex | Select-Object -First 1 | Select-Object -ExpandProperty nexthop
        # This pulls up Windows registry keys and looks for the IPv4 route table, pulls the table and selects the highest metric (so first priority default gateway)
        # After pulling default gateway and most likely candidate, filters down to first IP address and selects it, puts into variable to be used for ping

        Write-Host "Pinging default gateway..."

            if(Test-Connection -Quiet $defaultgateway)
            # ICMP ping to default gateway to see if we can even reach the gateway, if not then WAN connectivity isn't likely
            {
                Write-Host "Default gateway was reachable, no issue reaching default gateway" -ForegroundColor Green
            }
            else
            {
                Write-Host "Default gateway was unreachable, issue reaching default gateway" -ForegroundColor Red
            }
        #====================================================================End of default gateway test====================================================================#

        #====================================================================Start of public IP test====================================================================#
                Write-Host "Attempting to ping a public IP address.."
                # ICMP ping to external destination IP addresses to check for network connectivity
            if (Test-Connection -Quiet 1.1.1.1)
            {
                Write-Host "Ping for 1.1.1.1 was successfull, stopping test" -ForegroundColor Green
            }
            else
            {
                Write-Host "Ping for 1.1.1.1 was unsuccessfull, trying another.." -ForegroundColor Red
            if (Test-Connection -Quiet 8.8.8.8)
            {
                Write-Host "Ping for 8.8.8.8 was successfull, stopping test" -ForegroundColor Green
            }
            else
            {
                Write-Host "Ping for 8.8.8.8 was unsuccessfull, trying another.." -ForegroundColor Red
            if (Test-Connection -Quiet 9.9.9.9)
            {
                Write-Host "Ping for 9.9.9.9 was successfull, stopping test" -ForegroundColor Green
            }
            else
            {
                Write-Host "Ping for 3 seperate destination IPs was unsuccessfull, most likely issue with device" -ForegroundColor Red
                    }
                }
            }
        #====================================================================End of public IP test====================================================================#

        #====================================================================Start of DNS test====================================================================#
            Write-Host "Attempting to resolve DNS names..."
            # ICMP ping to external DNS names to see if DNS resolution is working
            if (Test-Connection -Quiet google.com)
            {
                Write-Host "DNS Resolution for Google.com was successfull, stopping test" -ForegroundColor Green
            }
            else
            {
                Write-Host "DNS Resolution for Google.com was unsuccessfull, trying another.." -ForegroundColor Red
            if (Test-Connection -Quiet quad9.com)
            {
                Write-Host "DNS Resolution for Quad9.com was successfull, stopping test" -ForegroundColor Green
            }
            else
            {
                Write-Host "DNS Resolution for Quad9.com was unsuccessfull, trying another.." -ForegroundColor Red
            if (Test-Connection -Quiet one.one.one.one)
            {
                Write-Host "DNS Resolution for Cloudflare.com was successfull, stopping test" -ForegroundColor Green
            }
            else
            {
                Write-Host "DNS Resolution for Cloudflare.com was unsuccessfull, that is 3 providers with this issue. DNS is most likely not working on this device" -ForegroundColor Red

        #====================================================================End of DNS test====================================================================#
            }
        }
    }
}
#====================================================================End of function====================================================================#

#====================================================================Start of function====================================================================#
# Function Generates strong password within certain complexity limits, outputs to PS console
function Get-StrongPassword ([Parameter(Mandatory=$true)][int]$PasswordLength)
    {
        Add-Type -AssemblyName System.Web
        $PassComplexCheck = $false
        do {
        $newPassword=[System.Web.Security.Membership]::GeneratePassword($PasswordLength,1)
        If ( ($newPassword -cmatch "[A-Z\p{Lu}\s]") `
        -and ($newPassword -cmatch "[a-z\p{Ll}\s]") `
        -and ($newPassword -match "[\d]") `
        -and ($newPassword -match "[^\w]")
        )
        {
        $PassComplexCheck=$True
        }
        } While ($PassComplexCheck -eq $false)
        return $newPassword
    }
#====================================================================End of function====================================================================#


#====================================================================Start of function====================================================================#
# This will reset an AD password for a single user, just type username into console to reset
function Get-ADPasswordReset
    {
        try {$samAccountName = Read-Host -Prompt "Enter AD Account Name for Password Reset Here"}
        catch {Write-Host "Error: $($_.Exception.Message)"; return}

        # Warning confirmation on the change, Y/N to confirm
        
        Write-Warning "Confirm the information is correct before proceeding, this is a single password reset" -WarningAction Inquire

        # Forced to input AD account name that needs a reset

        $newPassword = ConvertTo-SecureString -AsPlainText "Password" -Force

        # Password change to the new password specified

        Set-ADAccountPassword -Identity $samAccountName -NewPassword $newPassword -Reset

        # Calls on the new password listed above

        try {Set-AdUser -Identity $samAccountName -ChangePasswordAtLogon $true}
        catch {Write-Host "Error: $($_.Exception.Message)"; return}

        # Forces user to change password at next login

        Write-Host " AD Password has been reset for: "$samAccountName

        # Writes to PS window stating the changes took affect

        Set-Clipboard "Reset to $newPassword"

        # Copy text to clipboard to put in a ticket or something else
    }
#====================================================================End of function====================================================================#

#====================================================================Start of function====================================================================#
# Function to bulk reset AD accounts from a .csv file and the password is specified, this is good if you want them to set their own on next login
function Get-ADPasswordResetBulk
    {
        $newPassword = ConvertTo-SecureString -AsPlainText "Password" -Force
        # Password change to the new password specified. "Password" is where you need to put whichever password you want them all set to

        $csvDir = Read-Host -Prompt "Please enter the directory where the .csv file is"
        # User prompt to specify directory for the .csv file that has the list of users with a password reset needed. You NEED to pass the full directory and include file name or you will get Access is not enabled.
        Import-Csv "$csvDir" | ForEach-Object {
        # Import from .csv file

        $samAccountName = $_."samAccountName"

        Write-Warning "Confirm the information is correct before proceeding, this is a bulk password reset" -WarningAction Inquire
        # Confirmation on the change, Y/N to confirm, so no mistakes or accidents happen.

        # Un-comment the below line if your CSV file includes password for all users
        # $newPassword = ConvertTo-SecureString -AsPlainText $_."Password"  -Force <--- This line mentioned ^^ above

        Set-ADAccountPassword -Identity $samAccountName -NewPassword $newPassword -Reset
        # Calls on the new password listed above.

        Set-AdUser -Identity $samAccountName -ChangePasswordAtLogon $true
        # Forces user to change password at next login.

        Write-Host " AD Password has been reset for: "$samAccountName
        # Writes to PS window stating the changes took affect.
        }
    }
#====================================================================End of function====================================================================#

#====================================================================Start of function====================================================================#
# Function to bulk reset a specified .csv file to reset a bunch of AD users, and generates complex unique password for each of them
function Get-ADPasswordResetBulkComplex
    {
        Add-Type -AssemblyName System.Web
        # Import System.Web assembly

        [System.Web.Security.Membership]::GeneratePassword(11,2)
        Function GenerateStrongPassword ([Parameter(Mandatory=$true)][int]$PasswordLength)
        # Generate random password with defined complex requirements
        {
        Add-Type -AssemblyName System.Web
        $PassComplexCheck = $false
        do {
        $newPassword=[System.Web.Security.Membership]::GeneratePassword($PasswordLength,1)
        If ( ($newPassword -cmatch "[A-Z\p{Lu}\s]") `
        -and ($newPassword -cmatch "[a-z\p{Ll}\s]") `
        -and ($newPassword -match "[\d]") `
        -and ($newPassword -match "[^\w]")
        )
        {
        $PassComplexCheck=$True
        }
        } While ($PassComplexCheck -eq $false)
        return $newPassword
        }

        $csvDir = Read-Host -Prompt "Please enter the directory where the .csv file is"
        # User prompt to specify directory for the .csv file that has the list of users with a password reset needed. You NEED to pass the full directory and include file name or you will get Access is not enabled.

        Import-Csv "$csvDir" | ForEach-Object {
        #Import from .csv file

        $samAccountName = $_."samAccountName"

        #Un-comment the below line if your CSV file includes password for all users
        #$newPassword = ConvertTo-SecureString -AsPlainText $_."Password"  -Force <--- ^^^ Line mentioned above

        Write-Warning "Confirm the information is correct before proceeding, this is a bulk complex password reset" -WarningAction Inquire
        # Warning confirmation on the change, Y/N to confirm

        Set-ADAccountPassword -Identity $samAccountName -NewPassword $newPassword -Reset
        # Calls on the new password listed above

        Set-AdUser -Identity $samAccountName -ChangePasswordAtLogon $true
        # Forces user to change password at next login.

        Write-Host " AD Password has been reset for: "$samAccountName
        # Writes to PS window stating the changes took affect.

    }
}
#====================================================================End of function====================================================================#


#====================================================================Start of function====================================================================#
function Get-ADLockoutCheck
# Function to check if an AD user is locked out, bad password attempts, when last logged in to a domain computer, and when password was last set
    {
        $ADusername = Read-Host -Prompt "Enter AD Account Name Here"
        # Input AD username or it's also called samAccountName to specify the variable to search the AD for $samAccountName

        try{Get-ADUser $ADusername -Properties AccountLockoutTime,LastBadPasswordAttempt,BadPwdCount,LockedOut}
        catch{Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red}
        # Checks last bad password attempts and locked out and duration of lockout as well

        try{Get-ADUser -Identity $ADusername -Properties PasswordLastSet | ft Name, PasswordLastSet}
        catch{Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red}
        # Check when password was last set, gives date and time

        try{Get-ADUser -Identity $ADusername -Properties LastLogon | Select Name, @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}}}
        catch{Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red}
        # Checks to see when they logged in last on a computer on the domain
    }
#====================================================================End of function====================================================================#


#====================================================================Start of function====================================================================#
# This function will change a users AD location and OU, updates office field as well
function Get-ADLocationChange

{
    Write-Host "Script to move a single AD user to another OU and update their Office field" -ForegroundColor Cyan
    $ADusername = Read-Host "Please enter samAccountName for the user that needs to be moved"
    $targetpath = Read-Host "Please enter the OU directory they need to be moved to"

    try{Get-ADUser -Identity $ADusername | Move-ADObject -TargetPath "$targetpath"}
    catch{Write-Host "Error moving user to new OU, please check the OU path and try again"}
    # This will move them to another OU, $targetpath is the OU directory you need to declare
    try{Get-ADUser -Filter $ADusername -SearchBase "$targetpath" -Properties l | Foreach {Set-ADUser $_ -Office $_.l -whatif}}
    catch{Write-Host "Error updating office field, please check the OU path and try again"}
    # This updates the office field
}
#====================================================================End of function====================================================================#

#====================================================================Start of function====================================================================#
# Function compares 2 AD usernames and will tell you what AD groups they both have in common, and which ones they have that are different
function Get-ADGroupCompare
    {
        Write-Host "Compares 2 AD user accounts for group membership" -ForegroundColor Magenta

        $Identity1 = $input = $(Write-Host "Please enter AD User 1" -NoNewLine) + $(Write-Host " EX: John.Smith " -ForegroundColor Green -NoNewLine; Read-Host)

        $Identity2 = $input = $(Write-Host "Please enter AD User 2" -NoNewLine) + $(Write-Host " EX: Jacob.Ryan " -ForegroundColor Red -NoNewLine; Read-Host)

        try{$user1 = (Get-ADPrincipalGroupMembership -Identity $Identity1 | select Name | Sort-Object -Property Name).Name}
        catch{Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red; return}
        Write-Verbose ($user1 -join "; ")

        $user2 = (Get-ADPrincipalGroupMembership -Identity $Identity2 | select Name | Sort-Object -Property Name).Name
        Write-Verbose ""
        Write-Verbose ($user2 -join "; ")

        $SameGroups = (Compare-Object $user1 $user2 -PassThru -IncludeEqual -ExcludeDifferent)

        Write-Verbose ""
        Write-Verbose ($SameGroups -join "; ")

        $UniqueID1 = (Compare-Object $user1 $user2 -PassThru | where {$_.SideIndicator -eq "<="})
        Write-Verbose ""

        Write-Verbose ($UniqueID1 -join "; ")
        $UniqueID2 = (Compare-Object $user1 $user2 -PassThru | where {$_.SideIndicator -eq "=>"})

        Write-Verbose ""
        Write-Verbose ($UniqueID2 -join "; ")
        try{$ID1Name = (Get-ADUser -Identity $Identity1 | Select Name).Name}
        catch{Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red; return}
        Write-Verbose ""
        Write-Verbose ($ID1Name -join "; ")
        try{$ID2Name = (Get-ADUser -Identity $Identity2 | Select Name).Name}
        catch{Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red; return}
        Write-Verbose ""
        Write-Verbose ($ID2Name -join "; ")

        Write-Host "--------------------------------------------------------------------------" -ForegroundColor Magenta
        Write-Host "[$ID1Name] and [$ID2Name] have the following groups in common:"
        Write-Host "--------------------------------------------------------------------------" -ForegroundColor Magenta
        $SameGroups
        Write-Host ""

        Write-Host "--------------------------------------------------------------------------" -ForegroundColor Green
        Write-Host "The following groups are unique to [$ID1Name]:"
        Write-Host "--------------------------------------------------------------------------" -ForegroundColor Green
        $UniqueID1
        Write-Host ""
        Write-Host "--------------------------------------------------------------------------" -ForegroundColor Red
        Write-Host "The following groups are unique to [$ID2Name]:"
        Write-Host "--------------------------------------------------------------------------" -ForegroundColor Red
        $UniqueID2
    }
#====================================================================End of function====================================================================#

#====================================================================Start of function====================================================================#
# Function is ran to gather information on a computer. Lots of information including TPM info, BIOS version, hardware stats, network stats, etc. 
# Reminder to myself to see about adding more info if possible, monitor/display settings and potentially audio device settings as well. Not sure if possible. 8/25
function Get-ADComputerInfo
    {
        $ComputerName = Read-Host -Prompt "Enter computer name"
        try{Get-ADComputer $ComputerName}
        catch{Write-Host "Computer not found"}
        try{Get-ComputerInfo $ComputerName}
        catch{Write-Host "Computer not found"}
        try{Get-Tpm $ComputerName}
        catch{Write-Host "Computer not found"}

        if(!$ComputerName)
        {
        $ComputerName = $env:COMPUTERNAME
        $filter = '^cim|^PSComp'
        }

        Foreach($computer in $ComputerName)
        {
        $CimParams = @{
        Namespace = 'root\wmi'
        ClassName = 'wmimonitorid'
        }

        if($computer -notmatch $env:COMPUTERNAME)
        {
        $CimParams.Add('ComputerName',$computer)
        $filter = '^cim'
        }

        Get-CimInstance @CimParams | ForEach {
        $_.psobject.Properties | where name -notmatch $filter | ForEach -Begin {$ht = [ordered]@{}} -Process {
        $value = if($_.value -is [System.Array]){[System.Text.Encoding]::ASCII.GetString($_.value)}else{$_.value}
        $ht.add($_.name,$value)
        } -End {[PSCustomObject]$ht}
                                            }
        }
    }
#====================================================================End of function====================================================================#

#====================================================================Start of function====================================================================#
# This will check a computers (AD joined only) last login date. Function is small currently and I will add more checks and functionality, currently there isn't much utility.
function Get-ADComputerLastLogin
    {
        $computername = Read-Host "Enter the computer name here"
        # $computername is the AD distinguished name for the computer object that you will give it
        try{Get-ADComputer $computername -Properties * | Sort LastLogon | Select Name, LastLogonDate,@{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}}}}
        catch{Write-Host "Computer not found"}
        # Checks for lastlogon date and filters down to just what we need to see
    }
#====================================================================End of function====================================================================#