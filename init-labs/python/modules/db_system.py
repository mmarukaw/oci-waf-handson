import oci
import time

resource_name = 'database systems'
check_interval = 10
timeout = 1200

def stop_db_systems(config, signer, compartments):
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

            print("      {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))
            if (go == 1):
                db_nodes = _list_db_nodes(config, signer, compartment.id, resource.id)

                for db_node in db_nodes:
                    if (db_node.lifecycle_state == 'AVAILABLE'):
                        print("        * node:{} ({})".format(db_node.hostname, db_node.lifecycle_state))
                        target_resources.append(db_node)
                    else:
                        print("          node:{} ({})".format(db_node.hostname, db_node.lifecycle_state))

    if len(target_resources) != 0:
        print('\nStopping * marked {}...'.format(resource_name))
        for resource in target_resources:
            try:
                response = _stop_db_nodes(config, signer, resource.id, 'STOP')
            except oci.exceptions.ServiceError as e:
                print("--->Error. Status: {}".format(e))
                pass
            else:
                if response.lifecycle_state == 'STOPPING':
                    print("    stop requested: {} ({})".format(response.hostname, response.lifecycle_state))
                else:
                    print("---> error stopping {} ({})".format(response.hostname, response.lifecycle_state))
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

def purge_db_systems(config, signer, compartments):
    print("Listing all {}... (* is marked for delete)".format(resource_name))
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


    while len(target_resources) > 0:
        for i, resource in enumerate(target_resources):
            targetstate = _get_resource(config, signer, resource.id)
            if targetstate.lifecycle_state == 'TERMINATED':
                target_resources.pop(i)
                print("      {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))
            elif targetstate.lifecycle_state != 'TERMINATING':
                target_resources.pop(i)
                print("    Conflicted state: {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))

        time.sleep(10)


def _list_resources(config, signer, compartment_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = oci.pagination.list_call_get_all_results(
        object.list_db_systems,
        compartment_id=compartment_id
    )
    return response.data

def _get_resource(config, signer, resource_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = object.get_db_system(
        resource_id
    )
    return response.data

def _delete_resource(config, signer, resource_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = object.terminate_db_system(
        resource_id
    )
    return response.data

def _list_db_nodes(config, signer, compartment_id, db_system_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = oci.pagination.list_call_get_all_results(
        object.list_db_nodes,
        compartment_id = compartment_id,
        db_system_id = db_system_id
    )
    return response.data

def _stop_db_nodes(config, signer, resource_id, action):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = object.db_node_action(
        resource_id,
        action
    )
    return response.data

def _list_data_guard_associations(config, signer, compartment_id, db_system_id):
    object = oci.database.DatabaseClient(config=config, signer=signer)
    response = oci.pagination.list_call_get_all_results(
        object.list_data_guard_associations,
        databaseb_id = database_id
    )
    return response.data


