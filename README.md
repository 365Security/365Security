Hi Team!
This repository has been set up as a temporary sharing environment for basic scripts. 

**PIMRoles.ps1**

This script will set up the Entra Roles required for the requested users to assist in your M365 Security uplift:

Role                            Group
Attribute Assignment Reader     A-PIM-AttributeAssignmentReaders
Attribute Definition Reader     A-PIM-AttributeDefinitionReader
Attribute Log Reader            A-PIM-AttributeLogReaders
Directory Readers               A-PIM-DirectoryReaders
Global Reader                   A-PIM-GlobalReaders
Message Center Privacy Reader   A-PIM-MessageCenterPrivacyReader
Message Center Reader           A-PIM-MessageCenterReader
Reports Reader                  A-PIM-ReportsReader
Security Reader                 A-PIM-SecurityReader


  - Script workflow:
    - Import the Microsoft Graph Module
    - Ask for authentication
    - Create Groups that have the Entra role assignment ability
    - Assign the required read-only roles to the groups just created.

Requirements:
- This script was built and tested in PowerShell 7 Core, but will work in Powershell 5.0/5.1.
- If the Microsoft Graph module is not installed, run **Install-Module Microsoft.Graph**
- If for some reason that you already have A-PIM groups, please change the Group names in the script accordingly.

Instructions:
- Download the script as a .ps1 and run.
- When prompted, sign in with an M365 Global Admin account. DO NOT TICK "Approve for Entire Organsation"
- Even if not successful, there is some default language in the script that will report success.
- After the script has run - Check your Entra groups and locate the "A-PIM..." groups
- Create the requested user accounts and add these accounts to all "A-PIM..." groups 

