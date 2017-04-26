# Demo Instructions

This example shows how you can create a Lambda that will do RSA-SHA256 signatures for an agent.

**Note** Even though the example shows a specific use case for RSA-SHA256 encryption, the steps for setting up the Lambda, the IAM Policy and an IAM User described here are generic and applicable to any other use case and Lambda implementation.

## 1. Generate Keys

Here are the commands you need for private- and public-key generation under Linux:

```
$ openssl genrsa -out privkey.pem 2048
Generating RSA private key, 2048 bit long modulus
(...)
e is 65537 (0x10001)

$ openssl rsa -pubout <privkey.pem >pubkey.pem
writing RSA key
```

The private key is going to be stored in a file called `privkey.pem`, the public key in `pubkey.pem`.

**Note** These commands are operating system specific.

## 2. Prepare the Sample Node.js Code

The sample Node.js code can be found [here](RSALambda.js). Copy and paste the full text of the Lambda code into a text editor. Insert the full private key text taken from `privkey.pem` between the lines:

```
-----BEGIN RSA PRIVATE KEY-----
```

and

```
-----END RSA PRIVATE KEY-----
```

Please note that the line structure from the original `privkey.pem` file should be preserved, ie. you shouldn’t join multiple lines into one. The private key in the Lambda code should look something like this:

```
-----BEGIN RSA PRIVATE KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtjdR7z8l1/Z8oSOn/RNb
qKc9f5/zsL17CHZ/fBDsS6WMLTblm0H5Kh1SAE2nFL2cpw3VlHeKHu+fvebl79sz
7fmaXpB6gmzq3i7u6iQzaUSkn9nEklo/1voZhX8fwlPQ7st6X4y//PG69RoFHzR0
IV9EUfLdAI/CC9qEhjf5x8Zg1PXOx/WXlXYHvTmOibMhGF6MlV9PDLYrank2iASE
afzDVvc4RwT0JUTN1dRoOAB9js298E5Jggd8zDnpsmarrFj/rEksyBdhLl8PHRoy
GhsSFmIxNsEmbog00bcI3x1cW15b1VzuYMM2NzDEa9N12mN3Jkq2RNlg56qGTxEL
hwIDAQAB
-----END RSA PRIVATE KEY-----

// Rest of the lambda code goes here
```

**Note** As the sample code includes the private key verbatim in the source, it should be treated carefully, and not checked into version control!

## 3. Set up a Lambda

1. Select the ‘Services’ link (on the top left of the AWS page) and then type `Lambda` in the search line.
1. Select the ‘Lambda Run Code without Thinking about Services’ item.
1. Select ‘Create a Lambda function’.
1. Under ‘Select blueprint’, choose ‘Blank function’.
1. Select ‘Configure function’ from the menu on the left and do the following:
    1. Give the function a name: `RSALambda`.
    1. Select runtime ‘Node.js 4.3’.
    1. Paste the full Lambda source code from above into the ‘Lambda function code’ section.
    1. Leave ‘Handler’ as default (`index.handler`).
    1. Set ‘Role’ to ‘Create new role from template(s)’.
    1. Set ‘Role name‘ to ‘role_with_no_permissions‘.
    1. Leave ‘Policy templates’ empty.
    1. Click ‘Next’.
1. Press ‘Create function’.
1. On the Lambda page copy the Lambda’s **ARN**. It can be found at the top right corner of the page and should look like: `arn:aws:lambda:us-west-1:123456789101:function:RSALambda`.
1. Copy the Lambda region. It can be found on the top right corner of the page, and is a next item to the right of the link with the user name (eg. `us-east-1`).

## 4. Set up an AIM Policy

1. Select the ‘Services’ link (on the top left of the page) and them type `IAM` into the search field.
1. Select the ‘IAM Manage User Access and Encryption Keys’ item.
1. Select ‘Policies’ item from the menu on the left.
1. Click on the ‘Create Policy’ button.
1. Press ‘Select’ for ‘Policy Generator’.
1. On the ‘Edit Permissions’ page, do the following:
    1. Set ‘Effect’ to ‘Allow’.
    1. Set ‘AWS Service’ to ‘AWS Lambda’.
    1. Set ‘Actions’ to ‘InvokeFunction’.
    1. Set ‘Amazon Resource Name (ARN)’ to the Lambda **ARN** retrieved from step 3.7, above.
    1. Click on ‘Add Statement’.
    1. Click on ‘Next Step‘.
1. Give your policy a name, for example, `allow-calling-RSALambda`, and type iit into the ‘Policy Name’ field.
1. Click on ‘Create Policy’.

## 5. Set up the AIM User

1. Select the ‘Services’ link (on the top left of the page) and them type `IAM` into the search field.
1. Select the ‘IAM Manage User Access and Encryption Keys’ item.
1. Select ‘Users’ from the menu on the left.
1. Press ‘Add user’.
1. Pick a user name, eg. `user-calling-lambda`.
1. Check ‘Programmatic access’ but not anything else.
1. Click on the ‘Next: Permissions’ button.
1. Click on the ‘Attach existing policies directly’ icon.
1. Check ‘allow-calling-RSALambda’ from the list of policies.
1. Click on ‘Next: Review’.
1. Click on ‘Create user’.
1. Copy your ‘Access key ID’ and your ‘Secret access key’.

## 6. Set up the Agent Code

Here is some agent [code](agent.nut). Copy and paste it into the [Electric Imp IDE](https://ide.electricimp.com/login/): create a new model then paste the code into the agent code pane.

Set the example code configuration parameters with values retrieved on the previous steps:

Parameter             | Description
--------------------- | -----------
*AWS_LAMBDA_REGION*     | AWS region where Lambda located
*ACCESS_KEY_ID*         | IAM `Access key ID`
*SECRET_ACCESS_KEY*     | IAM `Secret Access Key`

Run the example code and it should print the signature generated by the Lambda function.

## License

The AWSLambda library is licensed under the [MIT License](../../LICENSE).

