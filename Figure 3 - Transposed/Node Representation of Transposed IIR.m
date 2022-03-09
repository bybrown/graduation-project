%% Figure 3

%% 1.Declarations

% IO Declarations
x = Node('x', 0, 1, @basic_buffer, {'x'}, {'num'});
a1 = Node('a1', 0, 1, @basic_buffer_negative, {'a1'}, {'num'});
a2 = Node('a2', 0, 1, @basic_buffer_negative, {'a2'}, {'num'});
a3 = Node('a3', 0, 1, @basic_buffer_negative, {'a3'}, {'num'});
b0 = Node('b0', 0, 1, @basic_buffer,  {'b0'}, {'num'});
b1 = Node('b1', 0, 1, @basic_buffer,  {'b1'}, {'num'});
b2 = Node('b2', 0, 1, @basic_buffer,  {'b2'}, {'num'});
b3 = Node('b3', 0, 1, @basic_buffer, {'b3'}, {'num'});
y = Node('y', 1, 0, @basic_buffer, {'y'}, {'num'});

% Circuit Declarations
N1 = Node('mul', 2, 1, @basic_mul, {'n1_mul'}, {'num'});
N2 = Node('mul', 2, 1, @basic_mul, {'n2_mul'}, {'num'});
N3 = Node('mul', 2, 1, @basic_mul, {'n3_mul'}, {'num'});
N4 = Node('mul', 2, 1, @basic_mul, {'n4_mul'}, {'num'});
N5 = Node('mul', 2, 1, @basic_mul, {'n5_mul'}, {'num'});
N6 = Node('mul', 2, 1, @basic_mul, {'n6_mul'}, {'num'});
N7 = Node('mul', 2, 1, @basic_mul, {'n7_mul'}, {'num'});
N8 = Node('add', 2, 1, @basic_add, {'n8_add'}, {'num'});
N9 = Node('add', 3, 1, @three_add, {'n9_add'}, {'num'});
N10 = Node('add', 3, 1, @three_add, {'n10_add'}, {'num'});
N11 = Node('add', 2, 1, @basic_add, {'n11_add'}, {'num'});

%% 2.Connections

% IO Connections
Node.connect(x, 1, N1, 1, 0);
Node.connect(b0, 1, N1, 2, 0); %N1, sol üst çarpım

Node.connect(x, 1, N2, 1, 0);
Node.connect(b1, 1, N2, 2, 0); %N2, sol üstten 2. çarpım

Node.connect(x, 1, N3, 1, 0);
Node.connect(b2, 1, N3, 2, 0); %N3, sol üstten 3. çarpım

Node.connect(x, 1, N4, 1, 0);
Node.connect(b3, 1, N4, 2, 0); %N4, sol alt çarpım

Node.connect(a1, 1, N5, 1, 0);
Node.connect(N8, 1, N5, 2, 0); %N5, sağ üst çarpım

Node.connect(a2, 1, N6, 1, 0);
Node.connect(N8, 1, N6, 2, 0); %N6, sağ orta çarpım

Node.connect(a3, 1, N7, 1, 0);
Node.connect(N8, 1, N7, 2, 0); %N7, sağ alt çarpım

%Circuit Connections
Node.connect(N4, 1, N11, 1, 0);
Node.connect(N7, 1, N11, 2, 0); %N11, alt toplam

Node.connect(N11, 1, N10, 1, 1);
Node.connect(N3, 1, N10, 2, 0); 
Node.connect(N6, 1, N10, 3, 0); %N10, alttan 2. toplam

Node.connect(N10, 1, N9, 1, 1);
Node.connect(N2, 1, N9, 2, 0); 
Node.connect(N5, 1, N9, 3, 0); %N9, alttan 3. toplam

Node.connect(N9, 1, N8, 1, 1);
Node.connect(N1, 1, N8, 2, 0); %N8, üst toplam

Node.connect(N8, 1, y, 1, 0); %output

%% 3.Circuit Definition
input_nodes = [x, a1, a2, a3, b0, b1, b2, b3];
output_nodes = y;
circuit_nodes = [N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11];

%% 4. Circuit Check
%print_circuit(input_nodes, circuit_nodes, output_nodes);

%% 5. Code Generation
gen_coder_fcn('TransposeDForm_Figure3_GeneratedCode', input_nodes, circuit_nodes, output_nodes);


