pragma circom 2.0.3;

include "permutation.circom";

template KeySchedule(nKeys) {
    signal input s0;
    signal input s1;
    signal input s2;
    
    signal output keys[nKeys];
    component p_n[nKeys];

    for (var i=0; i<nKeys; i++) {
        p_n[i] = IteratedPermutationN();

        if (i == 0) {
            p_n[i].a0 <== s0;
            p_n[i].b0 <== s1;
            p_n[i].c0 <== s2;            
        } else {
            p_n[i].a0 <== p_n[i-1].a1;
            p_n[i].b0 <== p_n[i-1].b1;
            p_n[i].c0 <== p_n[i-1].c1;
       }
       keys[i] <== p_n[i].a1;
    }
}

//component main = KeySchedule(5);

