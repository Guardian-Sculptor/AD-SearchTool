function searchAD{
    param ( [string] $inputValue, [string] $usecase )

    $ADproperties= objectproperties $inputValue

    if ($usecase -eq "searchphone"){
        $output = Get-ADUser -Filter "(TelephoneNumber -eq '$inputValue') -or (mobile -eq '$inputValue') -or (mobilePhone -eq '$inputValue') -or (OfficePhone -eq '$inputValue')" -Properties * | Select $ADproperties
    }elseif ($usecase -eq "searchemail") {
        $output = Get-ADUser -Filter "(Emailaddress -eq '$inputValue' -or mail -eq '$inputValue' -or proxyAddresses -eq 'smtp:$inputValue' -or proxyAddresses -eq 'SIP:$inputValue' )"  -Properties * | Select $ADproperties

    } else {
        $output = Get-ADUser $inputValue -Properties * | Select $ADproperties
    }
    return $output
}

function objectproperties{
    param ( [string] $inputValue )
    $ADproperties = @(
        @{Name='Search Value'; Expression={ $inputValue }},
        'Name',
        'DisplayName',
        'SamAccountName',
        'Emailaddress',
        'Title',
        'Enabled',
        'AccountExpirationDate',
        'TelephoneNumber',
        'PasswordNeverExpires',
        'PasswordExpired',
        'PasswordLastSet',
        'City',
        'CN',
        @{Name='managedObjects'; Expression={$_.managedObjects -join ';'}},
        @{Name='MemberOf'; Expression={$_.MemberOf -join ';'}}
    )
    return $ADproperties
}

function phonenumbercorrection {
    param ( [string] $unique_phonenumber )

    if ($unique_phonenumber -match '\(\d{3}\) \d{3}-\d{4}') {
        $formattedPhoneNumber = $unique_phonenumber

    } elseif ($unique_phonenumber -match '\d{3}-\d{3}-\d{4}') {
        $formattedPhoneNumber = $unique_phonenumber -replace '(\d{3})-(\d{3})-(\d{4})', '($1) $2-$3'

    } elseif ($unique_phonenumber -match '\d{10}') {
        $formattedPhoneNumber = $unique_phonenumber -replace '(\d{3})(\d{3})(\d{4})', '($1) $2-$3'

    } else { 
        return "error"
    }
    return $formattedPhoneNumber
}

function identifytype {
    param ( [string]$input1 )
    $emailPattern = '^[\w\.-]+@[\w\.-]+\.\w+$'
    $phonePattern = '^(?:\(\d{3}\)\s?|\d{3}[-\s]?)\d{3}[-\s]?\d{4}$'
    $usernamePattern = '^[\w\.-]+$'
        
    if ($input1 -match $emailPattern) {
        return "searchemail"
        
    } elseif ($input1 -match $phonePattern) {
        return "searchphone"
        
    } else {
        return "searchusername"
    }   
}

function Process-File {
    param ( [string]$filePath )

    if (Test-Path $filePath) {
        $lines = Get-Content -Path $filePath | Where-Object { $_.Trim() -ne "" } | Sort-Object | Get-Unique
        
        if ($lines.Count -eq 0) {
            Write-Output "The file is empty."
            return 
        }  
            
        foreach ($line in $lines) {
            $line = $line.Trim() 
            $usecase=identifytype $line
            if ($usecase -eq "searchphone") {        
                $line = phonenumbercorrection $line
                if ($line -eq "error") {
                    Write-Output "Error: Invalid phone number format for '$line'"
                    continue
                }
            }
            $result = searchAD $line $usecase
            Write-Output $result
            $result | Export-Csv -Path "Output.csv" -Append -NoTypeInformation -Force
        }
        
    } else {
        Write-Output "File not found: $filePath"
    }
}

Remove-Item -Path "output_test.csv" -ErrorAction SilentlyContinue
Process-File -filePath input.txt

