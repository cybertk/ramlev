var chai = require("chai")
var assert = chai.assert

describe("Require as a lib from js", function() {

    it("should succeed", function() {
        ramlev = require("../../");
        assert.ok(ramlev)
    });
});
