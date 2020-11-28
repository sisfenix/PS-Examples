########################################################
#### Script para recuperar os usuarios de uma       ####
####  estrutura de pastas                           ####
#### Linguagem: PowerShel 4.0                       #### 
#### Criado em 27/11/2020                           ####
#### Revisão: 01                                    ####
#### Copyright (c) 2020 by Alan Lopes               ####
########################################################
# 27/11/2020 - VERSAO INICIAL                          #
########################################################

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

Get-ChildItem . -directory | # RECUPERA A LISTA DE PASTA NO CAMINHO CORRENTE
 ForEach-Object {
    cd $_
    Get-ChildItem . -directory | # RECUPERA A LISTA DE PASTA NO CAMINHO CORRENTE
     Get-Acl | # RECUPERA A LISTA DE USUARIOS COM ACESSO A PASTA
      Select @{Name='Path'; Expression={Convert-Path $_.Path}} -ExpandProperty Access | 
       ForEach-Object {$_ | 
        Select  Path, @{Name='Group'; Expression ={$_.IdentityReference }}, @{n='Permission';e={$_.FileSystemRights}}
       } #| Where-Object {$_.Group -notlike "*NT AUTHORITY*" -and  $_.Group -notlike "*BUILTIN*" } # RETIRA DA LISTA OS USUARIOS PADRAO DO SISTEMA (PODE COMENTAR)
         
    cd ..
   } #| Export-Csv -NoTypeInformation -Encoding UTF8 C:\Users\<user>\Desktop\exportXXX.csv #(PODE COMENTAR)

   
