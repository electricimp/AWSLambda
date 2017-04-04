// MIT License
//
// Copyright 2017 Electric Imp
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
