# Use back-end type `python_fastapi` in the portal configuration.
from fastapi import Body, FastAPI
from fastapi.responses import JSONResponse
from simian.entrypoint import entry_point_deploy

app = FastAPI()


# Generic route for all apps.
@app.post("/apps/{app_name}", response_class=JSONResponse)
def route_app_requests(app_name: str, request_data: list = Body()) -> dict:
    """Route requests to the Simian GUI app and return the response."""

    # The app_name is converted to a module by replacing dashes with dots. E.g.: The route
    # "/apps/simian-examples-ballthrower" will call the module "simian.examples.ballthrower".
    module_name = app_name.replace("-", ".")
    return entry_point_deploy(module_name, request_data)
