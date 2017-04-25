# Demo Instructions

This example shows how to create a Lambda that will do RSA-SHA256 signatures for an agent.

**NOTE**: Even though the example shows a specific use case for RSA-SHA256 encryption,
the steps for setting up Lambda, IAM Policy and IAM User described here are generic and
applicable to any other use case and Lambda implementation.

## Generate Keys

Below are commands for private and public keys generation on a Linux environment:

```
$ openssl genrsa -out privkey.pem 2048
Generating RSA private key, 2048 bit long modulus
(...)
e is 65537 (0x10001)

$ openssl rsa -pubout <privkey.pem >pubkey.pem
writing RSA key
```

The public key is going to be stored in `private.pem` file, the public key - in `pubkey.pem`.

**NOTE**: these commands are operating system specific and may differ on other environments.

## Preparing the Sample Node.js Code

The sample Node.js code can be found [here](RSALambda.js). Copy in paste the full text of the
Lambda code into a text editor.  Insert the full private key text taken from `private.pem`
between the lines:

```
-----BEGIN RSA PRIVATE KEY-----
```
and
```
-----END RSA PRIVATE KEY-----
```
Please note that the line structure from the original `privkey.pem` file should be preserved, e.i.
you shouldn't join multiple lines into one. The private key in the Lambda code should look like:

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

**NOTE**: As the sample code includes the private key verbatim in the source,
it should be treated carefully, and not checked into version control!

## Setting up a Lambda

1. Select `Services` link (on the top left of the page) and them type `Lambda` in the search line
1. Select the `Lambda Run Code without Thinking about Services` item
1. Select `Create a Lambda function`
1. Under the `Select blueprint` choose `Blank function`
1. Select `Configure function` item from the manu on the left and do the following
    1. Give function a name `RSALambda`
    1. Select runtime `Node.js 4.3`
    1. Paste the full lambda source code from above into the `Lambda function code` section.
    1. Leave `Handler` as default (`index.handler`)
    1. Set `Role` to `Create new role from template(s)`
    1. Set `Role name` to `role_with_no_permissions`
    1. Leave `Policy templates` empty
    1. `Next`
1. Press `Create function`
1. On the Lambda page copy and copy down Lambda's **ARN**. It can be found at the top right corner
of the page and should look like: `arn:aws:lambda:us-west-1:123456789101:function:RSALambda`
1. Copy down the Lambda region. It can be found on the top right corner of the page,
and is a next item to the right of the link with the user name (e.g. "us-east-1")


## Setting up AIM Policy

1. Select `Services` link (on the top left of the page) and them type `IAM` in the search line
1. Select `IAM Manage User Access and Encryption Keys` item
1. Select `Policies` item from the menu on the left
1. Press `Create Policy` button
1. Press `Select` for `Policy Generator`
1. On the `Edit Permissions` page do the following
    1. Set `Effect` to `Allow`
    1. Set `AWS Service` to `AWS Lambda`
    1. Set `Actions` to `InvokeFunction`
    1. Set `Amazon Resource Name (ARN)` to the Lambda **ARN** retrieved on the previous step
    1. Press `Add Statement`
    1. Press `Next Step`
1. Give your policy a name, for example, `allow-calling-RSALambda` and type in into the `Policy Name` field
1. Press `Create Policy`

## Setting up the AIM User

1. Select `Services` link (on the top left of the page) and them type `IAM` in the search line
1. Select the `IAM Manage User Access and Encryption Keys` item
1. Select `Users` item from the menu on the left
1. Press `Add user`
1. Choose a user name, for example `user-calling-lambda`
1. Check `Programmatic access` but not anything else
1. Press `Next: Permissions` button
1. Press `Attach existing policies directly` icon
1. Check `allow-calling-RSALambda` from the list of policies
1. Press `Next: Review`
1. Press `Create user`
1. Copy down your `Access key ID` and `Secret access key`

## Setting up Agent Code

Here is some agent [code](agent.nut). Copy and paste it into the Web IDE to the left window (agent code).

Set the example code configuration parameters with values retrieved on the previous steps:

Parameter             | Description
----------------------| -----------
AWS_LAMBDA_REGION     | AWS region where Lambda located
ACCESS_KEY_ID         | IAM `Access key ID`
SECRET_ACCESS_KEY     | IAM `Secret Access Key`

Run the example code and it should print the signature generated by the Lambda function.

# License

The AWSLambda library is licensed under the [MIT License](../../LICENSE).

