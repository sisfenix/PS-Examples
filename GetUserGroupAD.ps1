########################################################
#### Script para recuperar os membros dos grupos    ####
####  do dominio gerado pelo script                 ####
####  ListUserFolder.ps1                            ####
#### Linguagem: PowerShel 4.0                       ####
#### Criado em 27/11/2020                           ####
#### Revisão: 01                                    ####
#### Copyright (c) 2020 by Alan Lopes               ####
########################################################
# 27/11/2020 - VERSAO INICIAL                          #
######################################################## 

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' 

Import-Csv .\export2.csv  |  #ARQUIVO EXPORTADO DO SCRIPTI ListUserFolder.ps1
ForEach-Object{ 
        $var_Path = $_
        Get-ADGroupMember -Identity $_.Group.Split("\")[1] | ForEach-Object{
            
            # CRIA UMA OBJETO PERSONALIZADO
            $varResult = New-Object -TypeName PSObject
            $varResult | Add-Member -Name 'Caminho' -MemberType Noteproperty -Value $var_Path.Path
            $varResult | Add-Member -Name 'Grupo' -MemberType Noteproperty -Value $var_Path.Group.Split("\")[1]
            $varResult | Add-Member -Name 'Nome' -MemberType Noteproperty -Value $_.Name
            $varResult | Add-Member -Name 'Login' -MemberType Noteproperty -Value $_.SamAccountName

            # TESTA SE EH USUARIO OU GRUPO
            if ($_.objectClass -notlike "group"){
                $varResult | Add-Member -Name 'Tipo' -MemberType Noteproperty -Value $_.objectClass
                # TESTA SE O USUARIO ESTA ATIVO NO DOMINIO
                if (Get-ADUser -Filter { SamAccountName -eq $_.SamAccountName } -Properties * |Select-Object -ExpandProperty Enabled){
                    $varResult | Add-Member -Name 'Status' -MemberType Noteproperty -Value 'Enabled'
                }else{
                    $varResult | Add-Member -Name 'Status' -MemberType Noteproperty -Value 'Disabled'
                }
            }else{
                $varResult | Add-Member -Name 'Tipo' -MemberType Noteproperty -Value $_.objectClass
                $varResult | Add-Member -Name 'Status' -MemberType Noteproperty -Value '---'
            }

            Write-Output $varResult 
        }    
} |
#Where-Object {$_.Nome -notlike "SPO_SHARE_DFS_ARQUIVOS_CORPORATIVOS_ADM_CONTRATOS_BRASIL_ALL_RW" -and  $_.Nome -notlike "*SPO_SHARE_DFS_ARQUIVOS_CORPORATIVOS_ADM_CONTRATOS_BRASIL_ALL_R*" } #(PODE COMENTAR)
Export-Csv -NoTypeInformation -Encoding UTF8 saida.csv #(PODE COMENTAR)
