"""Variables for Notebook Versioner"""

PROJECT = 'notebook-versioner'
ZONE = 'us-east1-b'
INSTANCE_CONFIG = """
{
  "name": "nv-worker-%s",
  "zone": "https://www.googleapis.com/compute/v1/projects/notebook-versioner/zones/us-east1-b",
  "machineType": "https://www.googleapis.com/compute/v1/projects/notebook-versioner/zones/us-east1-b/machineTypes/f1-micro",
  "metadata": {
    "items": [
      {
        "key": "startup-script",
        "value": '%s'
      },
      {
        "key": "sshKeys",
        "value": "rhefner:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3oIksPwopKge/jW1szb8rCs8kDLaj9/Tc+HhlYpRevge0+0dK2wHhw9X3O9uFe/alcbBlEZcs/WJdvypw8gjLDzIMpWooWZ8dlizlb3G/7zB1fLjm9JYhBWomnIJ5QNaZpQTXExrLFl40ik3wplwwjdcRmHDK30C3eRg1m3O3d5K1iLLWKOwd6YxYq/+pvj/dsno+2sm9hHJm67irWdGgJla08dmNlWKHIVXbDfY+EwXnu6TsA3wkj1R5MhsTSJUFsPdlGwbMFaWIj8bYRF8tVrE7P2ZRKIPhHcndG5Jo3E8eVBVb946YAeCXPmn0W2uJMrLhvXegrsQosXmatS1L rhefner@thinkforward"
      }
    ]
  },
  "tags": {
    "items": []
  },
  "disks": [
    {
      "type": "PERSISTENT",
      "boot": true,
      "mode": "READ_WRITE",
      "deviceName": "nv-worker-2",
      "autoDelete": true,
      "initializeParams": {
        "sourceImage": "https://www.googleapis.com/compute/v1/projects/notebook-versioner/global/images/notebook-versioner-base",
        "diskType": "https://www.googleapis.com/compute/v1/projects/notebook-versioner/zones/us-east1-b/diskTypes/pd-standard",
        "diskSizeGb": "10"
      }
    }
  ],
  "canIpForward": false,
  "networkInterfaces": [
    {
      "network": "https://www.googleapis.com/compute/v1/projects/notebook-versioner/global/networks/default",
      "accessConfigs": [
        {
          "name": "External NAT",
          "type": "ONE_TO_ONE_NAT"
        }
      ]
    }
  ],
  "description": "",
  "scheduling": {
    "preemptible": false,
    "onHostMaintenance": "MIGRATE",
    "automaticRestart": true
  },
  "serviceAccounts": [
    {
      "email": "default",
      "scopes": [
        "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring.write"
      ]
    }
  ]
}
"""
WAIT_FOR_VM_DELETE = 3600
