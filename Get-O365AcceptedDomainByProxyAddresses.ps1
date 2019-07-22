#    Get-O365AcceptedDomainByProxyAddresses.ps1
#
#    This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  
#    THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,        
#    INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#    We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute
#    the object code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks
#    to market Your software product in which the Sample Code is embedded; (ii) to include a valid copyright notice on
#    Your software product in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us
#    and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or resultfrom the 
#    use or distribution of the Sample Code.
#    Please note: None of the conditions outlined in the disclaimer above will supersede the terms and conditions contained 
#    within the Premier Customer Services Description.
#
#

$inputObject = Get-Mailbox -ResultSize Unlimited -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Import-PSSession (New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Authentication Basic -Credential $global:Credential -SessionOption (New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck)  -AllowRedirection) -Prefix O365 -AllowClobber | Out-Null
$arr = @()
($inputObject).emailaddresses | Where-Object{$_.PrefixString -eq "smtp"} | Select-Object SmtpAddress | ForEach-Object{$addr = $_.SmtpAddress.Split("@");$arr += $addr[1]}
$domains = $arr | Select-Object -Unique
$arr = @()
$domains | Where-Object{If(Get-O365AcceptedDomain $_ -ErrorAction SilentlyContinue){$obj = New-Object PSObject;$obj | Add-Member -Value $_ -Name "Accepted Domain" -MemberType NoteProperty;$obj | Add-Member -Value "Found" -Name "Status" -MemberType NoteProperty;$arr += $obj}else{$obj = New-Object PSObject;$obj | Add-Member -Value $_ -Name "Accepted Domain" -MemberType NoteProperty;$obj | Add-Member -Value "Not Found" -Name "Status" -MemberType NoteProperty;$arr += $obj}}
$arr

Get-PSSession | Remove-PSSession -Confirm:$false