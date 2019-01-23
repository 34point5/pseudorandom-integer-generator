# pseudorandom integer (noise) generator
Run it with arguments to create a PRNG.

`./create_PN_generator.sh 4 1 3`

First argument is the register width (use 4 D-type flip-flops); remaining arguments denote the feedback coefficients (i.e. which flip-flop outputs are XORed and fed back to the first flip-flop).
