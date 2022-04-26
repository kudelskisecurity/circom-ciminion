
/* Ciminion rolling function test */

const chai = require("chai");
const path = require("path");
const { stringify } = require("querystring");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
const crypto = require('crypto').webcrypto;

exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("Rolling function", function ()  {

    this.timeout(100000);

    it("Conformance test", async() => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "rolling.circom"));

        // generate random inputs

        let a = new BigUint64Array(1);
        let r1 = (crypto.getRandomValues(a)[0]);
        let r2 = (crypto.getRandomValues(a)[0]);
        let r3 = (crypto.getRandomValues(a)[0]);

        const s0 = Scalar.fromString(r1);
        const s1 = Scalar.fromString(r2);
        const s2 = Scalar.fromString(r3);

        // obtain witness

        let witness;
        witness = await circuit.calculateWitness({ "s0": s0, "s1": s1, "s2":s2}, true);

        // perform in js

        const b0 = s2 + s0*s1;    
        const b1 = s0;    
        const b2 = s1;    

        // compare result

        await circuit.assertOut(witness, {"b0": b0});
        await circuit.assertOut(witness, {"b1": b1});
        await circuit.assertOut(witness, {"b2": b2});

    });
});
