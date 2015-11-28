"""Notebook versioner controller"""

from httplib2 import Http
import json
import logging
import uuid
import webapp2

from google.appengine.api import taskqueue

from googleapiclient.discovery import build
from oauth2client.appengine import AppAssertionCredentials

from controller import nv_vars

STARTUP_SCRIPT_FILE = 'notebook_versioner.sh'


def get_credentials():
    """Authorizes a request to Google Cloud Platform."""
    credentials = AppAssertionCredentials(
        'https://www.googleapis.com/auth/cloud-platform')
    http_auth = credentials.authorize(Http())
    return build('compute', 'v1', http=http_auth)


class CreateVM(webapp2.RequestHandler):
    """Handles the creation of instances."""
    def get(self):
        """Handles the creation of instances."""
        unique_id = str(uuid.uuid4())[:6]
        with open(STARTUP_SCRIPT_FILE, 'r') as ss_file:
            startup_script = ss_file.read()
        instance_config = nv_vars.INSTANCE_CONFIG % (unique_id, startup_script)

        compute = get_credentials()
        compute.instances().insert(
            project=nv_vars.PROJECT,
            zone=nv_vars.ZONE,
            body=json.loads(instance_config)).execute()

        taskqueue.add(url="/delete",
                      params={'name': "nv-worker-%s" % unique_id},
                      countdown=nv_vars.WAIT_FOR_VM_DELETE)

        self.response.write('Done.')


class DeleteVM(webapp2.RequestHandler):
    """Handles the deletion of instances."""
    def post(self):
        """Handles the deletion of instances."""
        name = self.request.get('name')
        logging.info("Deleting instance id: %s", name)

        compute = get_credentials()
        compute.instances().delete(
            project=nv_vars.PROJECT,
            zone=nv_vars.ZONE,
            instance=name).execute()

        self.response.write('Done.')


APP = webapp2.WSGIApplication([
    ('/create', CreateVM),
    ('/delete', DeleteVM),
], debug=True)
