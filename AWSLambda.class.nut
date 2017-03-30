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

const AWS_LAMBDA_SERVICE              = "lambda";
const AWS_LAMBDA_URL_PREFIX           = "/2015-03-31/functions/";
const AWS_LAMBDA_APPJSON_CONTENT_TYPE = "application/json";

class AWSLambda {

    static VERSION = "1.0.0";

	_awsRequest = null;

    // Lambda object constructor
    //
    // @param {string} region               - AWS region (e.g. "us-east-1")
    // @param {string} accessKeyId          - IAM Access Key ID
    // @param {string} secretAccessKey      - IAM Secret Access Key
    //
    // Returns: Lambda object created
	constructor(region, accessKeyId, secretAccessKey) {
		if ("AWSRequestV4" in getroottable()) {
			_awsRequest = AWSRequestV4(AWS_LAMBDA_SERVICE, region, accessKeyId, secretAccessKey);
		} else {
			throw("This class requires AWSRequestV4 - please make sure it is includes");
		}
	}

    // Invokes lambda function
    //
    // @param {table} params               - table with parameters:
    //
    //        @param {string} functionName       - function name to be called
    //        @param {table} argsPayload         - function arguments
    //        @param {string} contentType        - the content type of the function
    //                                             arguments to be transfered.
    //                                             If not provided, "application/json"
    //                                             is used.
    //
    // @param {function} callback          - IAM Access Key ID
    //
    // Returns: Lambda object created
    function invoke(params, callback = null) {
        local contentType = "contentType" in params && params["contentType"]
                            ? strip(params["contentType"].toLower())
                            : AWS_LAMBDA_APPJSON_CONTENT_TYPE;
        local headers = {
            "Content-Type": contentType
        };
        local body = contentType == AWS_LAMBDA_APPJSON_CONTENT_TYPE
                     ? http.jsonencode(params.argsPayload)
                     : argsPayload;
        _awsRequest.post(AWS_LAMBDA_URL_PREFIX + params.functionName + "/invocations", headers, body, callback);
    }
}
