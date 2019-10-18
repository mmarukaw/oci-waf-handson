# coding: utf-8

import sys
import oci
from module:identity import *

########## Configuration ####################
# Specify your config file
configfile = '~/.oci/config'

# Specify your profile name
profile = 'waf'

# Set true if using instance principal signing
use_instance_principal = 'TRUE'

# Set top level compartment OCID. Tenancy OCID will be set if null.
top_level_compartment_id = ''

# Compartment ID
compartment_id = 'ocid1.compartment.oc1..aaaaaaaap7zxffy5cadhxdn363f6up4wnf5y2s7frdx5i7ecv6npdvsnrkra'

# List target regions. All regions will be counted if null.
# target_region_names = ['us-ashburn-1']
region = 'ap-tokyo-1'

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





def _get_resource(config, signer, resource_id):
    object = oci.core.ComputeClient(config=config, signer=signer)
    response = object.get_instance(
        resource_id
    )
    return response.data

