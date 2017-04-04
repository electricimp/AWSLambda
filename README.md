# AWSLambda

The helper library to invoke [AWS Lambda](http://docs.aws.amazon.com/lambda) functions from agent code.

To add this library to your model, add the following lines to the top of your agent code:

```
#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSLambda.class.nut:1.0.0"
```

**Note: [AWSRequestV4](https://github.com/electricimp/AWSRequestV4/) must be included.**

## Class Methods

### constructor(region, accessKeyId, secretAccessKey)

AWSLambda object constructor takes the following parameters:

 Parameter             | Type           | Description
---------------------- | -------------- | -----------
region                 | string         | AWS region (e.g. "us-east-1")
accessKeyId            | string         | IAM Access Key ID
secretAccessKey        | string         | IAM Secret Access Key

### invoke(params, callback = null)

Invokes lambda function. Please refer to the AWS Lambda [documentation](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html) for more details.

The function takes the following parameters:

 Parameter         | Type           | Description
------------------ | -------------- | -----------
params             | table          | Table of parameters (See API Reference)
callback           | function       | Callback function that takes one parameter (response table)

where `params` are:

Parameter             | Type           | Description
--------------------- | -------------- | -----------
functionName          | string         | Name of the function to be called
payload               | string         | JSON that you want to provide to your Lambda function as input
contentType           | string         | The payload content type. "application/json" by default.

## Example

```squirrel
#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSLambda.class.nut:1.0.0"

const AWS_LAMBDA_REGION = "us-west-1"
const ACCESS_KEY_ID     = "YOUR_ACCES_KEY_ID";
const SECRET_ACCESS_KEY = "YOUR_SECRET_ACCESS_KEY";

local lambda = AWSLambda(AWS_LAMBDA_REGION, ACCESS_KEY_ID, SECRET_ACCESS_KEY);
local body   = {"message" : "hello world!"};
local params = {
    "payload"      : http.jsonencode(body),
    "functionName" : "RSALambda"
}

function callback(result) {
    local payload = http.jsondecode(result.body);
    if ("errorMessage" in payload) {
        server.log("[ERROR] " + payload.errorMessage);
    } else {
        server.log("[SUCCEDED] base64encoded signature: " + payload.signature);
    }
}
lambda.invoke(params, callback);
```

# License

The AWSLambda library is licensed under the [MIT License](LICENSE).
