
#Login no Azure

 Connect-AzAccount -UseDeviceAuthentication  

# Parametro - gerais 

$rg = "rg-vmwin"
$local = "brazilsouth"

#Paramentros - VM

$vm = "vm-win"
$sku = "Standard_B2s"
$img = "Win2019Datacenter"
$ip = "ip-vm"
$nsg = "nsg-vm"

# Parametros - Credenciais

$user = "azureuser"
$pass = ConvertTo-SecureString "T3b4rr4@230581" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user,$pass);

# Criar Grupo de Recursos

New-AzResourceGroup -Name $rg -Location $local


# Cria Vm com Windows Server


New-AzVM -Name $vm -ResourceGroupName $rg -Credential $cred -Image $img -PublicIpAddressName $ip -Size $sku -Location $local

#Selecionar Nsg Criado

$nsg = Get-AzNetworkSecurityGroup -Name $vm -ResourceGroupName $rg 

# Liberar porta 80 - Parametro 


$Params = @{

    "Name"                                  = "allowHTTP"
    "NetworkSecurityGroup"                  = $nsg
    "Protocol"                              = "TCP"
    "Direction"                             = "Inbound"
    "Priority"                              = 100
    "SourceAddressPrefix"                   = "Internet"
    "SourcePortRange"                       = "*"
    "DestinationAddressPrefix"              = "*"
    "DestinationPortRange"                  = 80  
    "Access"                                = "Allow"

}

#Adcionr Regra ao NSG

Add-AzNetworkSecurityRuleConfig @Params | Set-AzNetworkSecurityGroup


#Instalar ISS Web Server

Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName $vm -CommandId 'RunPowerShellScript' -ScriptString 'Install-WindowsFeature -Name Web-Server i IncludeManagementTools'

#Listar IP 

Get-AzPublicIpAddress -ResourceGroupName $rg -Name $ip | select ipAddress #4.201.180.26


#Entrar no Site # Ocorreu erro ao fazer esse Script

curl 4.201.180.26

# Alterar Html no IIS web Server  # Ocorreu erro ao fazer esse Script

Set-AzVMExtension -ResourceGroupName  $rg -ExtensionName "IIS" -VMName $vm -Location $local -Publisher Microsoft.Compute ` 

    -ExtensionType CustomScriptExtension -TypeHandlerVersion 1.8`
    -SettingString '{"commandToExecute";"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Defaul.htm\" -Value $($env:computername"}'


# Excluir Grupo de Recursos

Remove-AzResourceGroup -Name $rg





    






