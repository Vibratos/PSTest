# required modules
Install-Module AWSPowershell -Scope CurrentUser
Install-Module AWSLambdaPSCore -Scope CurrentUser

# inport AWS Modules 
Import-Module AWSPowerShell.NetCore -Force
Import-Module AWSLambdaPSCore -Force

# region keys
$accesskey = ""
$secretkey = ""
Initialize-AWSDefaultConfiguration -AccessKey $accesskey  -SecretKey $secretkey -Region us-east-1


 # get-current list of Lambda functions
 Get-LMFunctionList

# get list of avaialble PS tempaltes
Get-AWSPowerShellLambdaTemplate

# create a started based on basic template
New-AWSPowerShellLambda -ScriptName PSTest -Template Basic

# publish the new PowerShell based Lambda function
$publishPSLambdaParams = @{
    Name = 'PSTest'
    ScriptPath = './PSTest.ps1'
    Region = 'eu-central-1'
    IAMRoleARN = 'lambda_basic_execution_role'
}
Publish-AWSPowerShellLambda @publishPSLambdaParams

# invoke the new PowerShell function
$resulst = Invoke-LMFunction -FunctionName PSTest -InvocationType Event
$resulst | Select-Object -Property *


# get the log events from the iviked function
$logs = Get-CWLFilteredLogEvent -LogGroupName /aws/lambda/PSTest
$logs.Events


