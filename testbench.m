clear figure1_GeneratedCode;
clear figure2_GeneratedCode;
clear figure3_GeneratedCode;

% a = 0.2;
% b = 0.3;
% c = 0.1;

b0= 1;
b1= 2;
b2= 1;
b3=1;
b0_hat =1;
b1_hat =2;
b2_hat =1;
a1=-0.2271;
a2=-0.4514;
a3= 0.1636;
a1_hat=-0.1636;
a2_hat=-0.0457;

x = 2*rand(1,2^16)-1;
y = zeros(size(x));
for i = 1:length(x)
%     y(i) = figure1_GeneratedCode(x(i),a,b,c);
%     y(i) = figure2_GeneratedCode(x(i),a,b,c);
%     y(i) = figure3_GeneratedCode(x(i),a,b,c);
%  y(i) = ParallelForm_IIR_Figure1_GeneratedCode2(x(i),a1,a2,a1_hat,a2_hat,b0,b1,b2,b0_hat,b1_hat,b2_hat);
  % y(i) =  Cascade_IIR_Figure2_GeneratedCode(x(i),a1,a2,a1_hat,a2_hat,b0,b1,b2,b0_hat,b1_hat,b2_hat); 
    y(i) =  Direct_Form_IIR_Figure4_GeneratedCode(x(i),a1,a2,a3,b0,b1,b2,b3);
end