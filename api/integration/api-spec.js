var request = require('request');
var base_url = "http://api-ingress:8080/";    

describe("When testing 'api/products/1'", function(){
    it("should respond with entry for 'resistor'", function(done) {
        request(base_url + 'api/products/1', function(error, response, body){
            product = JSON.parse(body)
            expect(product["description"]).toMatch('resistor');
            done();
        });
    });
});
