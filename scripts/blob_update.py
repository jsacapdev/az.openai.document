import asyncio
# import os

# from azure.identity.aio import AzureDeveloperCliCredential

# from auth_common import (
#     get_application,
#     get_auth_headers,
#     test_authentication_enabled,
#     update_application,
# )


async def main():
    # if not test_authentication_enabled():
    #     print("Not updating authentication.")
    #     exit(0)

    print("This line will be printed.")

    # credential = AzureDeveloperCliCredential(tenant_id=os.getenv("AZURE_AUTH_TENANT_ID", os.getenv("AZURE_TENANT_ID")))

    # client_app_id = os.getenv("AZURE_CLIENT_APP_ID", None)
    # if client_app_id:
    #     print(f"Application update for client app id {client_app_id} complete.")

if __name__ == "__main__":
    asyncio.run(main())
