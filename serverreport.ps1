#Create a report containing Server Name, Description and SO version, from Active Directory, and total memory.

#List of servers. You can also insert itens using a txt file, with get-content#
$servers = "server1","server2"

#Starts the array
$infoCollection = @()

#Foreach to get every information and put into the array
Foreach($i in $servers){

#You'll need to have the ps ad module, use Install-WindowsFeature RSAT-AD-PowerShell if you dont have it.
$list = Get-ADComputer -Identity $i -Properties * | select Name,Description,OperatingSystem

#Check total memory
$PhysicalMemory = Get-WmiObject CIM_PhysicalMemory -ComputerName $i | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }

#create hte psobject, and add the infos
		$infoObject = New-Object PSObject
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "ServerName" -Value $list.Name
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "Description" -Value $list.Description
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "SO" -Value $list.OperatingSystem
		Add-Member -inputObject $infoObject -memberType NoteProperty -name "TotalPhysical_Memory_GB" -value $PhysicalMemory

		$infoCollection += $infoObject
}
#export the collected information
$infoCollection | export-csv C:\temp\report.csv
