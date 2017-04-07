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
region                 | string         | AWS region (e.g. "us-west-1")
accessKeyId            | string         | IAM Access Key ID
secretAccessKey        | string         | IAM Secret Access Key

#### Example

```squirrel
#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSLambda.class.nut:1.0.0"

const AWS_LAMBDA_REGION = "us-west-1";
const ACCESS_KEY_ID     = "YOUR_ACCESS_KEY_ID";
const SECRET_ACCESS_KEY = "YOUR_SECRET_ACCESS_KEY";

lambda <- AWSLambda(AWS_LAMBDA_REGION, ACCESS_KEY_ID, SECRET_ACCESS_KEY);
```



### invoke(params, callback = null)

Invokes lambda function. Please refer to the AWS Lambda [documentation](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html) for more details.

The function takes the following parameters:

 Parameter         | Type           | Description
------------------ | -------------- | -----------
params             | table          | Table of parameters (See API Reference)
callback           | function       | Callback function that takes one parameter ([response table](https://electricimp.com/docs/api/httprequest/sendasync/))

where `params` include:

Parameter             | Type              | Required | Default Value      | Description
--------------------- | ----------------- | -------- | ------------------ | ------------
functionName          | string            | yes      | N/A                | Name of the Lambda function to be called
payload               | serializable data | yes      | N/A                | Data that you want to provide to your Lambda
contentType           | string            | no       | "application/json" | The payload content type

#### Example

```squirrel
local payload = { "message" : "Hello, world!" };
local params  = { "payload" : payload, "functionName" : "mySend" };
lambda.invoke(params, function (result) {
    local payload = http.jsondecode(result.body);
    if ("Message" in payload) {
        server.error(payload.Message);
    } else {
        server.log("[SUCCESS]: " + payload.transmit);
    }
}.bindenv(this))
```


# License

The AWSLambda library is licensed under the [MIT License](LICENSE).
