import oci
import time

resource_name = 'autonomous databases'
check_interval = 10
timeout = 1200

def stop_autonomous_dbs(config, signer, compartments):
    print("Listing all {}... (* is marked for action)".format(resource_name))
    target_resources = []
    for compartment in compartments:
        resources = _list_resources(config, signer, compartment.id)
        for resource in resources:
            go = 0
            if (resource.lifecycle_state == 'AVAILABLE'):
                if ('control' in resource.defined_tags) and ('nightly_stop' in resource.defined_tags['control']): 
                    if (resource.defined_tags['control']['nightly_stop'].upper() != 'FALSE'):
                        go = 1
                else:
                    go = 1

            if (go == 1):
                print("    * {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))
                target_resources.append(resource)
            else:
                print("      {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))

    if len(target_resources) != 0:
        print('\nStopping * marked {}...(count: {})'.format(resource_name, len(target_resources)))
        for resource in target_resources:
            try:
                response = _stop_resource(config, signer, resource.id)
            except oci.exceptions.ServiceError as e:
                print("--->Error. Status: {}".format(e))
                pass
            else:
                if response.lifecycle_state == 'STOPPING':
                    print("    stop requested: {} ({})".format(response.display_name, response.lifecycle_state))
                else:
                    print("--->Error stopping {} ({})".format(response.display_name, response.lifecycle_state))
    else:
        print('No {} to stop. Skipping.'.format(resource_name))

    count = 0
    while len(target_resources) > 0:
        for i, resource in enumerate(target_resources):
            targetstate = _get_resource(config, signer, resource.id)
            if targetstate.lifecycle_state == 'STOPPED':
                target_resources.pop(i)
                print("      {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))
            elif targetstate.lifecycle_state == 'STOPPING':
                if (count * check_interval) > timeout:
                    target_resources.pop(i)
                    print("    Timed out: {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))
            else:
                target_resources.pop(i)
                print("    Conflicted state: {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))

        count += 1
        time.sleep(check_interval)

def delete_autonomous_dbs(config, signer, compartments):
    print("Listing all {}... (* is marked for action)".format(resource_name))
    target_resources = []
    for compartment in compartments:
        resources = _list_resources(config, signer, compartment.id)
        for resource in resources:
            if (resource.lifecycle_state != 'TERMINATED'):
                print("    * {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))
                target_resources.append(resource)
            else:
                print("      {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))

    if len(target_resources) != 0:
        print('\nDeleting * marked {}...(count: {})'.format(resource_name, len(target_resources)))
        for resource in target_resources:
            try:
                response = _delete_resource(config, signer, resource.id)
            except oci.exceptions.ServiceError as e:
                print("--->Error. Status: {}".format(e))
                pass
    else:
        print('No {} to delete. Skipping.\n'.format(resource_name))

    count = 0
    while len(target_resources) > 0:
        for i, resource in enumerate(target_resources):
            targetstate = _get_resource(config, signer, resource.id)
            if targetstate.lifecycle_state == 'TERMINATED':
                target_resources.pop(i)
                print("      {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))
            elif targetstate.lifecycle_state == 'TERMINATING':
                if (count * check_interval) > timeout:
                    target_resources.pop(i)
                    print("    Timed out: {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))
            else:
                target_resources.pop(i)
                print("    Conflicted state: {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))

        count += 1
        time.sleep(check_interval)

def change_autonomous_db_license(config, signer, compartments):
    print("Listing all {}... (* is marked for change)".format(resource_name))
    target_resources = []
    for compartment in compartments:
        resources = _list_resources(config, signer, compartment.id)
        for resource in resources:
            if (resource.license_model == 'LICENSE_INCLUDED'):
                print("    * {} ({}) in {}".format(resource.display_name, resource.license_model, compartment.name))
                target_resources.append(resource)
            else:
                print("      {} ({}) in {}".format(resource.display_name, resource.license_model, compartment.name))

    if len(target_resources) != 0:
        print("\nChanging * marked {}'s lisence model...(count: {})".format(resource_name, len(target_resources)))
        for resource in target_resources:
            try:
                response = _change_license_model(config, signer, resource.id, 'BRING_YOUR_OWN_LICENSE')
            except oci.exceptions.ServiceError as e:
                print("---------> error. status: {}".format(e))
                pass
            else:
                if response.lifecycle_state == 'UPDATING':
                    print("    change requested: {} ({})".format(response.display_name, response.lifecycle_state))
                else:
                    print("---------> error changing {} ({})".format(response.display_name, response.lifecycle_state))
    else:
        print('No {} to change lisence model. Skipping.'.format(resource_name))


def _list_resources(config, signer, compartment_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = oci.pagination.list_call_get_all_results(
        object.list_autonomous_databases,
        compartment_id=compartment_id
    )
    return response.data

def _get_resource(config, signer, resource_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = object.get_autonomous_database(
        resource_id
    )
    return response.data

def _stop_resource(config, signer, resource_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = object.stop_autonomous_database(
        resource_id
    )
    return response.data

def _delete_resource(config, signer, resource_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = object.delete_autonomous_database(
        resource_id
    )
    return response.data

def _change_license_model(config, signer, resource_id, license_model):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    details = oci.database.models.UpdateAutonomousDatabaseDetails(license_model = license_model)
    response = object.update_autonomous_database(
        resource_id,
        details
    )
    return response.data

