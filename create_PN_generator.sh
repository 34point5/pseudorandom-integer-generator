#!/bin/bash

width=$1

> noise_generator.v

echo "module PNG(" >> noise_generator.v
echo -e "\tinput wire clock," >> noise_generator.v
echo -e "\tinput wire reset," >> noise_generator.v
echo -e "\toutput wire [$(($width-1)):0] Q," >> noise_generator.v
echo -e "\toutput wire [$(($width-1)):0] Qn);" >> noise_generator.v
echo >> noise_generator.v

echo -e "\twire d_in;" >> noise_generator.v
echo -en "\tassign d_in = 0" >> noise_generator.v
count=-1
for arg in $@; do
	count=$(($count+1))
	if (( $count >= 1 )); then
		echo -n " ^ Q[$(($arg-1))]" >> noise_generator.v
	fi
done
echo ";" >> noise_generator.v
echo >> noise_generator.v

for (( count = $(($width-1)); count > 0; count-- )); do
	echo -e "\tflop D_$count(clock, reset, Q[$(($count-1))], Q[$count], Qn[$count]);" >> noise_generator.v
done
echo -e "\tflop D_0(clock, reset, d_in, Q[0], Qn[0]);" >> noise_generator.v
echo >> noise_generator.v

echo "endmodule" >> noise_generator.v

> tb_noise_generator.v

echo "module tb_PNG;" >> tb_noise_generator.v
echo -e "\treg clock;" >> tb_noise_generator.v
echo -e "\treg reset;" >> tb_noise_generator.v
echo -e "\twire [$(($width-1)):0] Q;" >> tb_noise_generator.v
echo -e "\twire [$(($width-1)):0] Qn;" >> tb_noise_generator.v
echo >> tb_noise_generator.v

echo -e "\tPNG DUT(clock, reset, Q, Qn);" >> tb_noise_generator.v
echo >> tb_noise_generator.v

echo -e "\tinitial begin" >> tb_noise_generator.v
echo -en "\t\t\$display(\"reset" >> tb_noise_generator.v
echo -n "\tQ\n" >> tb_noise_generator.v
echo -e "\");" >> tb_noise_generator.v
echo -en "\t\t\$monitor(\"%b" >> tb_noise_generator.v
echo -n "\t%d" >> tb_noise_generator.v
echo -e "\", reset, Q);" >> tb_noise_generator.v

echo -e "\t\tclock = 0;" >> tb_noise_generator.v
echo -e "\t\treset = 1;" >> tb_noise_generator.v
echo -e "\t\t#33 reset = 0;" >> tb_noise_generator.v
# echo -e "\t\t#$((4*$((2**$width)))) \$finish;" >> tb_noise_generator.v
echo -e "\tend" >> tb_noise_generator.v
echo >> tb_noise_generator.v

echo -e "\talways begin" >> tb_noise_generator.v
echo -e "\t\t#2 clock = ~clock;" >> tb_noise_generator.v
echo -e "\tend" >> tb_noise_generator.v
echo >> tb_noise_generator.v

echo "endmodule" >> tb_noise_generator.v
