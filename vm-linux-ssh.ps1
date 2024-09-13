# Login Azure 

Connect-AzAccount

#Obter Chave SSH

ssh-keygen -m PEM -t rsa -b 2048 

# Parametros
$rg = "rg-vmLinux"
$local = "brazilsouth"
$vm = "vm-ubuntu"
$sku = "Standard_B2s"
$img = "UbuntuServer"
$imgversion = "18.04-LTS"



# Criar Grupo de Recursos

New-AzResourceGroup -Name $rg -Location $local


# Criar VNET e Subnet

$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name "snet-vm" -AddressPrefix 192.168.1.0/24
$vnet = New-AzVirtualNetwork -ResourceGroupName $rg -Location $Local -Name "vnet-vm" -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig





# Criar Maquina virtual no Azure

New-AzVM -Name $vm -ResourceGroupName $rg -Credential $cred -Image $img -PublicIpAddressName $ip -size $sku -Location $local

# Excluir a VM

Remove-AzResourceGroup -Name $rg

