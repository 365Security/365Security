# Import the Microsoft Graph module
Import-Module Microsoft.Graph

# Connect to Microsoft Graph (interactive login - Use Global Admin role)
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

# Function to generate a random 13-character password
function Get-RandomPassword {
    $uppercase = "ABCDEFGHKLMNOPRSTUVWXYZ".tochararray()
    $lowercase = "abcdefghiklmnoprstuvwxyz".tochararray()
    $number = "0123456789".tochararray()
    $special = "!@#$%^&*()_-+={}[]".tochararray()

    $password = ($uppercase | Get-Random -Count 2) -join ''
    $password += ($lowercase | Get-Random -Count 6) -join ''
    $password += ($number | Get-Random -Count 3) -join ''
    $password += ($special | Get-Random -Count 2) -join ''
    
    # Shuffle the password characters
    $passwordArray = $password.ToCharArray()
    $passwordArray = $passwordArray | Get-Random -Count $passwordArray.Length
    $password = -join $passwordArray

    return $password
}

# The rest of the script remains unchanged
# Define the groups
$groups = @(
    "A-PIM-AttributeAssignmentReaders",
    "A-PIM-AttributeDefinitionReader",
    "A-PIM-AttributeLogReaders",
    "A-PIM-DirectoryReaders",
    "A-PIM-GlobalReaders",
    "A-PIM-MessageCenterPrivacyReader",
    "A-PIM-MessageCenterReader",
    "A-PIM-ReportsReader",
    "A-PIM-SecurityReader"
)

# Define user data
$users = @(
    @{
        DisplayName = "Alice Johnson"
        UserPrincipalName = "alice.johnson@yourdomain.com"
        Groups = $groups
    },
    @{
        DisplayName = "Bob Smith"
        UserPrincipalName = "bob.smith@yourdomain.com"
        Groups = $groups
    }
)

$results = @()

foreach ($user in $users) {
    $result = [PSCustomObject]@{
        DisplayName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        Created = $false
        Password = ""
        AssignedGroups = @()
        Error = $null
    }

    try {
        # Generate a random password
        $password = Get-RandomPassword

        # Create the user
        $newUser = New-MgUser -DisplayName $user.DisplayName -UserPrincipalName $user.UserPrincipalName -MailNickname $user.UserPrincipalName.Split("@")[0] -AccountEnabled -PasswordProfile @{
            Password = $password
            ForceChangePasswordNextSignIn = $true
        }

        $result.Created = $true
        $result.Password = $password

        # Assign user to groups
        foreach ($groupName in $user.Groups) {
            $group = Get-MgGroup -Filter "displayName eq '$groupName'"
            if ($group) {
                New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $newUser.Id
                $result.AssignedGroups += $groupName
            }
            else {
                $result.Error += "Group not found: $groupName. "
            }
        }
    }
    catch {
        $result.Error = $_.Exception.Message
    }

    $results += $result
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph

# Output results
Write-Host "`nUser Creation and Group Assignment Results:" -ForegroundColor Cyan
$results | Format-Table -AutoSize

Write-Host "`nSuccessfully Created Users:" -ForegroundColor Green
$results | Where-Object { $_.Created } | Select-Object DisplayName, UserPrincipalName, Password | Format-Table -AutoSize

Write-Host "Group Assignments:" -ForegroundColor Green
$results | ForEach-Object {
    Write-Host "$($_.DisplayName) ($($_.UserPrincipalName)):" -ForegroundColor Yellow
    $_.AssignedGroups | ForEach-Object { Write-Host "  - $_" }
}

Write-Host "`nErrors:" -ForegroundColor Red
$results | Where-Object { $_.Error } | Select-Object DisplayName, UserPrincipalName, Error | Format-Table -AutoSize
