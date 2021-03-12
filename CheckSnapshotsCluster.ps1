Param(
#Clustername
[Parameter(Mandatory=$True)]
[string]$cluster
)


$collection = @()

$nodes = Get-ClusterNode -Cluster $cluster

foreach($n in $nodes){

    $vms = Get-VM -ComputerName $n.Name
    
        foreach($vm in $vms){
        
           $snapshot = Get-VMSnapshot -VMName $vm.Name -ComputerName $n.Name

           foreach($snap in $snapshot){
           
                      if($snapshot -notlike $null){
                      $itens = New-Object psobject
                      $itens | Add-Member NoteProperty -Name "VM Name:" -Value $snap.VMName
                      $itens | Add-Member NoteProperty -Name "Vm Node:" -Value $n
                      $itens | Add-Member NoteProperty -Name "Snapshot name:" -Value $snap.Name

                      $collection += $itens
              }
           
           }



                            }

}

$collection