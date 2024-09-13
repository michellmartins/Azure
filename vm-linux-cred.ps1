# Login Azure 

Connect-AzAccount

# Parametros
$rg = "rg-vmLinux"
$local = "brazilsouth"
$vm = "vm-ubuntu"
$sku = "Standard_B2s"
$img = "Ubuntu2204"
$ip = "ip-vm"
$user = "azureuser"
$pass = ConvertTo-SecureString "T3b4rr4@230581" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user,$pass);

# Criar Grupo de Recursos

New-AzResourceGroup -Name $rg -Location $local


# Criar Maquina virtual no Azure

New-AzVM -Name $vm -ResourceGroupName $rg -Credential $cred -Image $img -PublicIpAddressName $ip -size $sku -Location $local

# Excluir a VM

Remove-AzResourceGroup -Name $rg

