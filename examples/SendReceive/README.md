# Demo Instructions

This example shows who to create a simple Lambda function that will echo back what you transmit to it.

As the sample code includes the private key verbatim in the source, it should be treated carefully, and not checked into version control!

## Setting up a Lambda

1. Go to the AWS Lambda console.
1. Click "Create a Lambda function"
1. In "Select Blueprint", click "Blank function"
1. In "Configure triggers", click "Next"
1. Click "Configure function":
    1. Give function a name "myReceive"
    1. Select runtime "Node.js 4.3"
    1. Paste in code from *myReceive.js*
    1. Leave "Handler" as default ("index.handler")
    1. Set "Role" to "Create new role from template(s)"
    1. Set "Role name" to "role_with_no_permissions"
    1. Leave "Policy templates" empty
    1. "Next"


## Configure the API keys for Lambda

At the top of the AWSLambda.test.nut there are three constants to configure.

Parameter             | Description
----------------------| -----------
AWS_LAMBDA_REGION     | AWS region (e.g. "us-east-1")
ACCESS_KEY_ID         | IAM Access Key ID
SECRET_ACCESS_KEY     | IAM Secret Access Key

# License

The AWSLambda library is licensed under the [MIT License](../LICENSE).
