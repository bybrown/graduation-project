function [y] = ParallelForm_IIR_Figure1_GeneratedCode2(x,a1,a2,a1_hat,a2_hat,b0,b1,b2,b0_hat,b1_hat,b2_hat)
	persistent n12_add_reg_1 n13_add_reg_1 n15_add_reg_1 n16_add_reg_1;
	if (isempty(n12_add_reg_1))
		 n12_add_reg_1 = 0; n13_add_reg_1 = 0; n15_add_reg_1 = 0; n16_add_reg_1 = 0;
	end

	[n1_mul] = basic_mul(x,b0);
	[n2_mul] = basic_mul(x,b1);
	[n3_mul] = basic_mul(x,b2);
	[n4_mul] = basic_mul(x,b0_hat);
	[n5_mul] = basic_mul(x,b1_hat);
	[n6_mul] = basic_mul(x,b2_hat);
	[n11_add] = basic_add(n12_add_reg_1,n1_mul);
	[n14_add] = basic_add(n15_add_reg_1,n4_mul);
	[n7_mul] = basic_mul(n11_add,a1);
	[n8_mul] = basic_mul(n11_add,a2);
	[n9_mul] = basic_mul(n11_add,a1_hat);
	[n10_mul] = basic_mul(n11_add,a2_hat);
	[n17_add] = basic_add(n11_add,n14_add);
	[n12_add] = three_add(n13_add_reg_1,n2_mul,n7_mul);
	[n13_add] = basic_add(n3_mul,n8_mul);
	[n15_add] = three_add(n16_add_reg_1,n5_mul,n9_mul);
	[n16_add] = basic_add(n6_mul,n10_mul);

	y = n17_add;

	n12_add_reg_1 = n12_add;
	n13_add_reg_1 = n13_add;
	n15_add_reg_1 = n15_add;
	n16_add_reg_1 = n16_add;
end