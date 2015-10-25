from httplib2 import Http
import json
import logging
import uuid
import webapp2

from google.appengine.api import taskqueue
from google.appengine.api import urlfetch

from apiclient.discovery import build
from oauth2client.appengine import AppAssertionCredentials

import vars


def get_credentials():
    credentials = AppAssertionCredentials(
        'https://www.googleapis.com/auth/cloud-platform')
    http_auth = credentials.authorize(Http())
    return build('compute', 'v1', http=http_auth)


class CreateVM(webapp2.RequestHandler):
    def get(self):
        unique_id = str(uuid.uuid4())[:6]
        instance_config = vars.INSTANCE_CONFIG % unique_id

        compute = get_credentials()
        compute.instances().insert(
            project=vars.PROJECT,
            zone=vars.ZONE,
            body=json.loads(instance_config)).execute()

        taskqueue.add(url="/delete",
                      params={'name': "nv-worker-%s" % unique_id},
                      countdown=vars.WAIT_FOR_VM_DELETE)

        self.response.write('Done.')


class DeleteVM(webapp2.RequestHandler):
    def post(self):
        name = self.request.get('name')
        logging.info("Deleting instance id: %s" % name)

        compute = get_credentials()
        compute.instances().delete(
            project=vars.PROJECT,
            zone=vars.ZONE,
            instance=name).execute()

        self.response.write('Done.')


app = webapp2.WSGIApplication([
    ('/create', CreateVM),
    ('/delete', DeleteVM),
], debug=True)
