pragma circom 2.0.3;

include "key_schedule.circom";
include "permutation.circom";
include "rolling.circom";

template CiminionMac(nPairs) {

    var nSubKeys = 2*nPairs + 3;

    signal input MK_0;
    signal input MK_1;
    signal input nonce;
    signal input IV;
    signal input CT[nPairs*2];
    signal output TAG;

    signal acc_1[nPairs];
    signal acc_2[nPairs];
    signal MAC[nPairs];

    // sub key generation

    component key_schedule = KeySchedule(nSubKeys);

    key_schedule.s0 <== IV; 
    key_schedule.s1 <== MK_0;
    key_schedule.s2 <== MK_1;

    // first permutation pN
    
    component p_n = IteratedPermutationN();
    p_n.a0 <== nonce;
    p_n.b0 <== key_schedule.keys[1];
    p_n.c0 <== key_schedule.keys[2];

    component rolls[nPairs];
    component p_rs[nPairs];

    // start main loop

    for (var i = 0; i < nPairs; i++) {
        // MAC generation

        if (i == 0) {
            acc_1[i] <== CT[2*i] * key_schedule.keys[0];
            acc_2[i] <== acc_1[i] + CT[2*i + 1];
            MAC[i] <== acc_2[i] * key_schedule.keys[0];
        } else {
            acc_1[i] <== (MAC[i-1] + CT[2*i]) * key_schedule.keys[0];
            acc_2[i] <== acc_1[i] + CT[2*i + 1];
            MAC[i] <== acc_2[i] * key_schedule.keys[0];
        }
    }

    // end main loop

    // TAG generation

    component p_r2 = IteratedPermutationR();

    p_r2.a0 <== p_n.a1;
    p_r2.b0 <== p_n.b1;
    p_r2.c0 <== p_n.c1;

    TAG <== MAC[nPairs - 1] + p_r2.a1;
}

component main = CiminionMac(2);

