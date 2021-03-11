# coding: utf-8

import sys
import oci
from oci.signer import Signer
from modules.common import *
from modules.waas import *

########## Configuration ####################
# Specify your config file
configfile = '~/.oci/config'

# Specify your profile name
profile = 'orasejapan'

# Set true if using instance principal signing
use_instance_principal = 'FALSE'

# Set top level compartment OCID. Tenancy OCID will be set if null.
#/project/waf
top_level_compartment_id = 'ocid1.compartment.oc1..aaaaaaaap7zxffy5cadhxdn363f6up4wnf5y2s7frdx5i7ecv6npdvsnrkra'

# List compartment names to exclude
excluded_compartments = []

# List target regions. All regions will be counted if null.
target_region_names = ['us-ashburn-1']

#############################################

# Default config file and profile
config = oci.config.from_file(configfile, profile)
tenancy_id = config['tenancy']

if use_instance_principal == 'TRUE':
    signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
else:
    signer = Signer(
        tenancy = config['tenancy'],
        user = config['user'],
        fingerprint = config['fingerprint'],
        private_key_file_location = config['key_file'],
        pass_phrase = config['pass_phrase']
    )


print ("\n===========================[ Login check ]=============================")
login(config, signer)

print ("\n==========================[ Target regions ]===========================")
all_regions = list_region_subscriptions(config, signer, tenancy_id)
target_regions=[]
for region in all_regions:
    if (not target_region_names) or (region.region_name in target_region_names):
        target_regions.append(region)
        print (region.region_name)

print ("\n========================[ Target compartments ]========================")
if not top_level_compartment_id:
    top_level_compartment_id = tenancy_id
compartments = list_compartments(config, signer, top_level_compartment_id)
target_compartments=[]
for compartment in compartments:
    if compartment.name not in excluded_compartments:
        target_compartments.append(compartment)
        print (compartment.name)

for region in target_regions:
    print ("\n============[ {} ]================".format(region.region_name))

    config["region"] = region.region_name

    change_protecton_rules(config, signer, target_compartments)

print ("\n========================[ Completed ]========================")
