function [y] = Direct_Form_IIR_Figure4_GeneratedCode(x,a1,a2,a3,b0,b1,b2,b3)
	persistent n10_add_reg_1 n10_add_reg_2 n10_add_reg_3;
	if (isempty(n10_add_reg_1))
		 n10_add_reg_1 = 0; n10_add_reg_2 = 0; n10_add_reg_3 = 0;
	end

	[n1_mul] = basic_mul(a1,n10_add_reg_1);
	[n2_mul] = basic_mul(a2,n10_add_reg_2);
	[n3_mul] = basic_mul(a3,n10_add_reg_3);
	[n5_mul] = basic_mul(b1,n10_add_reg_1);
	[n6_mul] = basic_mul(b2,n10_add_reg_2);
	[n7_mul] = basic_mul(b3,n10_add_reg_3);
	[n8_add] = basic_add(n2_mul,n3_mul);
	[n11_add] = basic_add(n6_mul,n7_mul);
	[n9_add] = basic_add(n1_mul,n8_add);
	[n12_add] = basic_add(n5_mul,n11_add);
	[n10_add] = basic_add(x,n9_add);
	[n4_mul] = basic_mul(b0,n10_add);
	[n13_add] = basic_add(n4_mul,n12_add);

	y = n13_add;

	n10_add_reg_3 = n10_add_reg_2;
	n10_add_reg_2 = n10_add_reg_1;
	n10_add_reg_1 = n10_add;
end