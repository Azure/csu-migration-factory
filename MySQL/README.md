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
MySQL Client - https://dev.mysql.com/downloads/installer/<br />
Azure CLI (For Single Server and Microsoft Entra ID authentication only) - https://aka.ms/installazurecliwindows )<br /> 

***Linux***<br />
Powershell - https://learn.microsoft.com/en-us/powershell/scripting/install/install-rhel?view=powershell-7.4<br /> 
MySQL Client - https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install-linux-quick.html<br />
Azure CLI (For Single Server and Microsoft Entra ID) - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux/<br /> 

**Note**: - Add PATH in Enviornment Variables<br />

***Windows***<br />
Azure CLI  ( e.g. C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin )<br />
MySQL Client ( e.g. C:\Program Files\MySQL\bin )<br />

***Linux***<br />
Azure CLI  ( e.g. /usr/bin/az )<br />
MySQL Client ( e.g. /usr/bin/mysql )<br />

## Step1. Azure CLI Info Gathering (Only for Azure Database for MySQL Single Servers)
1.	Download the package zip file named `MySQL-Info-Gather.zip`
2.	Extract the `unzip MySQL-Info-Gather.zip` file.
3.	Open the Input file `Azure_Subscription.csv` (Provide the Tenant ID & Subscription ID, add Multiple rows for Multiple Subscriptions)  
4.	Execute `powershell.exe .\CMF-MySQL-CLI-Windows.ps1` (Windows)
5.  Execute `pwsh ./CMF-MySQL-CLI-Linux.ps1` (Linux)
6.	Once the execution completed, you can check the output & Logs folder.

    Note:- Script support Multiple Subscription within single tenant. If you have multiple Tenent, follow each steps for individual Tenant.<br />
    For any reason if you need to re-execute "CMF-MySQL-CLI-Windows.ps1" script again...
    Rename or clear the "output" folder before each execution to prevent overwritten output.

## Step2. Update CMF_MySQL_Server_Input_file.csv (For All Servers)
"**Host_Name**","Resource_Group","**Port**","VCore","Auth_Type","**User_ID**","**Password**","**DB_Name**","Tenant","Subscription_ID","**Approval_Status**","SSL_Mode"

**Note:-**<br />
. Highlighted are **Mandatory Fields**<br />
. Update Mandatory fields manually in case of Azure VM / On-premises Servers <br />
. If a **Password** is not provided, this requires interactive console input of the password for each server. 
. For credentials handling methods refer to [Passing credentials](#passing-credentials)
<br />

## Step3. MySQL Server Info Gathering (For All Servers)
1.	Execute `powershell.exe .\CMF-MySQL-Windows.ps1` ( Windows )
2.  Execute `pwsh ./CMF-MySQL-Linux.ps1` ( Linux )
3.	Once the execution completed, you can check the output & Logs folder.

## Step4. Azure VM/On-premises Servers  (Only for On-Premises / Azure VM / Other Cloud Servers)
. Refer document `CMF-ON-Prem_Server_Info_gather.docx` from the zip folder and update details and share document.<br />

fullyQualifiedDomainName| sku.capacity | storageProfile.storageMb | sku.tier | version | name | region | location | ha |read_replica | environment | server_type | migration_path | approved

Note:- Update CMF_MySQL_Server_List.csv file as per above format and ensure “name” matching with "logfilename".

       sku.capacity = Cores
       storageProfile.storageMb = Memory
       name = logfilename
       sku.tier = AWS_RDS_General_Purpose, AWS_RDS_Memory_Optimized, AWS_Aurora_General_Purpose, AWS_Aurora_Memory_Optimized, GCP_CloudSQL_Enterprise, Azure_VM, GCP_VM, AWS_VM, Onprem_VM, K8s_Cluster_Node

## Step5. Zip and share output, log folders (For All Servers) 
Kindly follow the execution instructions mentioned in attached documents. 
If there is/are any queries, please let us know, we will connect and check.


## Step6. Azure CLI Info Gathering Post Migration  (For All Servers)
1. Open the Input file `Azure_Subscription.csv` (Provide the Tenant ID & Subscription ID, add Multiple rows for Multiple Subscriptions)
2. Execute `powershell.exe .\CMF-MySQL-PostCLI-Windows.ps1` (Windows)
3. Execute `pwsh ./CMF-MySQL-PostCLI-Linux.ps1` (Linux)
4. Once the execution completed, you can check the output & Logs folder.

**Disclaimer:**
These scripts are intended for use of Info Gather Assessment utility and do not interact with the user databases or gather any sensitive information (e.g passwords, PI data etc.). 
These scripts are provided as-is to merely capture metadata information ONLY. While every effort has been made to ensure that accuracy and reliability of the scripts, 
it is recommended to review and test them in a non-production environment before deploying them in a production environment.
It is important to note that these scripts should be modified with consultation of Microsoft.


# Passing credentials
Credentials handling method depends on customer requirements and relevant `CMF_MySQL_Server_Input_file.csv` input file settings

* Default  
    * user - set `User_ID` field to user name  
    * password - leave  `Password` field empty for interactive password prompt during scrpt execution 
* Unattended
    * user - set `User_ID` field to user name  
    * password - set `Password` field to the user password
* Microsoft Entra ID 
    * user - set `User_ID` field to user name  (this has to be interactive user because script can get an access token for the current account only)
    * password - leave  `Password` field empty 
    * authentication type - set `Auth_Type` to `entraid` value

# Appendix - Manual script execution
Incase system don't have powershell installed or user dont have permission to install on host machine executing these script
Below batch file can be executed to gather the database level info.

Step1. Create and Update CMF_MySQL_Server_Input_file.csv (For All Servers)
"**Host_Name**","Resource_Group","**Port**","VCore","Auth_Type","**User_ID**","**Password**","**DB_Name**","Tenant","Subscription_ID","**Approval_Status**","SSL_Mode"
Step2. Open CMD prompt with Run as Admin  
Step3. Execute `CMF-Mysql-Manual-Windows.bat`( Windows )
        Execute `sh ./CMF-Mysql-Manual-Linux.txt`( Linux )



 
## MySQL single to MySQL Flexible server migration using Azure CLI
# Steps To-Do:

1.	If you have "CMF_MySQL_Server_Input_file.csv" input file ready which cointains single server info, go to step 3 
	otherwise proceed with next step to generate the input CSV file.

2. 	Execute `powershell .\CMF-MySQL-CLI-Windows.ps1` on command prompt.(for Windows )
	Execute `pwsh .\CMF-MySQL-CLI-Windows.ps1`(for Linux )
	This will generate the CSV input file - "CMF_MySQL_Server_Input_file.csv".
	Also this will generate the single server info/log to output folder.
   	
3. 	Open the Inut file "CMF_MySQL_Server_Input_file.csv" make sure correct server data with approved columns. 
   	Mandatory fields are listed below...
	
4. 	Once input CSV file "CMF_MySQL_Server_Input_file.csv" was verified...
	execute  `powershell .\CMF-MySQL_Azure_SingleServer_to_Flexible.ps1` on command prompt.(for Windows )
	Execute `pwsh CMF-MySQL_Azure_SingleServer_to_Flexible.ps1`(for Linux )

5.	Once the execution completed, review final status table.Also you can check the output & Logs folder.

## more info
. Please refer to document “CMF - MySQL_Azure_Single_Server_to_Flexible - User Guide V1.0.docx” from the zip folder for more details.

## Update CMF_MySQL_Server_Input_file.csv 

"**Host_Name**","Resource_Group","**Port**","VCore","**User_ID**","**Password**","Auth_Type","**DB_Name**","Tenant","Subscription_ID","**Approval_Status**","SSL_Mode","SSL_Cert","**Migration_mode**","**Destination**","Tier","sku-name","storage-size","admin-user","admin-password"

 Note:- **Mandatory Fields** 

       
