
# Import the Microsoft Graph module
Import-Module Microsoft.Graph

# Connect to Microsoft Graph (interactive login - Use Global Admin role)
Connect-MgGraph -Scopes "Group.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

# Define the group and role mappings
$groupRoleMappings = @"
Role,Group
Attribute Assignment Reader,A-PIM-AttributeAssignmentReaders
Attribute Definition Reader,A-PIM-AttributeDefinitionReader
Attribute Log Reader,A-PIM-AttributeLogReaders
Directory Readers,A-PIM-DirectoryReaders
Global Reader,A-PIM-GlobalReaders
Message Center Privacy Reader,A-PIM-MessageCenterPrivacyReader
Message Center Reader,A-PIM-MessageCenterReader
Reports Reader,A-PIM-ReportsReader
Security Reader,A-PIM-SecurityReader

"@ | ConvertFrom-Csv

foreach ($mapping in $groupRoleMappings) {
    # Create the group
    $group = New-MgGroup -IsAssignableToRole:$true -DisplayName $mapping.Group -MailEnabled:$false -SecurityEnabled:$true -MailNickname $mapping.Group

    # Fetch the role definition ID for the given role
    $roleDefinition = Get-MgRoleManagementDirectoryRoleDefinition -Filter "displayName eq '$($mapping.Role)'"
    if ($null -eq $roleDefinition) {
        Write-Host "Role '$($mapping.Role)' not found." -ForegroundColor Red
        continue
    }

    # Assign the group to the role
    $roleAssignmentParams = @{
        PrincipalId = $group.Id
        RoleDefinitionId = $roleDefinition.Id
        DirectoryScopeId = '/'
    }

    New-MgRoleManagementDirectoryRoleAssignment -BodyParameter $roleAssignmentParams
    Write-Host "Group '$($mapping.Group)' created and assigned to role '$($mapping.Role)'."
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph
