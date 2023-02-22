import ballerina/graphql;
import ballerinax/mysql;
import ballerina/sql;

public type LikedItem record {|
    int user_id;
    int item_id;
|};


# A service representing a network-accessible GraphQL API
service / on new graphql:Listener(8090) {

    # A resource for generating greetings
    # Example query:
    #   query GreetWorld{ 
    #     greeting(name: "World") 
    #   }
    # Curl command: 
    #   curl -X POST -H "Content-Type: application/json" -d '{"query": "query GreetWorld{ greeting(name:\"World\") }"}' http://localhost:8090
    # 
    # + name - the input string name
    # + return - string name with greeting message or error
    resource function get greeting(string name) returns string|error {
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }

    isolated resource function post .(@http:Payload LikedItem li) {
       sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO liked (user_id, item_id)
        VALUES (${li.user_id}, ${li.item_id})
    `);
    }

    final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database=DATABASE);

    
    


}
