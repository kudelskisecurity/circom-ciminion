pragma circom 2.0.3;

template Rolling() {
    signal input s0;
    signal input s1;
    signal input s2;
    
    signal output b0;
    signal output b1;
    signal output b2;
 
    b0 <== s2 + s0*s1;    
    b1 <== s0;    
    b2 <== s1;    
}

