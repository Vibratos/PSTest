# PowerShell script file to be executed as a AWS Lambda function. 
# 
# When executing in Lambda the following variables will be predefined.
#   $LambdaInput - A PSObject that contains the Lambda function input data.
#   $LambdaContext - An Amazon.Lambda.Core.ILambdaContext object that contains information about the currently running Lambda environment.
#
# The last item in the PowerShell pipeline will be returned as the result of the Lambda function.
#
# To include PowerShell modules with your Lambda function, like the AWSPowerShell.NetCore module, add a "#Requires" statement 
# indicating the module and version.

#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.509.0'}

# Uncomment to send the input event to CloudWatch Logs
# Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

# $LambdaInput | Get-Member -MemberType Properties | ForEach-Object {Write-host " $($_.name) = $($LambdaInput.$($_.name))" }
$LambdaInput = Get-Content ./test_event.json | ConvertFrom-Json
$tags = @{}
$instanceName1 = "(No name)"
$instanceID = $LambdaInput.detail.'instance-id'
$instance = Get-EC2Instance -InstanceId $instanceID
$Instance.instances[0].Tags | ForEach-Object {$tags.add($_.Key, $_.Value)}  
if ($tags.ContainsKey('Name')) {
    $instanceName1 = $tags.Name
}
Write-Host "Initiated by event: Instance $($instanceName1) with ID $instanceID has been stopped. Trying to start."
if (($state = $instance.Instances[0].State.Name) -eq 'stopped') {
    Start-EC2Instance -InstanceId $instanceID
} else {
    Write-Host "Instance state is $state I will not start it."
}