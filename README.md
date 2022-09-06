Azure Bicep Framework

Login to Azure Subscription using Azure PowerShell Module
# Step 1
Login-AzAccount

# Step 2
Select-AzSubscription -SubscriptionName "SubscriptionName"

# Step 3
Go into 0-deploy.ps1 and load in your parameters.

# Step 4
If necessary, create your resource group by running the following: New-AzResourceGroup -Name $rgname -Location $region -Force
Otherwise, dependping upon the resources you would like to provision, select and run the assocaited cmdlets as necessary.


License
MIT