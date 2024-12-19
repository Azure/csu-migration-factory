# Steps To-Do:<br />

**OS Support**<br />
This script is compatible with the following operating systems:<br />
Windows 10 or later<br />
Linux RHEL v7 or later , Ubuntu v14 or later<br />

**Pre-requisites**<br />

Execute below prior running Powershell scripts<br />
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass

***Windows***<br />
Powershell -   https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4<br /> 
PostgreSQL Client - https://www.postgresql.org/download/windows/ <br />
Azure CLI (Only for Single Server) - https://aka.ms/installazurecliwindows )<br /> 

***Linux***<br />
Powershell - https://learn.microsoft.com/en-us/powershell/scripting/install/install-rhel?view=powershell-7.4<br /> 
PostgreSQL Client - https://www.postgresql.org/download/linux/ <br />
Azure CLI (Only for Single Server) - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux/<br /> 

**Note**: - Add PATH in Enviornment Variables<br />

***Windows***<br />
Azure CLI  ( e.g. C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin )<br />
PostgreSQL Client ( e.g.  C:\Program Files\PostgreSQL\bin )<br />

***Linux***<br />
Azure CLI  ( e.g. /usr/bin/az )<br />
PostgreSQL Client ( e.g. /usr/bin/psql )<br />


## Step1. Azure CLI Info Gathering (Only for Azure Database for PostgreSQL Single Servers)
1. Download the package zip file named `PostgreSQL-Info-Gather.zip`
2. Extract the `unzip PostgreSQL-Info-Gather.zip` file.
3. Open the Input file `Azure_Subscription.csv` (Provide the Tenant ID & Subscription ID, add Multiple rows for Multiple Subscriptions)  
4. Execute `powershell.exe .\CMF-PostgreSQL-CLI-Windows.ps1` (Windows)
5. Execute `pwsh ./CMF-PostgreSQL-CLI-Linux.ps1` (Linux)
6. Once the execution completed, you can check the output & Logs folder.

    Note:- Script support Multiple Subscription within single tenant. If you have multiple Tenent, follow each steps for individual Tenant.<br />
    For any reason if you need to re-execute "CMF-PostgreSQL-CLI-Windows.ps1" script again...
    Rename or clear the "output" folder before each execution to prevent overwritten output.

## Step2. Update CMF_PostgreSQL_Server_Input_file.csv (For All Servers)
 "**Host_Name**","Resource_Group","**Port**","VCore","Auth_Type","**User_ID**","**Password**","**DB_Name**","Tenant","Subscription_ID","**Approval_Status**","**SSL_Mode**"

**Note:-**<br />
. Highlighted are **Mandatory Fields**<br />
. Update Mandatory fields manually in case of Azure VM / On-premises / Other Cloud Servers <br />
. If a **Password** is not provided, this requires interactive console input of the password for each server. <br />

## Step3. PostgreSQL Server Info Gathering (For All Servers)
1. Execute `powershell.exe .\CMF-PostgreSQL-Windows.ps1` ( Windows )
2. Execute `pwsh ./CMF-PostgreSQL-Linux.ps1` ( Linux )
4. Once the execution completed, you can check the output & Logs folder.

    Note:- 
    Choose option - 1. Perform PostgreSQL server Information gathering, to extract Server and DB level information.
    This data will be used for assessment.
    Option 2 - Perform Detailed Information gathering.(Optional)

## Step4. Azure VM/On-premises Servers  (Only for On-Premises / Azure VM / Other Cloud Servers)
. Refer document `CMF-ON-Prem_Server_Info_gather.docx` from the zip folder and update details and share document.<br />

fullyQualifiedDomainName| sku.capacity | storageProfile.storageMb | sku.tier | version | name | region | location | ha |read_replica | environment | server_type | migration_path | approved

Note:- Update CMF_PostgreSQL_Server_List.csv file as per above format and ensure “name” matching with "logfilename".

       sku.capacity = Cores
       storageProfile.storageMb = Memory
       name = logfilename
       sku.tier = AWS_RDS_General_Purpose, AWS_RDS_Memory_Optimized, AWS_Aurora_General_Purpose, AWS_Aurora_Memory_Optimized, GCP_CloudSQL_Enterprise, Azure_VM, GCP_VM, AWS_VM, Onprem_VM, K8s_Cluster_Node

## Step5. Zip and share output, log folders (For All Servers) 
Kindly follow the execution instructions mentioned in attached documents. 
If there is/are any queries, please let us know, we will connect and check.

## Step6. Azure CLI Info Gathering Post Migration  (For All Servers)
1. Open the Input file `Azure_Subscription.csv` (Provide the Tenant ID & Subscription ID, add Multiple rows for Multiple Subscriptions)  
2. Execute `powershell.exe .\CMF-PostgreSQL-PostCLI-Windows.ps1` (Windows)
3. Execute `pwsh ./CMF-PostgreSQL-PostCLI-Linux.ps1` (Linux)
4. Once the execution completed, you can check the output & Logs folder.

**Disclaimer:**
These scripts are intended for use of Info Gather Assessment utility and do not interact with the user databases or gather any sensitive information (e.g passwords, PI data etc.). 
These scripts are provided as-is to merely capture metadata information ONLY. While every effort has been made to ensure that accuracy and reliability of the scripts, 
it is recommended to review and test them in a non-production environment before deploying them in a production environment.
It is important to note that these scripts should be modified with consultation of Microsoft.
