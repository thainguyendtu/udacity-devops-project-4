# Fetch IAM github-action-user ARN
Write-Output "Fetching IAM github-action-user ARN"
$userarn = (aws iam get-user --user-name github-action-user | jq -r .User.Arn)

# Download tool for manipulating aws-auth (Update link if using WSL or different version)
Write-Output "Downloading tool..."
Invoke-WebRequest -Uri "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_windows_amd64.exe" -OutFile "aws-iam-authenticator.exe"

Write-Output "Updating permissions"
Start-Process -FilePath ".\aws-iam-authenticator.exe" -ArgumentList "add user --userarn=$userarn --username=github-action-role --groups=system:masters --kubeconfig=$HOME/.kube/config --prompt=false" -NoNewWindow -Wait

Write-Output "Cleaning up"
Remove-Item -Path "aws-iam-authenticator.exe"
Write-Output "Done!"