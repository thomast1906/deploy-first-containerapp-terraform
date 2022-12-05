az containerapp create --name "containertam" \
  --resource-group "firstcontainerapp-rg" \
  --environment "firstcontainerappacaenv" \
  --user-assigned "/subscriptions/04109105-f3ca-44ac-a3a7-66b4936112c3/resourcegroups/firstcontainerapp-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/containerappmi" \
  --registry-identity "/subscriptions/04109105-f3ca-44ac-a3a7-66b4936112c3/resourcegroups/firstcontainerapp-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/containerappmi" \
  --registry-server "firstcontainerappacracr.azurecr.io" \
  --image "firstcontainerappacracr.azurecr.io/aspcoresample:58533d062c15af417615e9866e37dcaa36f49845"
