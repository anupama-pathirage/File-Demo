import ballerina/http;
import ballerinax/azure_storage_service.blobs as blobs;

configurable string accessKeyOrSAS = ?;
configurable string accountName = ?;
configurable string containerName = ?;

type Address record {
    string streetaddress;
    string city;
    string state;
    string postalcode;
};

type Personal record {
    string firstname;
    string lastname;
    string gender;
    int birthyear;
    Address address;
};

type Employee record {
    string empid;
    Personal personal;
};



final blobs:BlobClient blobClient = check getStorageClient();

service / on new http:Listener(9090) {
    
    resource function post employees (@http:Payload Employee[] employees) returns json|error {
        return blobClient->putBlob(containerName, "employees.json", "BlockBlob", employees.toJsonString().toBytes());
    }
}


function getStorageClient() returns blobs:BlobClient|error  => new({accessKeyOrSAS: accessKeyOrSAS, authorizationMethod: "accessKey", accountName: accountName});
    
