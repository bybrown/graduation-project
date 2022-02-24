function [y] = TransposeDForm_Figure3_GeneratedCode(x,a1,a2,a3,b0,b1,b2,b3)
	persistent n9_add_reg_1 n10_add_reg_1 n11_add_reg_1;
	if (isempty(n9_add_reg_1))
		 n9_add_reg_1 = 0; n10_add_reg_1 = 0; n11_add_reg_1 = 0;
	end

	[n1_mul] = basic_mul(x,b0);
	[n2_mul] = basic_mul(x,b1);
	[n3_mul] = basic_mul(x,b2);
	[n4_mul] = basic_mul(x,b3);
	[n8_add] = basic_add(n9_add_reg_1,n1_mul);
	[n5_mul] = basic_mul(a1,n8_add);
	[n6_mul] = basic_mul(a2,n8_add);
	[n7_mul] = basic_mul(a3,n8_add);
	[n9_add] = three_add(n10_add_reg_1,n2_mul,n5_mul);
	[n10_add] = three_add(n11_add_reg_1,n3_mul,n6_mul);
	[n11_add] = basic_add(n4_mul,n7_mul);

	y = n8_add;

	n9_add_reg_1 = n9_add;
	n10_add_reg_1 = n10_add;
	n11_add_reg_1 = n11_add;
end