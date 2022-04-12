function Parallel_Filter_Creator(order, filterName, numerator, denominator)

 %Here, how much sections are needed according to given order.
  if mod(order,2) == 0  %filtre 4 katsayý ise
    sections = order / 2;% B1,B2 çýkýyo 2 B arrayi çýkýyo 
  else
    sections = (order + 1) / 2;
  end
  
  % Detection of number of sections and rows of SOS matrix are matching
  
  testBench =  "clear" +newline;
  
  testBench = testBench + "numerator = " + mat2str(numerator)+  ";" + newline;
  testBench = testBench + "denominator = " + mat2str(denominator)+  ";" + newline;

  testBench = testBench + "[R,p,C] = residuez(numerator,denominator)" +  ";"+newline;
  testBench = testBench + "C" + ";"+  newline;
  
if mod(order,2) == 0  %filtre 4 katsayý ise
    sections = order / 2;% B1,B2 çýkýyo 2 B arrayi çýkýyo 
    for i= 1: sections
     testBench = testBench + "[B" + num2str(i) + ",A" + num2str(i) + "]" +"=residuez(R( " + num2str(2*i-1) +":" + num2str(2*i)+"),p(" + num2str(2*i-1) +":" + num2str(2*i)+"),[])"+newline;
     testBench = testBench + "B" + num2str(i) + "= real (B"+ num2str(i)+");"+ newline;
     testBench = testBench + "A" + num2str(i) + "= real (A"+ num2str(i)+");"+ newline;
    end  

 testBench = testBench + newline;

  % X input and y output buffer nodes are first created.
  filter = "x = Node('x', 0, 1, @basic_buffer, {'x'}, {'num'});" + newline;
  filter = filter + "C = Node('C', 0, 1, @basic_buffer, {'C'}, {'num'});" + newline;
  filter = filter + "y = Node('y', 1, 0, @basic_buffer, {'y'}, {'num'});" + newline;
  
  filter = filter + newline;
  
  %In dataflow graph, a coefficients are all negative, so the negative
  %buffer nodes are created here. In dataflow graph, a0 node is not shown
  %because of its value is 1 always. 
 if mod(order,2) == 0
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
    for j = 0:1
      b = "b_" + num2str(i) + "_" + num2str(j);
      node = b + " = Node('"+b+"', 0, 1, @basic_buffer, {'"+b+"'}, {'num'});" + newline;

      filter = filter + node;
    end
  end
  
  filter = filter + newline;
 else 
    for i = 0:sections - 2
    for j = 0:2
      if j ~= 0
        a = "a_" + num2str(i) + "_" + num2str(j);
        node = a + " = Node('"+a+"', 0, 1, @basic_buffer_negative, {'"+a+"'}, {'num'});" + newline;

        filter = filter + node;
      end
    end
    
    a = "a_" + num2str(sections -1) + "_" + num2str(1);
    node = a + " = Node('"+a+"', 0, 1, @basic_buffer_negative, {'"+a+"'}, {'num'});" + newline;

    filter = filter + node;
  end

  
   filter = filter + newline;
  
  % Here, the b coefficients are generated same with a coeffs. The only
  % difference is b coefficients are started 0 to number of order. 
  for i = 0:sections - 2
    for j = 0:1
      b = "b_" + num2str(i) + "_" + num2str(j);
      node = b + " = Node('"+b+"', 0, 1, @basic_buffer, {'"+b+"'}, {'num'});" + newline;

      filter = filter + node;
    end
  end
  
   b = "b_" + num2str(sections-1) + "_" + num2str(0);
   node = b + " = Node('"+b+"', 0, 1, @basic_buffer, {'"+b+"'}, {'num'});" + newline;

   filter = filter + node;
  filter = filter + newline;
  
 end
  
 %%% Summation node creation 
  filter = filter + " SC = Node('add', 2, 1, @basic_add, {'SC_add'}, {'num'});" ;
  filter = filter + newline;
  
  
  sumNumber = sections * 3 ;
  
  nullSums_1 = [];
  nullSums_2= [];
  for i = 1:order
    nullSums_1(end +1) = i * 4 ;
    nullSums_2(end +1) = i * 4 + 2 ;
  end

  
 %%%%%%
  for i = 1:sections
      for j=1:3
          nodeNumber = (i-1)*4 + j;
          
    if ismember(nodeNumber, nullSums_1 ) ~= true && ismember(nodeNumber, nullSums_2 ) ~= true
      nodeName = "S" + num2str(nodeNumber);
   
       if mod(nodeNumber,4) ==3
           node = nodeName + " = Node('add', 3, 1, @three_add, {'"+nodeName+"_add'}, {'num'});" + newline;
           
       elseif  mod(nodeNumber,4) == 1 || mod(nodeNumber,4) == 2
      node = nodeName + " = Node('add', 2, 1, @basic_add, {'"+nodeName+"_add'}, {'num'});" + newline;
       end
      filter = filter + node;
    end
     end
  end
  
  if sections >2
      for i = 3:sections
       nodeNumber = (i)*4 -6;
       nodeName = "S" + num2str(nodeNumber);
       node = nodeName + " = Node('add', 2, 1, @basic_add, {'"+nodeName+"_add'}, {'num'});" + newline;
       filter = filter + node;
      end
  end
  
filter = filter + newline;


%%% Multiplier Node Creation
  filter = filter + " MC = Node('add', 2, 1, @basic_mul, {'MC_mul'}, {'num'});";
  filter = filter + newline;
 
  
  nullMuls_1 = [];
  nullMuls_2 = [];
  for i = 0:sections
    nullMuls_1(end+1) = i * 6 + 2 ; % Missing M2, M8, M14 ... nodes
    nullMuls_2(end+1) = i * 6 + 5 ; % Missing M5, M11, M17 ... nodes
  end
  
   for i = 1:sections
      for j=1:6
          nodeNumber = (i-1)*6 + j;
          
    if ismember(nodeNumber, nullMuls_1) ~= true && ismember(nodeNumber, nullMuls_2) ~= true
      nodeName = "M" + num2str(nodeNumber);
           
           node = nodeName + " = Node('mul', 2, 1, @basic_mul, {'"+nodeName+"_mul'}, {'num'});" + newline;
           
      filter = filter + node;
    end
  end
   end
filter = filter + newline;


  
  % Circuit node connection definings
  
   conn =  "Node.connect(MC, 1, SC, 1, 0);" + newline;
   filter = filter + conn;
            
   conn =  "Node.connect(S2, 1, SC, 2, 0);" + newline;
   filter = filter + conn;
      
   filter = filter + newline;
      
   nodeNumber = (i-1)*4 + j;
      
   %Here,composition of each summation node as multiplication and other
   %summation nodes. 
      
           
   node = "S" + num2str(nodeNumber);
      
      
          if i > 1
            sumNode1 = "S" + num2str((i - 2)*4 + 1);
            sumNode2 = "S" + num2str((i - 1)*4 + 1);
            tempNode_S1 = "S" + num2str((i - 2)*4 + 2);
            
            conn = "Node.connect("+sumNode1+", 1, "+tempNode_S1+", 1, 0);" + newline;
            filter = filter + conn;
            
            conn = "Node.connect("+sumNode2+", 1, "+tempNode_S1+", 2, 0);" + newline;
            filter = filter + conn;
          end
          
          
          if sections >2
              for i=3:sections
                     sumNode1 = "S" + num2str((i - 3)*4 + 1); %S1
                     sumNode2 = "S" + num2str((i - 2)*4 + 2); %S6
                     tempNode_S1 = "S" + num2str((i - 3)*4 + 2);%S2
            
            conn = "Node.connect("+sumNode1+", 1, "+tempNode_S1+", 1, 0);" + newline;
            filter = filter + conn;
            
            conn = "Node.connect("+sumNode2+", 1, "+tempNode_S1+", 2, 0);" + newline;
            filter = filter + conn;
              end
          end

          filter = filter + newline;
      
  for i = 1:sections
    for j = 1:3
      nodeNumber = (i-1)*4 + j;
      
      %Here,composition of each summation node as multiplication and other
      %summation nodes. 
      
           
      node = "S" + num2str(nodeNumber);

            
      if j == 1
        conn = "Node.connect(M"+num2str(6*(i-1)  +1)+", 1, "+node+", 1, 0);" + newline; %%%%
        filter = filter + conn;

        conn = "Node.connect(S"+num2str(nodeNumber + 2)+", 1, "+node+", 2, 1);" + newline;
        filter = filter + conn;
        
      elseif j == 3
        conn = "Node.connect(M"+num2str(6*(i-1) +3)+", 1, "+node+", 1, 0);" + newline;
        filter = filter + conn;

        conn = "Node.connect(M"+num2str(6*(i-1) +4)+", 1, "+node+", 2, 0);" + newline;
        filter = filter + conn;

        conn = "Node.connect(M"+num2str(6*i)+", 1, "+node+", 3, 1);" + newline;
        filter = filter + conn;
      end
      
      filter = filter + newline;
    end
  end
 
  % Multiplier Nodes Connection
  
   conn="Node.connect(x, 1, MC, 1, 0);" + newline;
        filter = filter + conn;
        
   conn= "Node.connect(C, 1, MC, 2, 0);" + newline;
        filter = filter + conn;
        
        filter =filter + newline;
        
  for i = 1:sections
    for j = 1:6
      
       nodeNumber = (i-1)*6 + j;
        
      %Here,composition of each multiplication node as coeff and other
      %summation nodes. 
      
      if j ~= 2 && j ~=5
        node = "M" + num2str(nodeNumber);
    
        
        if mod(nodeNumber, 2) == 0
          sumNode = "S" + num2str((i - 1)*4 + 1);
          
          conn = "Node.connect("+sumNode+", 1, "+node+", 1, 0);" + newline;
          filter = filter + conn;
          
        % a coefficient node is depend on section number,i.
          if j == 4
            a = "a_" + num2str(i - 1) + "_1";
          elseif j==6
            a = "a_" + num2str(i - 1) + "_2";
          end

          conn = "Node.connect("+a+", 1, "+node+", 2, 0);" + newline;
          filter = filter + conn;
        else

         % b coefficient node is depend on section number,i.
            if j == 1
              b = "b_" + num2str(i - 1) + "_0";
            elseif j == 3
              b = "b_" + num2str(i - 1) + "_1";
            end
            
            conn = "Node.connect("+b+", 1, "+node+", 2, 0);" + newline;
            filter = filter + conn;
            
            %Odd Multiplier nodes'  input is always X input node
          if mod(nodeNumber,2) ~=0
            conn = "Node.connect(x, 1, "+node+", 1, 0);" + newline;
            filter = filter + conn;
          end
        end
        
        filter = filter + newline;
      end
    end
  end
    
  %Output node is always last sections' first summation node
  outputNode = "SC" ;
  
  % When all the dataflow representation as nodes is done, finally the y output
  % buffer node is linked output node's output.
  filter = filter + "Node.connect("+outputNode+", 1, y, 1, 0);" + newline;
  % All input nodes ( x and coeffients a and b ) is generated below and
  % shown in inputNodes array.
  inputNodes = "inputNodes = [x,C, ";
  if mod(order,2) ==0
        for i = 0:sections - 1
            for j = 1:2
             inputNodes = inputNodes + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
 
        for i = 0:sections -1
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                inputNodes = inputNodes + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end
         inputNodes = inputNodes + "b_" + num2str(sections - 1) + "_" + num2str(1) + "];";
  else   
        for i = 0:sections - 2
            for j = 1:2
             inputNodes = inputNodes + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
   inputNodes = inputNodes + "a_" + num2str(sections -1) + "_" + num2str(1) + ", ";
 
        for i = 0:sections -2
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                inputNodes = inputNodes + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end
        inputNodes = inputNodes + "b_" + num2str(sections -1) + "_" + num2str(1);
        inputNodes = inputNodes + "];";
  end
   
  filter = filter + newline;
  filter = filter + inputNodes;
  
  filter = filter + newline;
  filter = filter + "outputNodes = y;";
  
  
  %All the generated multiplication and summation nodes are shown in array below. 
  circuitNodes = "circuitNodes = [";
  
   circuitNodes = circuitNodes + "SC" + ", ";
   circuitNodes = circuitNodes + "MC" + ", ";
  
  for i = 1:(sections-1)*4 +3
      
      if mod(i,2)~=0
      circuitNodes = circuitNodes + "S" + num2str(i) + ", ";     
      else
          for j = 2:sections
          if i == (j-2)*4+2
              circuitNodes = circuitNodes + "S" + num2str(i) + ", "; 
          end
          end
      end
  end
  
  nullMuls_1 = [];
  nullMuls_2 = [];
  for i = 0:sections
    nullMuls_1(end+1) = i * 6 + 2 ; % Missing M2, M8, M14 ... nodes
    nullMuls_2(end+1) = i * 6 + 5 ; % Missing M5, M11, M17 ... nodes
  end
  
  for i = 1:sections
    for j = 1:6   
      nodeNumber = (i-1)*6 + j;
          
      if ismember(nodeNumber, nullMuls_1) ~= true && ismember(nodeNumber, nullMuls_2) ~= true
        if i == sections && j==6
        else
          circuitNodes = circuitNodes + "M" + num2str(nodeNumber) + ",";
        end
      end
      
      if i== sections && j==6
        circuitNodes = circuitNodes + "M" + num2str(nodeNumber) + "];";
      end
    end
  end
     
  filter = filter + newline;
  filter = filter + circuitNodes; 
  filter = filter + newline ;
  
  filter = filter + "gen_coder_fcn('"+filterName+"', inputNodes, circuitNodes, outputNodes)" + newline;
  fileName = filterName + "Representation.m";
  
  file = fopen(fileName, 'wt');
  fprintf(file, '%s', filter);
  fclose(file);
  
  
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
  
  if mod(order,2)==0
        for i = 1:sections
            testBench = testBench + "b_" + num2str(i - 1) + "_0" + " = B" + num2str(i) + "(1, 1) ;" + newline;
            testBench = testBench + "b_" + num2str(i - 1) + "_1" + " = B" + num2str(i) + "(1, 2) ;" + newline;
        end
  
        for i = 1:sections
            testBench = testBench + "a_" + num2str(i - 1) + "_1" + " = A" + num2str(i) + "(1, 2) ;" + newline;
            testBench = testBench + "a_" + num2str(i - 1) + "_2" + " = A" + num2str(i) + "(1, 3) ;" + newline;
        end
  else
        for i = 1:sections -1
            testBench = testBench + "b_" + num2str(i - 1) + "_0" + " = B" + num2str(i) + "(1, 1) ;" + newline;
            testBench = testBench + "b_" + num2str(i - 1) + "_1" + " = B" + num2str(i) + "(1, 2) ;" + newline;
        end
            testBench = testBench + "b_" + num2str(sections - 1) + "_0" + " = B" + num2str(sections) + "(1, 1) ;" + newline;
        for i = 1:sections -1 
            testBench = testBench + "a_" + num2str(i - 1) + "_1" + " = A" + num2str(i) + "(1, 2) ;" + newline;
            testBench = testBench + "a_" + num2str(i - 1) + "_2" + " = A" + num2str(i) + "(1, 3) ;" + newline;
        end
         testBench = testBench + "a_" + num2str(sections - 1) + "_0" + " = A" + num2str(sections) + "(1, 2) ;" + newline;
  end

  testBench = testBench + newline;
  
  testBench = testBench + "y = zeros(size(x_in));" + newline;
  testBench = testBench + "for i = 1:length(x_in) " + newline;
  
  % Output y signal is generated here
  testBench = testBench + "y(i) = " + filterName + "(x_in(i), C,";
  
 if mod(order,2) ==0
        for i = 0:sections - 1
            for j = 1:2
             testBench = testBench + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
 
        for i = 0:sections -1
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                testBench = testBench + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end
  else   
        for i = 0:sections - 2
            for j = 1:2
             testBench = testBench + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
   testBench = testBench + "a_" + num2str(sections -1) + "_" + num2str(1) + ", ";
   
        for i = 0:sections -2
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                testBench = testBench + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end
        testBench = testBench + "b_" + num2str(sections -1) + "_" + num2str(1);
        testBench = testBench + "];";
  end
  
  testBench = testBench + "b_" + num2str(sections - 1) + "_" + num2str(1) + ");" + newline; 
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
 
  elseif mod(order,2) ~= 0 
  % Detection of number of sections and rows of SOS matrix are matching
  
  testBench =  "clear" +newline;
  
  testBench = testBench + "numerator = " + mat2str(numerator)+  ";" + newline;
  testBench = testBench + "denominator = " + mat2str(denominator)+  ";" + newline;

  testBench = testBench + "[R,p,C] = residuez(numerator,denominator)" +  ";"+newline;
  testBench = testBench + "C" + ";"+  newline;
    

    for i= 1: sections-1
     testBench = testBench + "[B" + num2str(i) + ",A" + num2str(i) + "]" +"=residuez(R( " + num2str(2*i-1) +":" + num2str(2*i)+"),p(" + num2str(2*i-1) +":" + num2str(2*i)+"),[])"+newline;
     testBench = testBench + "B" + num2str(i) + "=real (B"+ num2str(i)+");"+ newline;
     testBench = testBench + "A" + num2str(i) + "= real (A"+ num2str(i)+");"+ newline;
    end 
    
    testBench = testBench + "[B" + num2str(sections) + ",A" + num2str(sections) + "]" +"=residuez(R( " + num2str(2*sections-1) + "),p(" + num2str(2*sections-1)+"),[])"+newline;
    testBench = testBench + "B" + num2str(sections) + "=real (B"+ num2str(sections)+");"+ newline;
    testBench = testBench + "A" + num2str(sections) + "= real (A"+ num2str(sections)+");"+ newline;


 testBench = testBench + newline;
 
  % X input and y output buffer nodes are first created.
  filter = "x = Node('x', 0, 1, @basic_buffer, {'x'}, {'num'});" + newline;
  filter = filter + "C = Node('C', 0, 1, @basic_buffer, {'C'}, {'num'});" + newline;
  filter = filter + "y = Node('y', 1, 0, @basic_buffer, {'y'}, {'num'});" + newline;
  
  filter = filter + newline;
  
  %In dataflow graph, a coefficients are all negative, so the negative
  %buffer nodes are created here. In dataflow graph, a0 node is not shown
  %because of its value is 1 always. 
  
 for i = 0:sections - 2
    for j = 0:2
      if j ~= 0
        a = "a_" + num2str(i) + "_" + num2str(j);
        node = a + " = Node('"+a+"', 0, 1, @basic_buffer_negative, {'"+a+"'}, {'num'});" + newline;

        filter = filter + node;
      end
    end
 end 
 
  a = "a_" + num2str(sections -1) + "_" + num2str(1);
  node = a + " = Node('"+a+"', 0, 1, @basic_buffer_negative, {'"+a+"'}, {'num'});" + newline;
  filter = filter + node;
  filter = filter + newline;
  
  % Here, the b coefficients are generated same with a coeffs. The only
  % difference is b coefficients are started 0 to number of order. 
  for i = 0:sections - 1
    if i~=sections - 1
    for j = 0:1
      b = "b_" + num2str(i) + "_" + num2str(j);
      node = b + " = Node('"+b+"', 0, 1, @basic_buffer, {'"+b+"'}, {'num'});" + newline;

      filter = filter + node;
    end
    else 
   b = "b_" + num2str(sections-1) + "_" + num2str(0);
   node = b + " = Node('"+b+"', 0, 1, @basic_buffer, {'"+b+"'}, {'num'});" + newline;
    end
  end
  
   filter = filter + node;
  filter = filter + newline;
  
  %________________________________________________SUMMATION NODE CREATION ____________________________________________________%

 filter = filter + " SC = Node('add', 2, 1, @basic_add, {'SC_add'}, {'num'});"  + newline;
 
 
  nullSums_1 = [];
  nullSums_2= [];
  for i = 1:sections
    nullSums_1(end +1) = (i - 1) * 4 ;
    nullSums_2(end +1) = (i - 1) * 4 + 2 ;
  end

  
 %%%%%%
  for i = 1:sections
    for j=1:3
          nodeNumber = ((i-1)*4 + j) - 2;
          
    if ismember(nodeNumber, nullSums_1 ) ~= true && ismember(nodeNumber, nullSums_2 ) ~= true
      nodeName = "S" + num2str(nodeNumber); 
      
      
       if mod(nodeNumber,4) ==3 && nodeNumber >0
           node = nodeName + " = Node('add', 3, 1, @three_add, {'"+nodeName+"_add'}, {'num'});" + newline;
           
       elseif  mod(nodeNumber,4) == 1 || mod(nodeNumber,4) == 2
      node = nodeName + " = Node('add', 2, 1, @basic_add, {'"+nodeName+"_add'}, {'num'});" + newline;
       end
      filter = filter + node;
    end
    end
  end
  
  if sections >1
      for i = 2:sections
       nodeNumber = (i)*4 -6;
       nodeName = "S" + num2str(nodeNumber);
       node = nodeName + " = Node('add', 2, 1, @basic_add, {'"+nodeName+"_add'}, {'num'});" + newline;
       filter = filter + node;
      end
  end
  
filter = filter + newline;


 %%_______________________________________________MULTIPLIER NODE CREATION ___________________________________________________%%
  filter = filter + " MC = Node('add', 2, 1, @basic_mul, {'MC_mul'}, {'num'});";
  filter = filter + newline;
 
  
  nullMuls_1 = [];
  nullMuls_2 = [];
  for i = 0:sections
    nullMuls_1(end+1) = i * 6 + 2 ; % Missing M2,  M8, M14, M20 ... nodes
    nullMuls_2(end+1) = i * 6 + 5 ; % Missing M5, M11, M17, M23 ... nodes
  end
  
   for i = 1:sections
      for j=1:4
          nodeNumber = (i-1)*6 + j;
          nodeNumber2 = (i-2)*6 + 6;
    if ismember(nodeNumber, nullMuls_1) ~= true && ismember(nodeNumber, nullMuls_2) ~= true && nodeNumber ~=(sections-1)*6 +3
      nodeName = "M" + num2str(nodeNumber);
     
      
           node = nodeName + " = Node('mul', 2, 1, @basic_mul, {'"+nodeName+"_mul'}, {'num'});" + newline;
      filter = filter + node;    
    end
      end
      if nodeNumber2 >0
        nodeName2 = "M" + num2str(nodeNumber2); 
         node = nodeName2 + " = Node('mul', 2, 1, @basic_mul, {'"+nodeName2+"_mul'}, {'num'});" + newline;
      filter = filter + node;
      end
   end
filter = filter + newline;


  
  % Circuit node connection definings
  
  
   conn =  "Node.connect(MC, 1, SC, 1, 0);" + newline;
      filter = filter + conn;
            
   conn =  "Node.connect(S2, 1, SC, 2, 0);" + newline;
      filter = filter + conn;
      
      filter = filter + newline;
      
      
      
      nodeNumber = (i-1)*4 + j - 2;
      
      %Here,composition of each summation node as multiplication and other
      %summation nodes. 
      
           
      node = "S" + num2str(nodeNumber);
      
      
          if i > 1
            sumNode1 = "S" + num2str((i - 2)*4 + 1);
            sumNode2 = "S" + num2str((i - 1)*4 + 1);
            tempNode_S1 = "S" + num2str((i - 2)*4 + 2);
            
            conn = "Node.connect("+sumNode1+", 1, "+tempNode_S1+", 1, 0);" + newline;
            filter = filter + conn;
            
            conn = "Node.connect("+sumNode2+", 1, "+tempNode_S1+", 2, 0);" + newline;
            filter = filter + conn;
          end
          
          
          if sections >2
              for i=3:sections
                     sumNode1 = "S" + num2str((i - 3)*4 + 1); %S1
                     sumNode2 = "S" + num2str((i - 2)*4 + 2); %S6
                     tempNode_S1 = "S" + num2str((i - 3)*4 + 2);%S2
            
            conn = "Node.connect("+sumNode1+", 1, "+tempNode_S1+", 1, 0);" + newline;
            filter = filter + conn;
            
            conn = "Node.connect("+sumNode2+", 1, "+tempNode_S1+", 2, 0);" + newline;
            filter = filter + conn;
              end
          end        
          filter = filter + newline;
 
          
  for i = 1:sections
      
      if i ~= sections
            for j = 1:3
                nodeNumber = (i-1)*4 + j;
      
                %Here,composition of each summation node as multiplication and other
                 %summation nodes. 
      
           
                node = "S" + num2str(nodeNumber);     
            if j == 1
                 conn = "Node.connect(M"+num2str(6*(i-1)  +1)+", 1, "+node+", 1, 0);" + newline; %%%%
                 filter = filter + conn;

                conn = "Node.connect(S"+num2str(nodeNumber + 2)+", 1, "+node+", 2, 1);" + newline;
                filter = filter + conn;
        
            elseif j == 3
                conn = "Node.connect(M"+num2str(6*(i-1) +3)+", 1, "+node+", 1, 0);" + newline;
                filter = filter + conn;

                conn = "Node.connect(M"+num2str(6*(i-1) +4)+", 1, "+node+", 2, 0);" + newline;
                filter = filter + conn;

                conn = "Node.connect(M"+num2str(6*i)+", 1, "+node+", 3, 1);" + newline;
                filter = filter + conn;
            end
      
            filter = filter + newline;
            end
    
      elseif i==sections
      
            nodeNumber =  (i-1)*4 + 1;
            node = "S" + num2str(nodeNumber);
  
            conn = "Node.connect(M"+num2str(6*(i-1)  +1)+", 1, "+node+", 1, 0);" + newline; %%%%
            filter = filter + conn;

            conn = "Node.connect(M"+num2str(6*(i-1)  +4)+", 1, "+node+", 2, 1);" + newline;
            filter = filter + conn;
            filter = filter + newline;
      end
     
  end
   
  % Multiplier Nodes Connection
  
   conn="Node.connect(x, 1, MC, 1, 0);" + newline;
        filter = filter + conn;
        
   conn= "Node.connect(C, 1, MC, 2, 0);" + newline;
        filter = filter + conn;
        
        filter =filter + newline;
        
  for i = 1:sections
      if i~=sections 
      for j = 1:6
           
      nodeNumber = (i-1)*6 + j;
     
      %Here,composition of each multiplication node as coeff and other
      %summation nodes. 
      
      if j ~= 2 && j ~=5
        node = "M" + num2str(nodeNumber);
    
        
        if mod(nodeNumber, 2) == 0
          sumNode = "S" + num2str((i - 1)*4 + 1);
          
          conn = "Node.connect("+sumNode+", 1, "+node+", 1, 0);" + newline;
          filter = filter + conn;
          
        % a coefficient node is depend on section number,i.
          if j == 4
            a = "a_" + num2str(i - 1) + "_1";
          elseif j==6
            a = "a_" + num2str(i - 1) + "_2";
          end

          conn = "Node.connect("+a+", 1, "+node+", 2, 0);" + newline;
          filter = filter + conn;
        else

         % b coefficient node is depend on section number,i.
            if j == 1
              b = "b_" + num2str(i - 1) + "_0";
            elseif j == 3
              b = "b_" + num2str(i - 1) + "_1";
            end
            
            conn = "Node.connect("+b+", 1, "+node+", 2, 0);" + newline;
            filter = filter + conn;
            
            %Odd Multiplier nodes'  input is always X input node
          if mod(nodeNumber,2) ~=0
            conn = "Node.connect(x, 1, "+node+", 1, 0);" + newline;
            filter = filter + conn;
          end
        end
        
        filter = filter + newline;
      end
      end   
          
  elseif i==sections 
       nodeNumber1 = (sections-1)*6 + 1;
       nodeNumber2 = (sections-1)*6 + 4;
       
        node1 = "M" + num2str(nodeNumber1);
        node2 = "M" + num2str(nodeNumber2);
        
        if mod(nodeNumber2, 2) == 0
          sumNode = "S" + num2str((sections - 1)*4 + 1);
          
          conn = "Node.connect("+sumNode+", 1, "+node2+", 1, 0);" + newline;
          filter = filter + conn;
       
          % a coefficient node is depend on section number,i.          
          a = "a_" + num2str(sections - 1) + "_1";

          conn = "Node.connect("+a+", 1, "+node2+", 2, 0);" + newline;
          filter = filter + conn;
        
          filter = filter + newline;
        end
        if mod(nodeNumber1, 2) ~= 0
         % b coefficient node is depend on section number,i.
          
            b = "b_" + num2str(sections - 1) + "_0";
            
            conn = "Node.connect("+b+", 1, "+node1+", 2, 0);" + newline;
            filter = filter + conn;
            
            %Odd Multiplier nodes'  input is always X input node
            conn = "Node.connect(x, 1, "+node1+", 1, 0);" + newline;
            filter = filter + conn;
          
        end        
        filter = filter + newline;
      end  
   end
 
  
  %Output node is always last sections' first summation node
  outputNode = "SC" ;
  
  % When all the dataflow representation as nodes is done, finally the y output
  % buffer node is linked output node's output.
  filter = filter + "Node.connect("+outputNode+", 1, y, 1, 0);" + newline;
  % All input nodes ( x and coeffients a and b ) is generated below and
  % shown in inputNodes array.
  inputNodes = "inputNodes = [x,C, ";
  if mod(order,2) ==0
        for i = 0:sections - 1
            for j = 1:2
             inputNodes = inputNodes + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
  
        for i = 0:sections -1
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                inputNodes = inputNodes + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end
         inputNodes = inputNodes + "b_" + num2str(sections - 1) + "_" + num2str(1) + "];";
  else   
        for i = 0:sections - 2
            for j = 1:2
             inputNodes = inputNodes + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
   inputNodes = inputNodes + "a_" + num2str(sections -1) + "_" + num2str(1) + ", ";
 
        for i = 0:sections -2
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                inputNodes = inputNodes + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end
        inputNodes = inputNodes + "b_" + num2str(sections -1) + "_" + num2str(0);
        inputNodes = inputNodes + "];";
  end
  
  
  filter = filter + newline;
  filter = filter + inputNodes;
  
  filter = filter + newline;
  filter = filter + "outputNodes = y;";
  
  
  %All the generated multiplication and summation nodes are shown in array below. 
  circuitNodes = "circuitNodes = [";
  
   circuitNodes = circuitNodes + "SC" + ", ";
   circuitNodes = circuitNodes + "MC" + ", ";
  
  for i = 1:(sections-1)*4 +3
   if i ~=   (sections-1)*4 +3
      if mod(i,2)~=0
      circuitNodes = circuitNodes + "S" + num2str(i) + ", ";     
      else
          for j = 2:sections
          if i == (j-2)*4+2
              circuitNodes = circuitNodes + "S" + num2str(i) + ", "; 
          end
          end
      end
   end
  end
  
    
  nullMuls_1 = [];
  nullMuls_2 = [];
  for i = 0:sections
    nullMuls_1(end+1) = i * 6 + 2 ; % Missing M2, M8, M14 ... nodes
    nullMuls_2(end+1) = i * 6 + 5 ; % Missing M5, M11, M17 ... nodes
  end
  
  for i = 1:sections
    for j = 1:6   
      nodeNumber = (i-1)*6 + j;
          
      if ismember(nodeNumber, nullMuls_1) ~= true && ismember(nodeNumber, nullMuls_2) ~= true &&  nodeNumber ~= (sections-1)*6 + 6    &&  nodeNumber ~= (sections-1)*6 + 4  &&  nodeNumber ~= (sections-1)*6 + 3  
          circuitNodes = circuitNodes + "M" + num2str(nodeNumber) + ",";
      
      elseif i== sections && j==4
        circuitNodes = circuitNodes + "M" + num2str(nodeNumber) + "];";
      end
    end
  end
    
 
  
  filter = filter + newline;
  filter = filter + circuitNodes;
  
  filter = filter + newline ;
 
  
  filter = filter + "gen_coder_fcn('"+filterName+"', inputNodes, circuitNodes, outputNodes)" + newline;
  
  fileName = filterName + "Representation.m";
  
  file = fopen(fileName, 'wt');
  fprintf(file, '%s', filter);
  fclose(file);
  
  
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
  
  if mod(order,2)==0
        for i = 1:sections
            testBench = testBench + "b_" + num2str(i - 1) + "_0" + " = B" + num2str(i) + "(1, 1) ;" + newline;
            testBench = testBench + "b_" + num2str(i - 1) + "_1" + " = B" + num2str(i) + "(1, 2) ;" + newline;
        end
  
        for i = 1:sections
            testBench = testBench + "a_" + num2str(i - 1) + "_1" + " = A" + num2str(i) + "(1, 2) ;" + newline;
            testBench = testBench + "a_" + num2str(i - 1) + "_2" + " = A" + num2str(i) + "(1, 3) ;" + newline;
        end
  else
        for i = 1:sections -1
            testBench = testBench + "b_" + num2str(i - 1) + "_0" + " = B" + num2str(i) + "(1, 1) ;" + newline;
            testBench = testBench + "b_" + num2str(i - 1) + "_1" + " = B" + num2str(i) + "(1, 2) ;" + newline;
        end
            testBench = testBench + "b_" + num2str(sections - 1) + "_0" + " = B" + num2str(sections) + "(1, 1) ;" + newline;
        for i = 1:sections -1 
            testBench = testBench + "a_" + num2str(i - 1) + "_1" + " = A" + num2str(i) + "(1, 2) ;" + newline;
            testBench = testBench + "a_" + num2str(i - 1) + "_2" + " = A" + num2str(i) + "(1, 3) ;" + newline;
        end
         testBench = testBench + "a_" + num2str(sections - 1) + "_1" + " = A" + num2str(sections) + "(1, 2) ;" + newline;
  end

  testBench = testBench + newline;
  
  testBench = testBench + "y = zeros(size(x_in));" + newline;
  testBench = testBench + "for i = 1:length(x_in) " + newline;
  
  % Output y signal is generated here
  testBench = testBench + "y(i) = " + filterName + "(x_in(i), C,";
  
 if mod(order,2) ==0
        for i = 0:sections - 1
            for j = 1:2
             testBench = testBench + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
  
  
        for i = 0:sections -1
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                testBench = testBench + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end
      
  else   
        for i = 0:sections - 2
            for j = 1:2
             testBench = testBench + "a_" + num2str(i) + "_" + num2str(j) + ", ";
            end 
         end
   testBench = testBench + "a_" + num2str(sections -1) + "_" + num2str(1) + ", ";

        for i = 0:sections -2
            for j = 0:1
                if i ~= sections - 1 || j ~= 1
                testBench = testBench + "b_" + num2str(i) + "_" + num2str(j) + ", ";
                end
            end 
        end

  end
  
  testBench = testBench + "b_" + num2str(sections - 1) + "_" + num2str(0) + ");" + newline;
  
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
end