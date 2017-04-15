// MIT License
//
// Copyright 2017 Electric Imp
// Copyright 2017 Mystic Pants Pty Ltd
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

// Enter your AWS keys here
const AWS_LAMBDA_REGION                 = "us-west-2";
const ACCESS_KEY_ID                     = "ACCESS_KEY_ID";
const SECRET_ACCESS_KEY                 = "SECRET_ACCESS_KEY";

// constants for the test function names
const TEST_SENDRECEIVE_LAMBDA_FUNCTION  = "mySendReceive";
const TEST_RECEIVE_LAMBDA_FUNCTION      = "myReceive";
const TEST_BADFUNCTION_LAMBDA_FUNCTION  = "myFailure";

const TEST_SENDRECEIVE_MESSAGE          = "Hello, world!";
const TEST_RECEIVE_RESPONSE             = "Hello, world!";

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
