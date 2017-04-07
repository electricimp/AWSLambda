// Enter your AWS keys here
const AWS_LAMBDA_REGION = "us-west-2";
const ACCESS_KEY_ID = "ACCESS_KEY_ID";
const SECRET_ACCESS_KEY = "SECRET_ACCESS_KEY";

// constants for the test function names
const TEST_SENDRECEIVE_LAMBDA_FUNCTION = "mySendReceive";
const TEST_RECEIVE_LAMBDA_FUNCTION = "myReceive";
const TEST_BADFUNCTION_LAMBDA_FUNCTION = "myFailure";

const TEST_SENDRECEIVE_MESSAGE = "Hello, world!";
const TEST_RECEIVE_RESPONSE = "Hello, world!";

class AWSLambdaTestCase extends ImpTestCase {

    lambda = null;

    function setUp() {

        lambda = AWSLambda(AWS_LAMBDA_REGION, ACCESS_KEY_ID, SECRET_ACCESS_KEY);

    }


    // test that the lambda library is capable of handling error messages
    function testBadFunction() {
        return Promise(function(resolve, reject) {
            local params = {
                "payload": "",
                "functionName": TEST_BADFUNCTION_LAMBDA_FUNCTION
            }
            lambda.invoke(params, function(result) {
                try {
                    local payload = http.jsondecode(result.body);
                    local err = ("Message" in payload) ? payload.Message : null;
                    this.assertTrue(err != null, "Error response was expected");
                    resolve();
                } catch (e) {
                    return reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));
    }


    // tests that the lambda library is capable of receiving a payload from aws
    function testReceive() {
        return Promise(function(resolve, reject) {
            local params = {
                "payload": "",
                "functionName": TEST_RECEIVE_LAMBDA_FUNCTION
            }
            lambda.invoke(params, function(result) {
                try {
                    local payload = http.jsondecode(result.body);
                    this.assertTrue(payload == TEST_RECEIVE_RESPONSE, "The payload is: " + payload);
                    resolve();
                } catch (e) {
                    return reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));
    }


    // test that the lambda library is capable of sending a payload from aws
    function testSendReceive() {
        return Promise(function(resolve, reject) {
            local body = { "transmit": TEST_SENDRECEIVE_MESSAGE };
            local params = {
                "payload": body,
                "functionName": TEST_SENDRECEIVE_LAMBDA_FUNCTION
            }
            lambda.invoke(params, function(result) {
                try {
                    local payload = http.jsondecode(result.body);
                    local err = ("Message" in payload) ? payload.Message : null;
                    this.assertTrue(err == null, err);
                    this.assertTrue(payload.transmit == TEST_SENDRECEIVE_MESSAGE, "The payload is: " + payload);
                    resolve();
                } catch (e) {
                    return reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));
    }

}
