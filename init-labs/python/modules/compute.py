import oci
import time
from modules.common import *

resource_name  = 'compute instances'
state_active   = 'RUNNING'
stop_action    = 'STOP'
state_stopped  = 'STOPPED'
state_stopping = 'STOPPING'
delete_action  = 'TERMINATE'
state_deleted  = 'TERMINATED'
state_deleting = 'TERMINATING'
check_interval = 10
timeout        = 1200

def stop_compute_instances(config, signer, compartments):
    print("Listing all {}... (* is marked for action)".format(resource_name))

    target_resources = list_targets(config, signer, resource_name, stop_action, state_active, compartments)
    '''
    target_resources = []
    for compartment in compartments:
        resources = _list_resources(config, signer, compartment.id)
        for resource in resources:
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
    '''

    commit_action(config, signer, resource_name, target_resources, stop_action)
    '''
    if len(target_resources) != 0:
        print('\nStopping * marked {}...'.format(resource_name))
        for resource in target_resources:
            try:
                response = _stop_resource(config, signer, resource.id, 'STOP')
            except oci.exceptions.ServiceError as e:
                print("-->Error. Status: {}".format(e))
                pass
            else:
                if response.lifecycle_state == 'STOPPING':
                    print("    stop requested: {} ({})".format(response.display_name, response.lifecycle_state))
                else:
                    print("--->Error stopping {} ({})".format(response.display_name, response.lifecycle_state))
    else:
        print('No {} to stop. Skipping.'.format(resource_name))
    '''

    wait_action_completion(config, signer, resource_name, target_resources, state_stopped, state_stopping, check_interval, timeout)
    '''
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
            else
                target_resources.pop(i)
                print("    Conflicted state: {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))

        count += 1
        time.sleep(check_interval)
    '''

def purge_instances(config, signer, compartments):
    print("Listing all {}... (* is marked for action)".format(resource_name))

    target_resources = list_targets(config, signer, resource_name, stop_action, state_active, compartments)
    '''
    target_resources = []
    for compartment in compartments:
        resources = _list_resources(config, signer, compartment.id)
        for resource in resources:
            if (resource.lifecycle_state != state_deleted):
                print("    * {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))
                target_resources.append(resource)
            else:
                print("      {} ({}) in {}".format(resource.display_name, resource.lifecycle_state, compartment.name))
    '''

    commit_action(config, signer, resource_name, target_resources, delete_action)

    '''
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
    '''

    wait_action_completion(config, signer, resource_name, target_resources, state_deleted, state_deleting, check_interval, timeout)

    '''
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
            else
                target_resources.pop(i)
                print("    Conflicted state: {} ({})".format(targetstate.display_name, targetstate.lifecycle_state))

        count += 1
        time.sleep(check_interval)
    '''


def _list_resources(config, signer, compartment_id):
    object = oci.core.ComputeClient(config=config, signer=signer)
    response = oci.pagination.list_call_get_all_results(
        object.list_instances,
        compartment_id
    )
    return response.data
'''
def _get_resource(config, signer, resource_id):
    object = oci.core.ComputeClient(config=config, signer=signer)
    response = object.get_instance(
        resource_id
    )
    return response.data

def _stop_resource(config, signer, resource_id):
    object = oci.core.ComputeClient(config=config, signer=signer)
    response = object.instance_action(
        resource_id,
        'STOP'
    )
    return response.data

def _delete_resource(config, signer, resource_id):
    object = oci.core.ComputeClient(config=config, signer=signer)
    response = object.terminate_instance(
        resource_id
    )
    return response.data

def _commit_action(config, signer, target_resources, action):
    if len(target_resources) != 0:
        print('\nCommitting action for * marked {}...(action = {})'.format(resource_name, action))
        for resource in target_resources:
            try:
                if action == 'STOP':
                    response = _stop_resource(config, signer, resource.id)
                elif action in ['DELETE', 'TERMINATE']:
                    response = _delete_resource(config, signer, resource.id)
                else:
                    print("--->Error. Illigal action: {}".format(action))
            except oci.exceptions.ServiceError as e:
                print("--->Error. Status: {}".format(e))
                pass
    else:
        print('No {} for action. Skipping.'.format(resource_name))

def _wait_action_completion(config, signer, target_resources, target_state, state_in_action, check_interval, timeout):
    count = 0
    while len(target_resources) > 0:
        for i, resource in enumerate(target_resources):
            target = _get_resource(config, signer, resource.id)
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
'''
