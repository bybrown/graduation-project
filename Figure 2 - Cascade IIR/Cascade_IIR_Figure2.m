%% Figure 1
% y(n) = ax(n) + bx(n-1) + cx(n-2)

%% 1.Declarations
% IO Declarations
x = Node ('x',0,1 ,@basic_buffer, {'x'} ,{'num'});
a1 = Node ('a1',0,1 ,@basic_buffer_negative, {'a1'} ,{'num'});
a2 = Node ('a2',0,1 ,@basic_buffer_negative, {'a2'} ,{'num'});
a1_hat = Node ('a1_hat',0,1 ,@basic_buffer_negative, {'a1_hat'} ,{'num'});
a2_hat = Node ('a2_hat',0,1 ,@basic_buffer_negative, {'a2_hat'} ,{'num'});
b0 = Node ('b0',0,1 ,@basic_buffer, {'b0'} ,{'num'});
b1 = Node ('b1',0,1 ,@basic_buffer, {'b1'} ,{'num'});
b2 = Node ('b2',0,1 ,@basic_buffer, {'b2'} ,{'num'});
b0_hat = Node ('b0_hat',0,1 ,@basic_buffer, {'b0_hat'} ,{'num'});
b1_hat = Node ('b1_hat',0,1 ,@basic_buffer, {'b1_hat'} ,{'num'});
b2_hat = Node ('b2_hat',0,1 ,@basic_buffer, {'b2_hat'} ,{'num'});
y = Node ('y',1,0,@basic_buffer, {'y'} ,{'num'}); %2 giriþ 4 çýkýþlý node

% Circuit Declarations
N1 = Node ('mul', 2,1 ,@basic_mul, {'n1_mul'} ,{'num'});
N2 = Node ('mul', 2,1 ,@basic_mul, {'n2_mul'} ,{'num'});
N3 = Node ('mul', 2,1 ,@basic_mul, {'n3_mul'} ,{'num'});
N4 = Node ('mul', 2,1 ,@basic_mul, {'n4_mul'} ,{'num'});
N5 = Node ('mul', 2,1 ,@basic_mul, {'n5_mul'} ,{'num'});
N6 = Node ('mul', 2,1 ,@basic_mul, {'n6_mul'} ,{'num'});
N7 = Node ('mul', 2,1 ,@basic_mul, {'n7_mul'} ,{'num'});
N8 = Node ('mul', 2,1 ,@basic_mul, {'n8_mul'} ,{'num'});
N9 = Node ('mul', 2,1 ,@basic_mul, {'n9_mul'} ,{'num'});
N10 = Node ('mul', 2,1 ,@basic_mul, {'n10_mul'} ,{'num'});
N11 = Node ('add', 2,1 ,@basic_add, {'n11_add'} ,{'num'});
N12 = Node ('add', 3,1 ,@three_add, {'n12_add'} ,{'num'});
N13 = Node ('add', 2,1 ,@basic_add, {'n13_add'} ,{'num'});
N14 = Node ('add', 2,1 ,@basic_add, {'n14_add'} ,{'num'});
N15 = Node ('add', 3,1 ,@three_add, {'n15_add'} ,{'num'});
N16 = Node ('add', 2,1 ,@basic_add, {'n16_add'} ,{'num'});

%% 2.Connections
% IO Connections
Node.connect (x,1,N1,1,0);
Node.connect (b0,1,N1,2,0);  %N1 

Node.connect (x,1,N2,1,0);
Node.connect (b1,1,N2,2,0);  %N2

Node.connect (x,1,N3,1,0);
Node.connect (b2,1,N3,2,0);  %N3

Node.connect (N11,1,N4,1,0);
Node.connect (a1,1,N4,2,0);  %N4


Node.connect (N11,1,N5,1,0);
Node.connect (a2,1,N5,2,0); %N5

Node.connect (N11,1,N6,1,0);
Node.connect (b0_hat,1,N6,2,0); %N6


Node.connect (N11,1,N7,1,0);
Node.connect (b1_hat,1,N7,2,0); %N7


Node.connect (N11,1,N8,1,0);
Node.connect (b2_hat,1,N8,2,0); %N8

Node.connect (N14,1,N9,1,0);
Node.connect (a1_hat,1,N9,2,0); %N9

Node.connect (N14,1,N10,1,0);
Node.connect (a2_hat,1,N10,2,0); %N10

%Circuit Connections

Node.connect (N3,1,N13,1,0);
Node.connect (N5,1,N13,2,0); %N13

Node.connect (N13,1,N12,1,1);
Node.connect (N2,1,N12,2,0);
Node.connect (N4,1,N12,3,0); % N12

Node.connect (N12,1,N11,1,1);
Node.connect (N1,1,N11,2,0); % N11

Node.connect (N8,1,N16,1,0);
Node.connect (N10,1,N16,2,0); %N16

Node.connect (N16,1,N15,1,1);
Node.connect (N7,1,N15,2,0);
Node.connect (N9,1,N15,3,0); % N15

Node.connect (N15,1,N14,1,1);
Node.connect (N6,1,N14,2,0);
Node.connect (N14,1,y,1,0); %N14

%% 3.Circuit Definition
input_nodes = [x,a1,a2,a1_hat,a2_hat,b0,b1,b2,b0_hat,b1_hat,b2_hat];
output_nodes = y;
circuit_nodes = [N1,N2,N3,N4,N5,N6,N7,N8,N9,N10,N11,N12,N13,N14,N15,N16];

%% 4. Circuit Check
%print_circuit(input_nodes,circuit_nodes,output_nodes);

%% 5. Code Generation
gen_coder_fcn('Cascade_IIR_Figure2_GeneratedCode',input_nodes,circuit_nodes,output_nodes);
