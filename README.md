# AWSLambda #

This library can be used to invoke [Amazon Web Services (AWS) Lambda](http://docs.aws.amazon.com/lambda) functions from your agent code. It depends upon the [AWSRequestV4](https://github.com/electricimp/AWSRequestV4/) library, which **must** be included.

**To add this library to your model, add the following lines to the top of your agent code:**

```
#require "AWSLambda.agent.lib.nut:1.0.0"
#require "AWSRequestV4.class.nut:1.0.2"
```

**Note** [AWSRequestV4](https://github.com/electricimp/AWSRequestV4/) **must** be included.

## Class Usage ##

### Constructor: AWSLambda(*region, accessKeyId, secretAccessKey*) ###

#### Parameters ####

| Parameter | Type | Description |
| --- | --- | --- |
| *region* | String | AWS region (eg. `"us-east-1"`) |
| *accessKeyID* | String | IAM Access Key ID |
| *secretAccessKey* | String | IAM Secret Access Key |

See the [RSACrypto example](/examples/RSACrypto#setting-up-the-aim-user) for instructions on setting up AIM user, and retrieving IAM Access Key ID and IAM Secret Access Key.

#### Example ####

```squirrel
#require "AWSLambda.agent.lib.nut:1.0.0"
#require "AWSRequestV4.class.nut:1.0.2"

const AWS_LAMBDA_REGION = "us-west-1";
const ACCESS_KEY_ID     = "<YOUR_ACCESS_KEY_ID>";
const SECRET_ACCESS_KEY = "<YOUR_SECRET_ACCESS_KEY>";

lambda <- AWSLambda(AWS_LAMBDA_REGION, ACCESS_KEY_ID, SECRET_ACCESS_KEY);
```

## Class Methods ##

### invoke(*params[, callback]*) ###

This method invokes a lambda function. Please refer to the AWS Lambda [documentation](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html) for more details.

#### Parameters ####

| Parameter  | Type     | Description |
| ---------- | -------- | ----------- |
| *params*   | Table    | Table of parameters, see below |
| *callback* | Function | Callback function that takes one parameter: an [**httpresponse**](https://developer.electricimp.com/api/httpresponse) object |

The *params* table can contain the following keys:

| Parameter      | Type              | Required | Default Value        | Description |
| -------------- | ----------------- | -------- | -------------------- | ----------- |
| *functionName* | String            | Yes      | N/A                  | Name of the Lambda function to be called |
| *payload*      | Serializable data | Yes      | N/A                  | Data that you want to provide to your Lambda |
| *contentType*  | String            | No       | `"application/json"` | The payload content type |

#### Example ####

```squirrel
local payload = { "message" : "Hello, world!" };
local params  = { "payload" : payload, 
                  "functionName" : "MyLambdaFunction" };
lambda.invoke(params, function (result) {
  local payload = http.jsondecode(result.body);
  if ("Message" in payload) {
    server.log("Invocation error: " + payload.Message);
  } else if ("errorMessage" in payload) {
    server.log("Runtime error: " + payload.errorMessage);
  } else {
    server.log("[SUCCESS]: " + payload.result);
  }
}.bindenv(this))
```

## License ##

The AWSLambda library is licensed under the [MIT License](LICENSE).
