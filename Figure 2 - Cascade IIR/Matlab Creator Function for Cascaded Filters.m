%% Cascade IIR Filter Creator


%% Authors : Hüseyin Cem Ekkkazan - Büþra Yassýbaþ 
%% Senior Design Project 

%%
% Here, Cascade IIR filter can be created as the user's demand. User  should determine the necessary order and pick the name of the filter. 
% In command window, after the function 'filterCreator' typed,'filterNameRepresentation.m' file will be created automatically.
% Via Erdem Uluçýnar's tool, MATLAB codes which will converted Verilog codes owing to HDLcoder tool  will be generated. 

%%
function Cascade_filterCreator(order, filterName, numerator, denominator) % order represents filter order, filterName can be selected by user arbitrarily
  
  %Here, how much sections are needed according to given order.
  if mod(order,2) == 0
    sections = order / 2;
  else
    sections = (order + 1) / 2;
  end
  
  % Detection of number of sections and rows of SOS matrix are matching
  sos = tf2sos(numerator, denominator);
  [rows , ~]=size(sos);
  
  if rows ~= sections
    error('Number of the second order sections is not matching with the specified order.');
  end
  
  % X input and y output buffer nodes are first created.
  filter = "x = Node('x', 0, 1, @basic_buffer, {'x'}, {'num'});" + newline;
  filter = filter + "y = Node('y', 1, 0, @basic_buffer, {'y'}, {'num'});" + newline;
  
  filter = filter + newline;
  
  %In dataflow graph, a coefficients are all negative, so the negative
  %buffer nodes are created here. In dataflow graph, a0 node is not shown
  %because of its value is 1 always. 
 
  for i = 0:sections - 1
    for j = 0:2
      if j ~= 0
        a = "a_" + num2str(i) + "_" + num2str(j);
        node = a + " = Node('"+a+"', 0, 1, @basic_buffer_negative, {'"+a+"'}, {'num'});" + newline;

        filter = filter + node;
      end
    end
  end
  
  filter = filter + newline;
  
  % Here, the b coefficients are generated same with a coeffs. The only
  % difference is b coefficients are started 0 to number of order. 
  for i = 0:sections - 1
    for j = 0:2
      b = "b_" + num2str(i) + "_" + num2str(j);
      node = b + " = Node('"+b+"', 0, 1, @basic_buffer, {'"+b+"'}, {'num'});" + newline;

      filter = filter + node;
    end
  end
  
  filter = filter + newline;
  
  %Each section has own summation and multiplication nodes,here summation
  %nodes are created. Created summation nodes are as S(3*section_number -2)
  for i = 1:sections
    for j = 1:3
      nodeNumber = j + (i - 1) * 3;
      
      nodeName = "S" + num2str(nodeNumber);
      
      %In the middle of sections, summation node there, has 3 inputs and 1
      %output. 
      if j == 2
        node = nodeName + " = Node('add', 3, 1, @three_add, {'"+nodeName+"_add'}, {'num'});" + newline;
        
      %Rest of the summation nodes have 2 inputs and 1 output
      else
        node = nodeName + " = Node('add', 2, 1, @basic_add, {'"+nodeName+"_add'}, {'num'});" + newline;
      end
      filter = filter + node;
    end
  end
  
  filter = filter + newline;
  
  mulNumber = sections * 6;  %Multiplication node number is defined here, each section has 6 Multiplication nodes.
  
  %In every section, due to a0 coeffitient is always 1, there is 1
  %multiplication node missing (Unnecessary to put in). These are detected
  %and put in nullMuls array. 
  
  nullMuls = [];
  for i = 0:order
    nullMuls(end+1) = i * 6 + 2;
  end
  
  %If the numerated multiplication node is not member of nullMuls array, it
  %is created as 2 inputs and 1 output node then. 
  for i = 1:mulNumber
    if ismember(i, nullMuls) ~= true
      nodeName = "M" + num2str(i);

      node = nodeName + " = Node('mul', 2, 1, @basic_mul, {'"+nodeName+"_mul'}, {'num'});" + newline;
      filter = filter + node;
    end
  end
  
  filter = filter + newline;
  
  % Circuit node connection definings
  for i = 1:sections
    for j = 1:3
      nodeNumber = j + (i - 1) * 3;
      
      %Here,composition of each summation node as multiplication and other
      %summation nodes. 
      
           
      node = "S" + num2str(nodeNumber);
      
      if j == 1
        conn = "Node.connect(M"+num2str(2*nodeNumber - 1)+", 1, "+node+", 1, 0);" + newline;
        filter = filter + conn;

        conn = "Node.connect(S"+num2str(nodeNumber + 1)+", 1, "+node+", 2, 1);" + newline;
        filter = filter + conn;
      elseif j == 2
        conn = "Node.connect(M"+num2str(2*nodeNumber - 1)+", 1, "+node+", 1, 0);" + newline;
        filter = filter + conn;

        conn = "Node.connect(M"+num2str(2*nodeNumber)+", 1, "+node+", 2, 0);" + newline;
        filter = filter + conn;

        conn = "Node.connect(S"+num2str(nodeNumber + 1)+", 1, "+node+", 3, 1);" + newline;
        filter = filter + conn;
      elseif j == 3
        conn = "Node.connect(M"+num2str(2*nodeNumber - 1)+", 1, "+node+", 1, 0);" + newline;
        filter = filter + conn;

        conn = "Node.connect(M"+num2str(2*nodeNumber)+", 1, "+node+", 2, 0);" + newline;
        filter = filter + conn;
      end
      
      filter = filter + newline;
    end
  end
  
  for i = 1:sections
    for j = 1:6
      if j ~= 2
        nodeNumber = j + (i - 1) * 6;
        
      %Here,composition of each summation node as multiplication and other
      %summation nodes. 
        node = "M" + num2str(nodeNumber);
        
        if mod(nodeNumber, 2) == 0
          sumNode = "S" + num2str((i - 1)*3 + 1);
          
          conn = "Node.connect("+sumNode+", 1, "+node+", 1, 0);" + newline;
          filter = filter + conn;
          
        % a coefficient node is depend on section number,i.
          if j == 4
            a = "a_" + num2str(i - 1) + "_1";
          else
            a = "a_" + num2str(i - 1) + "_2";
          end

          conn = "Node.connect("+a+", 1, "+node+", 2, 0);" + newline;
          filter = filter + conn;
        else
          if i > 1
            sumNode = "S" + num2str((i - 2)*3 + 1);
            
            conn = "Node.connect("+sumNode+", 1, "+node+", 1, 0);" + newline;
            filter = filter + conn;
         % b coefficient node is depend on section number,i.
            if j == 1
              b = "b_" + num2str(i - 1) + "_0";
            elseif j == 3
              b = "b_" + num2str(i - 1) + "_1";
            else
              b = "b_" + num2str(i - 1) + "_2";
            end
            
            conn = "Node.connect("+b+", 1, "+node+", 2, 0);" + newline;
            filter = filter + conn;
          else
            conn = "Node.connect(x, 1, "+node+", 1, 0);" + newline;
            filter = filter + conn;
            
            if j == 1
              b = "b_0_0";
            elseif j == 3
              b = "b_0_1";
            else
              b = "b_0_2";
            end
            
            conn = "Node.connect("+b+", 1, "+node+", 2, 0);" + newline;
            filter = filter + conn;
          end
        end
        
        filter = filter + newline;
      end
    end
  end
  
  %Output node is always last sections' first summation node
  outputNode = "S" + num2str((sections - 1) * 3 + 1);
  
  % When all the dataflow representation as nodes is done, finally the y output
  % buffer node is linked output node's output.
  filter = filter + "Node.connect("+outputNode+", 1, y, 1, 0);" + newline;
  % All input nodes ( x and coeffients a and b ) is generated below and
  % shown in inputNodes array.
  inputNodes = "inputNodes = [x, ";
  
  for i = 0:sections - 1
    for j = 1:2
      inputNodes = inputNodes + "a_" + num2str(i) + "_" + num2str(j) + ", ";
    end 
  end
  
  for i = 0:sections -1
    for j = 0:2
      if i ~= sections - 1 || j ~= 2
        inputNodes = inputNodes + "b_" + num2str(i) + "_" + num2str(j) + ", ";
      end
    end 
  end
  
  inputNodes = inputNodes + "b_" + num2str(sections - 1) + "_" + num2str(2) + "];";
  
  filter = filter + newline;
  filter = filter + inputNodes;
  
  filter = filter + newline;
  filter = filter + "outputNodes = y;";
  
  
  %All the generated multiplication and summation nodes are shown in array below. 
  circuitNodes = "circuitNodes = [";
  
  for i = 1:sections*3
      circuitNodes = circuitNodes + "S" + num2str(i) + ", ";
  end
  
  for i = 1:sections
    for j = 1:6
      if j ~= 2
        if i ~= sections || j ~= 6
          circuitNodes = circuitNodes + "M" + num2str((i -1) * 6 + j) + ", ";
        end
      end
    end
  end
  
  circuitNodes = circuitNodes + "M" + num2str(sections * 6) + "];";
  
  filter = filter + newline;
  filter = filter + circuitNodes;
  
  filter = filter + newline + newline;
  
  % Filter design according to dataflow graph is done, in the below, we can
  % generate MATLAB code.
  filter = filter + "gen_coder_fcn('"+filterName+"', inputNodes, circuitNodes, outputNodes)";
  
  fileName = filterName + "Representation.m";
  
  file = fopen(fileName, 'wt');
  fprintf(file, '%s', filter);
  fclose(file);
  
  % From here on, testbench code is generated 
  testBench ="clear" + newline;
  testBench = testBench + "q = quantizer('fixed','floor','saturate',[8 6]);";
  
  testBench = testBench + newline;
  
  %Sampling frequency selected as 48000 Hz 
  testBench = testBench + "Ts = 1/48000;" + newline;
  testBench = testBench + "fNy = 1 / Ts / 2;" + newline; 
  testBench = testBench + "ns = 1000;" + newline; 
  testBench = testBench + "nf = 10;" + newline;
  
  testBench = testBench + newline;
  
  
  testBench = testBench + "for i = 1:ns" + newline;
  testBench = testBench + "  freq(i) = (fNy/ns) * round(i/ns*nf)*ns/nf;" + newline; 
  testBench = testBench + "end" + newline;
  testBench = testBench + newline;
  testBench = testBench + "for i = 1:ns" + newline;
  testBench = testBench + "  x(i) = cos(2*pi*freq(i)*Ts*i);" + newline; %Input X determined as sinusoidal signal
  testBench = testBench + "end" + newline;
  
  testBench = testBench + newline;
  
  testBench = testBench + "x_in=num2hex(q,x);" + newline;
  testBench = testBench + "x_in=hex2num(q,x_in);" + newline;
  
  testBench = testBench + newline;
  
  %The user can automatically generate the coefficients here by exporting the numerator and denominator of the 
  %transfer function of the filter created from the filterDesigner tool.
  for i = 1:sections
    testBench = testBench + "b_" + num2str(i - 1) + "_0" + " = " + num2str(sos(i, 1)) + ";" + newline;
    testBench = testBench + "b_" + num2str(i - 1) + "_1" + " = " + num2str(sos(i, 2)) + ";" + newline;
    testBench = testBench + "b_" + num2str(i - 1) + "_2" + " = " + num2str(sos(i, 3)) + ";" + newline;
  end
  
  for i = 1:sections
    testBench = testBench + "a_" + num2str(i - 1) + "_1" + " = " + num2str(sos(i, 5)) + ";" + newline;
    testBench = testBench + "a_" + num2str(i - 1) + "_2" + " = " + num2str(sos(i, 6)) + ";" + newline;
  end

  testBench = testBench + newline;
  
  testBench = testBench + "y = zeros(size(x_in));" + newline;
  testBench = testBench + "for i = 1:length(x_in) " + newline;
  
  % Output y signal is generated here
  testBench = testBench + "y(i) = " + filterName + "(x_in(i), ";
  
  for i = 0:sections - 1
    for j = 1:2
      testBench = testBench + "a_" + num2str(i) + "_" + num2str(j) + ", ";
    end 
  end
  
  for i = 0:sections - 1
    for j = 0:2
      if i ~= sections - 1 || j ~= 2
        testBench = testBench + "b_" + num2str(i) + "_" + num2str(j) + ", ";
      end
    end 
  end
  
  testBench = testBench + "b_" + num2str(sections - 1) + "_" + num2str(2) + ");" + newline;
  
  testBench = testBench + "end" + newline;
  
  testBench = testBench + newline;
  
  testBench = testBench + "figure;" + newline;
  
  testBench = testBench + newline;
  
  testBench = testBench + "subplot(2,2,1);" + newline;
  testBench = testBench + "plot(x_in);" + newline;
  testBench = testBench + "title('X signal in time');" + newline;
  testBench = testBench + "spec = abs(fft(x_in));" + newline;
  testBench = testBench + "subplot(2,2,2);" + newline;
  testBench = testBench + "plot((0:100:50e3-100),spec(1:ns/2));" + newline;
  testBench = testBench + "title('X signal in frequency');" + newline;
  
  testBench = testBench + newline;
  
  testBench = testBench + "subplot(2,2,3);" + newline;
  testBench = testBench + "plot(y);" + newline;
  testBench = testBench + "title('Y signal in time');" + newline;
  testBench = testBench + "spec2 = abs(fft(y));" + newline;
  testBench = testBench + "subplot(2,2,4);" + newline;
  testBench = testBench + "plot((0:100:50e3-100),spec2(1:ns/2));" + newline;
  testBench = testBench + "title('Y signal in frequency');" + newline;

  tbName = filterName + "TB.m";
  
  file = fopen(tbName, 'wt');
  fprintf(file, '%s', testBench);
  fclose(file);
end