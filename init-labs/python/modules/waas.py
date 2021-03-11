import oci

client = oci.waas.WaasClient

def change_protecton_rules(config, signer, compartments):
    print("\nListing all waas policies...")
    for comp in compartments:
        for policy in list_resources(client(config, signer=signer).list_waas_policies, compartment_id=comp.id):
            print("    {} ({})".format(policy.display_name, policy.lifecycle_state))
            if (policy.lifecycle_state in ['ACTIVE']):
                listrules = []
                for rule in list_resources(client(config, signer=signer).list_protection_rules, waas_policy_id=policy.id):

                    if rule.action != 'DETECT':
                        print("        * {} : {} - {}".format(rule.action, rule.key, rule.name))
                        ruleact = oci.waas.models.ProtectionRuleAction(key = rule.key, action = 'DETECT')
                        listrules.append(ruleact)
                    else:
                        print("          {} : {} - {}".format(rule.action, rule.key, rule.name))

                if len(listrules) > 0: 
                    update_resources(client(config, signer=signer).update_protection_rules, policy.id, listrules)
                else:
                    print("    ->no rules to change. skipping")

def update_resources(method, resource_id, rules):
    response = method(resource_id, rules)

def list_resources(method, **kwargs):
    response = oci.pagination.list_call_get_all_results(
        method,
        **kwargs
    )
    return response.data
