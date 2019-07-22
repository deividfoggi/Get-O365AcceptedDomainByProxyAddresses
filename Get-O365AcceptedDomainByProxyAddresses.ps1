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

########################################################################################################################
# MICROSOFT - PFE Team Brazil
#
# File : Get-O365AcceptedDomainByProxyAddresses.ps1
# Version : 1.0
# Creation date : Jul 15th, 2019
# Modification date : Jul 15th, 2019
#
# Author: Deivid de Foggi - Office 365 PFE
#
# Exchange version: Exchange On Premises and Exchange Online
# 
#########################################################################################################################


Import-PSSession (New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Authentication Basic -Credential $global:Credential -SessionOption (New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck)  -AllowRedirection) -Prefix O365 -AllowClobber | Out-Null
$arr = @()
(get-mailbox -resultsize unlimited).emailaddresses | ?{$_.PrefixString -eq "smtp"} | select SmtpAddress | %{$addr = $_.SmtpAddress.Split("@");$arr += $addr[1]}
$domains = $arr | select -unique
$arr = @()
$domains | %{If(Get-O365AcceptedDomain $_ -ErrorAction SilentlyContinue){$obj = New-Object PSObject;$obj | Add-Member -Value $_ -Name "Accepted Domain" -MemberType NoteProperty;$obj | Add-Member -Value "Found" -Name "Status" -MemberType NoteProperty;$arr += $obj}else{$obj = New-Object PSObject;$obj | Add-Member -Value $_ -Name "Accepted Domain" -MemberType NoteProperty;$obj | Add-Member -Value "Not Found" -Name "Status" -MemberType NoteProperty;$arr += $obj}}
$arr