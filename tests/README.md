# Test Instructions

The instructions will show you how to set up the tests for AWS Lambda.


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
1. Click "Function" and repeat from step 2, this time with "mySendReceive"
1. Please Ensure that you enter your aws keys at the top of the agent.test.nut

The AWSLambda library is licensed under the [MIT License](../LICENSE).
