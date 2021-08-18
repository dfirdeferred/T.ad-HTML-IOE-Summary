 
#################################################################################
# IOE Summary Report.ps1 v.1                                                    #
#                                                                               #
#  IOE Summary Report.ps1 v.1 is will save a rough IOE report in HTML format    #
#                                                                               # 
#                                                                               #
#                     WRITTEN BY: Darryl G. Baker, CISSP, CEH                   #
#                                     for                                       #
#                         Tenable for AD Environments                           #
#################################################################################
 
 
 
 
 param(
    [Parameter()]
        [string]
        $uri = "",
         [string]
         $apikey = '',
         [string]
         $batchsize = '100'
 )

$token = @{'x-api-key'=$apikey}


 
 
 [array]$html = ""

$forests = Invoke-RestMethod -Uri ("https://" + $uri + "/api/infrastructures") -Method GET -Headers $token

$forests | %{
      

    
    [string]$forid = $_.id
    
    $_.name

   $domains =  Invoke-RestMethod -Uri ("https://" + $uri + "/api/infrastructures/$forid/directories") -Method GET -Headers $token
            $domains | %{
                    
                    [string]$dirid = $_.id
                    [string]$dirname = $_.name
                    $body =@{
                        batchSize = $batchsize
                     }
                    $deviances = Invoke-RestMethod -Uri ("https://" + $uri + "/api/infrastructures/1/directories/1/deviances") -Body $body -Method GET -Headers $token 
                    $checkers = Invoke-RestMethod -Uri ("https://" + $uri + "/api/checkers") -Method GET -Headers $token    
                    $arraylist = New-Object -TypeName System.Collections.ArrayList
   
                            
                            $deviances |%{
                                 $num = $_.checkerid
                                 $date = $_.eventDate
                                 $resolved = $_.resolvedAt
                          [array]$attributes = $_.attributes
                         

                                 $checkname = $checkers | ?{$_.id -eq $num} | select name 
                                 $attribjoined = $attributes | foreach {$_ -join ","}
                                 $attribjoined = $attribjoined -join ","
                                 $attribjoined = $attribjoined -replace '@{name='
                                 $properties = @{
                                    IOE           = $checkname.name
                                    EventDate           = $date
                                    ResolvedAt     = $resolved
                                    DeviantObjects = $attribjoined -replace '}' 
                                    }
                                 $obj = New-Object PSObject -Property $properties
            
                                 $arraylist += $obj

                            }
            $devcount = $deviances.count
            $heading = $dirname + "___________________Current Deviance Count:" + $devcount
            $arraysort = $arraylist |sort IOE 
            $html = $arraysort | ConvertTo-Html -As Table -Fragment -PreContent "<h2>$heading</h2>"
            $html = $html -replace "\<table\>",'<table cellpadding="15">'

         

             
          }

           
}

ConvertTo-Html -Title "IOE Report" -Body $html | Out-File c:\users\darryl\desktop\report.html 
c:\users\darryl\desktop\report.html 
            

# SIG # Begin signature block
# MIIFlAYJKoZIhvcNAQcCoIIFhTCCBYECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUUEDFtOgwPM/9vHNj9+IfQGIq
# eHSgggMiMIIDHjCCAgagAwIBAgIQO+B/uXgs+ZJDI4pFwa7Z0DANBgkqhkiG9w0B
# AQsFADAnMSUwIwYDVQQDDBxEYXJyeWwgRy4gQmFrZXIgQ29kZSBTaWduaW5nMB4X
# DTIxMDgxODE5NTcwMloXDTIyMDgxODIwMTcwMlowJzElMCMGA1UEAwwcRGFycnls
# IEcuIEJha2VyIENvZGUgU2lnbmluZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAKG7SowGauN0KCzcvXbxj5N9w6JrBU7OG3CqEh/5wCxvJ1CLAMIVa3lL
# +VqXxGS5iX/DbGt3NbvtCDcnu4OCCWDQkqM83NTZP84cD30O9JQblnxIwV1KLjXf
# p96NrOmAuhHHAbRITUxF5+dGZFfpJVp8Gi09GJf+DaEqSCzxu2Qw+g6NW9CWPRW0
# x0HGua95OcNHhNHOJLTTBg1ohtmo82mo5vMuniHIzM5j0sRqxj9vnNwQvTmgC/yq
# rRb3/u9XuPfGBnyR9mNw5po+MwOYenxShZgVv/UekL+oxBnt17r5TrUQfvWfKT7l
# i6pJ5+3Lose2Ave0ZVi4niNdzUi38mUCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBSd+ISqqC2sU6pmoZKlYLvJ
# 5a3vgDANBgkqhkiG9w0BAQsFAAOCAQEAY0P3VKNfGMKr+dqlEKjP8Ab95GZ++DZv
# yl4LmoCg0SLsgPoOgDzaaVkCu/OYSsScY9lkZqUO4T37hqdJpiI7FHi7hWWdGJFH
# /x/sQFJwUwuF4zJCCBv33YfJtrs42upbN1xSb3yUof61RTMhe2ZBp8DbfiPhsHI/
# +VZBqWy3FTUTj7XUng09B3gEv55mwEgPaGbUktAOK6fV8AVPtEksHqMllmcjLCeL
# nA6miV7eu+JGCNX/AO6Cvz2BIYMday06B1uVAMu+4NAI7A0kbmPJ7vZ2nXoCqN/y
# 1UrpGuO3EnXLsjYq5skJdNVmmFBTnlpMeM3a0e2I2fvYIkQ0m63CvjGCAdwwggHY
# AgEBMDswJzElMCMGA1UEAwwcRGFycnlsIEcuIEJha2VyIENvZGUgU2lnbmluZwIQ
# O+B/uXgs+ZJDI4pFwa7Z0DAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU6yMJa62Yn5k9YGV72tYB
# dSuZGXIwDQYJKoZIhvcNAQEBBQAEggEAIFuPaNhHJtG+67fSLgBP2EeogEgl7ix3
# gU69FDDqfPldGFDo4eiAzgKQCWse5Zt8aSZbi3+GnIbWBoLy/Hv7qC+idHAA+20a
# CQ+SpCS4RCOCtdevkd1YbkwxSLoXzfmlcmQKqfjafjmH1r12bb+KWKC21/TvS2qy
# Z2cNP5sXa/x557v28MBqnp/DQOmOe0Ut/k4Lp5i34ShR1vjnreGGz36uPVAKHFGw
# 6I/NHV9pflKCvi912LCmDjCnOsNquaXzyr6lz+u4P1Mzk3X6yiqzNjkdpvsJLk55
# JG+Jshn/bWsvtVF6jJp3HUYhYp3Q/Y1bmbotZhI4niM3YcMvQ8x76g==
# SIG # End signature block
