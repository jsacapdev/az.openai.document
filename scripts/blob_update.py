import asyncio
import os

from azure.identity import DefaultAzureCredential
from azure.mgmt.authorization import AuthorizationManagementClient
from azure.mgmt.resource import ResourceManagementClient
from dotenv import load_dotenv
from pathlib import Path

async def main():

    dotenv_path = Path('./.azure/dev/.env')
    load_dotenv(dotenv_path=dotenv_path)

    AZURE_SUBSCRIPTION_ID = os.environ.get("AZURE_SUBSCRIPTION_ID", None)
    GROUP_NAME = "rg-azd1-dev-001"

    resource_client = ResourceManagementClient(
        credential=DefaultAzureCredential(),
        subscription_id=AZURE_SUBSCRIPTION_ID
    )
    authorization_client = AuthorizationManagementClient(
        credential=DefaultAzureCredential(),
        subscription_id=AZURE_SUBSCRIPTION_ID
    )

    resource_group = resource_client.resource_groups.get(
        GROUP_NAME
    )

    # Get "Contributor" built-in role as a RoleDefinition object
    role_name = 'Contributor'
    roles = list(authorization_client.role_definitions.list(
        resource_group.id,
        filter="roleName eq '{}'".format(role_name)
    ))
    assert len(roles) == 1
    contributor_role = roles[0]

    print("!!!")

if __name__ == "__main__":
    asyncio.run(main())
