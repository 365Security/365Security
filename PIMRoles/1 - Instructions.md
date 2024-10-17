**TECHNICAL REQUIREMENTS**

- These scripts were built and tested in PowerShell 7 Core, but will work in Powershell 5.0/5.1.
- If the Microsoft Graph module is not installed, run **Install-Module Microsoft.Graph**
  - Note that your EDR software may take a while to scan the imported modules at runtime.

**DISCLAIMER:**
Group names are for consistency, the reference to "PIM" is Priveliged Identity Management but don't worry if this is not enabled in your environment.

If the scripts just don't work for you, please add the groups manually and assign the below roles to the group.

Role | Group
--- | ---
| Attribute Assignment Reader | A-PIM-AttributeAssignmentReaders
| Attribute Definition Reader | A-PIM-AttributeDefinitionReader
| Attribute Log Reader | A-PIM-AttributeLogReaders
| Directory Readers | A-PIM-DirectoryReaders
| Global Reader | A-PIM-GlobalReaders
| Message Center Privacy Reader | A-PIM-MessageCenterPrivacyReader
| Message Center Reader | A-PIM-MessageCenterReader
Reports Reader | A-PIM-ReportsReader
| Security Reader | A-PIM-SecurityReader

**INSTRUCTIONS:**

- Download each script as a .ps1 file

[**PIMRoles.ps1**](https://github.com/365Security/365Security/raw/refs/heads/main/PIMRoles/PIMRoles.ps1)

[**AddM365Users.ps1**](https://github.com/365Security/365Security/raw/refs/heads/main/PIMRoles/AddM365Users.ps1)

**Running PIMRoles.ps1**
This script will create the above Roles and Groups in your environment.
- Run PIMRoles.ps1 in Microsoft Terminal (or at least a PowerShell 5/5.1 session)
  - Microsoft PowerShell ISE is not supported
 - When prompted during the running of the script - sign in with an M365 Global Admin account and consent, DO **NOT** TICK "Approve for Entire Organsation"

**Running AddM365Users.ps1**
This script will add the users that you specify to the groups requested above.
**IMPORTANT - You need to edit** the AddM365Users.ps1 script to reflect the users requested, these users must **not** be guest users.
- Run AddM365users.ps1 in Microsoft Terminal (or at least a PowerShell 5/5.1 session)
 - Microsoft PowerShell ISE is not supported
- When prompted during the running of the script - sign in with an M365 Global Admin account and consent, DO **NOT** TICK "Approve for Entire Organsation"

**POST-RUN VERIFICATION**
- After the scripts have run - do a manual review of your M365 Entra groups and locate the "A-PIM..." groups, check that the users have been added to these groups correctly.


PIMRoles.ps1 script workflow:

    - Import the Microsoft Graph Module
    
    - Ask for authentication
    
    - Create Groups that have the Entra role assignment ability
    
    - Assign the required read-only roles to the groups just created.
    
    - Report on successes and failures

AddM365Users.ps1 script workflow:

    - Import the Microsoft Graph Module
    
    - Ask for authentication
    
    - Create users with random passwords
    
    - Assign to groups
    
    - Report on successes and failures
