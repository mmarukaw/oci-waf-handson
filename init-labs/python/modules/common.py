import oci
import time

def list_targets(config, signer, resource_name, action, state_active, compartments):
    target_resources = []
    for compartment in compartments:
        resources = _list_resources(config, signer, resource_name, compartment.id)
        for resource in resources:
            if action == 'STOP':
                go = 0
                if (resource.lifecycle_state == state_active):
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

            elif action == 'DELETE':
                if (resource.lifecycle_state not in ['DELETING', 'DELETED']):
                    print("    * {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))
                    target_resources.append(resource)
                else:
                    print("      {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))

            elif action == 'TERMINATE':
                if (resource.lifecycle_state not in ['TERMINATING', 'TERMINATED']):
                    print("    * {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))
                    target_resources.append(resource)
                else:
                    print("      {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))

    return target_resources


def commit_action(config, signer, resource_name, target_resources, action):
    if len(target_resources) != 0:
        print('\nCommitting action for * marked {}...(action = {})'.format(resource_name, action))
        for resource in target_resources:
            try:
                if action == 'STOP':
                    response = _stop_resource(config, signer, resource_name, resource.id)
                elif action in ['DELETE', 'TERMINATE']:
                    response = _delete_resource(config, signer, resource_name, resource.id)
                else:
                    print("--->Error. Illigal action: {}".format(action))
            except oci.exceptions.ServiceError as e:
                print("--->Error. Status: {}".format(e))
                pass
    else:
        print('No {} for action. Skipping.'.format(resource_name))

def wait_action_completion(config, signer, resource_name, target_resources, target_state, state_in_action, check_interval, timeout):
    count = 0
    while len(target_resources) > 0:
        for i, resource in enumerate(target_resources):
            target = _get_resource(config, signer, resource_name, resource.id)
            if target.lifecycle_state == target_state:
                target_resources.pop(i)
                print("    Action completed: {} ({})".format(target.display_name, target.lifecycle_state))
            elif target.lifecycle_state == state_in_action:
                if (count * check_interval) > timeout:
                    target_resources.pop(i)
                    print("--->Error. Timed out: {} ({})".format(target.display_name, target.lifecycle_state))
            else:
                target_resources.pop(i)
                print("--->Error. Conflicted state: {} ({})".format(target.display_name, target.lifecycle_state))

        count += 1
        time.sleep(check_interval)

def _list_resources(config, signer, resource_name, compartment_id):
    if resource_name == 'compute instances':
        object = oci.core.ComputeClient(config=config, signer=signer)
        response = oci.pagination.list_call_get_all_results(
            object.list_instances,
            compartment_id
        )
    return response.data

def _get_resource(config, signer, resource_name, resource_id):
    if resource_name == 'compute instances':
        object = oci.core.ComputeClient(config=config, signer=signer)
        response = object.get_instance(
            resource_id
        )
    return response.data

def _stop_resource(config, signer, resource_name, resource_id):
    if resource_name == 'compute instances':
        object = oci.core.ComputeClient(config=config, signer=signer)
        response = object.instance_action(
            resource_id,
            'STOP'
        )
    return response.data

def _delete_resource(config, signer, resource_name, resource_id):
    if resource_name == 'compute instances':
        object = oci.core.ComputeClient(config=config, signer=signer)
        response = object.terminate_instance(
            resource_id
        )
    return response.data



