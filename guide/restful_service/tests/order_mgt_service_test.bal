// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/http;

@test:BeforeSuite
function beforeFunc() {
    // Start the 'orderMgt' service before running the test.
    _ = test:startServices("restful_service");
}

endpoint http:Client clientEP {
    url:"http://localhost:9090/ordermgt"
};

@test:Config
// Function to test POST resource 'addOrder'.
function testResourceAddOrder() {
    // Initialize the empty http request.
    http:Request req = new;
    // Construct the request payload.
    json payload = {"Order":{"ID":"100500", "Name":"XYZ", "Description":"Sample order."}};
    req.setJsonPayload(payload);
    // Send 'POST' request and obtain the response.
    http:Response response = check clientEP -> post("/order", request=req);
    // Expected response code is 201.
    test:assertEquals(response.statusCode, 201,
        msg = "addOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"status\":\"Order Created.\",\"orderId\":\"100500\"}", msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceAddOrder"]
}
// Function to test PUT resource 'updateOrder'.
function testResourceUpdateOrder() {
    // Initialize empty http requests and responses.
    http:Request req = new;
    // Construct the request payload.
    json payload = {"Order":{"Name":"XYZ", "Description":"Updated order."}};
    req.setJsonPayload(payload);
    // Send 'PUT' request and obtain the response.
    http:Response response = check clientEP -> put("/order/100500", request=req);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "updateOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"Order\":{\"ID\":\"100500\",\"Name\":\"XYZ\",\"Description\":\"Updated order.\"}}",
        msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceUpdateOrder"]
}
// Function to test GET resource 'findOrder'.
function testResourceFindOrder() {
    // Initialize empty http requests and responses.
    http:Request req = new;
    // Send 'GET' request and obtain the response.
    http:Response response = check clientEP -> get("/order/100500", request=req);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "findOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"Order\":{\"ID\":\"100500\",\"Name\":\"XYZ\",\"Description\":\"Updated order.\"}}",
        msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceFindOrder"]
}
// Function to test DELETE resource 'cancelOrder'.
function testResourceCancelOrder() {
    // Initialize empty http requests and responses.
    http:Request req = new;
    // Send 'DELETE' request and obtain the response.
    http:Response response = check clientEP -> delete("/order/100500", request=req);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "cancelOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), "Order : 100500 removed.",
        msg = "Response mismatch!");
}

@test:AfterSuite
function afterFunc() {
    // Stop the 'orderMgt' service after running the test.
    test:stopServices("restful_service");
}
