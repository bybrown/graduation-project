function [y] = Cascade_IIR_Figure2_GeneratedCode(x,a1,a2,a1_hat,a2_hat,b0,b1,b2,b0_hat,b1_hat,b2_hat)
	persistent n12_add_reg_1 n13_add_reg_1 n15_add_reg_1 n16_add_reg_1;
	if (isempty(n12_add_reg_1))
		 n12_add_reg_1 = 0; n13_add_reg_1 = 0; n15_add_reg_1 = 0; n16_add_reg_1 = 0;
	end

	[n1_mul] = basic_mul(x,b0);
	[n2_mul] = basic_mul(x,b1);
	[n3_mul] = basic_mul(x,b2);
	[n11_add] = basic_add(n12_add_reg_1,n1_mul);
	[n4_mul] = basic_mul(n11_add,a1);
	[n5_mul] = basic_mul(n11_add,a2);
	[n6_mul] = basic_mul(n11_add,b0_hat);
	[n7_mul] = basic_mul(n11_add,b1_hat);
	[n8_mul] = basic_mul(n11_add,b2_hat);
	[n12_add] = three_add(n13_add_reg_1,n2_mul,n4_mul);
	[n13_add] = basic_add(n3_mul,n5_mul);
	[n14_add] = basic_add(n15_add_reg_1,n6_mul);
	[n9_mul] = basic_mul(n14_add,a1_hat);
	[n10_mul] = basic_mul(n14_add,a2_hat);
	[n15_add] = three_add(n16_add_reg_1,n7_mul,n9_mul);
	[n16_add] = basic_add(n8_mul,n10_mul);

	y = n14_add;

	n12_add_reg_1 = n12_add;
	n13_add_reg_1 = n13_add;
	n15_add_reg_1 = n15_add;
	n16_add_reg_1 = n16_add;
end