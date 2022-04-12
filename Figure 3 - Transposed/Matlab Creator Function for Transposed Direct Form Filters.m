function DFTfilterCreator(order, filterName, nominator, denominator)
  n = order+1 ;
  
   Coeff_Matrix_b= (nominator);
   Coeff_Matrix_a= (denominator);

  
  filter = "x = Node('x', 0, 1, @basic_buffer, {'x'}, {'num'});" + newline;
  filter = filter + "y = Node('y', 1, 0, @basic_buffer, {'y'}, {'num'});" + newline;
  
  filter = filter + newline;
  
  for i = 1:n - 1
    a = "a" + num2str(i);
    node = a + " = Node('"+a+"', 0, 1, @basic_buffer_negative, {'"+a+"'}, {'num'});" + newline;
    
    filter = filter + node;
  end
  
  filter = filter + newline;
  
  for i = 0:n - 1
    b = "b" + num2str(i);
    node = b + " = Node('"+b+"', 0, 1, @basic_buffer, {'"+b+"'}, {'num'});" + newline;
    
    filter = filter + node;
  end
  
  filter = filter + newline;
  
  for i = 1:n
    nodeName = "S" + num2str(i);
      
    if i == n || i == 1
      node = nodeName + " = Node('add', 2, 1, @basic_add, {'"+nodeName+"_add'}, {'num'});" + newline;
      filter = filter + node;
    else
      node = nodeName + " = Node('add', 3, 1, @three_add, {'"+nodeName+"_add'}, {'num'});" + newline;
      filter = filter + node;
    end
  end
  
  filter = filter + newline;
  
  for i = 1:2*n
    if i ~= 2
      nodeName = "M" + num2str(i);

      node = nodeName + " = Node('mul', 2, 1, @basic_mul, {'"+nodeName+"_mul'}, {'num'});" + newline;
      filter = filter + node;
    end
  end
  
  filter = filter + newline;
  
  for i = 1:n
    if i == n
      node = "S" + num2str(n);
      
      conn = "Node.connect(M"+num2str(2*n - 1)+", 1, "+node+", 1, 0);" + newline;
      filter = filter + conn;
      
      conn = "Node.connect(M"+num2str(2*n)+", 1, "+node+", 2, 0);" + newline;
      filter = filter + conn;
    elseif i == 1
      conn = "Node.connect(M1, 1, S1, 1, 0);" + newline;
      filter = filter + conn;
      
      conn = "Node.connect(S2, 1, S1, 2, 1);" + newline;
      filter = filter + conn;
    else
      node = "S" + num2str(i);
      
      conn = "Node.connect(M"+num2str(2*i - 1)+", 1, "+node+", 1, 0);" + newline;
      filter = filter + conn;
      
      conn = "Node.connect(M"+num2str(2*i)+", 1, "+node+", 2, 0);" + newline;
      filter = filter + conn;
      
      conn = "Node.connect(S"+num2str(i + 1)+", 1, "+node+", 3, 1);" + newline;
      filter = filter + conn;
    end

    filter = filter + newline;
  end
  
  for i = 1:2*n
    if i == 2
    elseif mod(i,2) == 0
      a = num2str(i/2 - 1);
      
      node = "M" + num2str(i);
      
      conn = "Node.connect(S1, 1, "+node+", 1, 0);" + newline;
      filter = filter + conn;
      
      conn = "Node.connect(a"+a+", 1, "+node+", 2, 0);" + newline;
      filter = filter + conn;
      
      filter = filter + newline;
    else
      b = num2str((i - 1) / 2);
      
      node = "M" + num2str(i);
      
      conn = "Node.connect(x, 1, "+node+", 1, 0);" + newline;
      filter = filter + conn;
      
      conn = "Node.connect(b"+b+", 1, "+node+", 2, 0);" + newline;
      filter = filter + conn;
      
      filter = filter + newline;
    end
  end
  
  filter = filter + "Node.connect(S1, 1, y, 1, 0);" + newline;
  
  inputNodes = "inputNodes = [x, ";
  
  for i = 1:n - 1
      inputNodes = inputNodes + "a" + num2str(i) + ", ";
  end
  
  for i = 0:n - 2
      inputNodes = inputNodes + "b" + num2str(i) + ", ";
  end
  
  inputNodes = inputNodes + "b" + num2str(n - 1) + "];";
  
  filter = filter + newline;
  filter = filter + inputNodes;
  
  filter = filter + newline;
  filter = filter + "outputNodes = y;";
  
  circuitNodes = "circuitNodes = [";
  
  for i = 1:n
      circuitNodes = circuitNodes + "S" + num2str(i) + ", ";
  end
  
  for i = 1:2*n - 1
    if i ~= 2
      circuitNodes = circuitNodes + "M" + num2str(i) + ", ";
    end
  end
  
  circuitNodes = circuitNodes + "M" + num2str(2*n) + "];";
  
  filter = filter + newline;
  filter = filter + circuitNodes;
  
  filter = filter + newline + newline;
  
  filter = filter + "gen_coder_fcn('"+filterName+"', inputNodes, circuitNodes, outputNodes)";
  
  fileName = filterName + "Representation.m";
  
  file = fopen(fileName, 'wt');
  fprintf(file, '%s', filter);
  fclose(file);
    
   testBench = "clear" + newline;
   testBench = testBench + " q = quantizer('fixed','floor','saturate',[8 6]);";
   
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
      
    for i = 1: n     
   testBench = testBench + "b" + num2str(i-1) + " = " + num2str(Coeff_Matrix_b(i)) + ";" + newline;      
    end
   
    
    for i = 1: n-1
   testBench = testBench + "a" + num2str(i) + " = " + num2str(Coeff_Matrix_a(i+1)) + ";" + newline;      
    end

   testBench = testBench + newline;

  testBench = testBench + "y = zeros(size(x_in));" + newline;
  testBench = testBench + "for i = 1:length(x_in) " + newline;
  
  % Output y signal is generated here
  testBench = testBench + "y(i) = " + filterName + "(x_in(i), ";
  
  for i = 1:n - 1
      testBench = testBench + "a" + num2str(i) + ", " ;
  end
  
  for i = 0:n - 1
      if i ~= n - 1
      testBench = testBench + "b" + num2str(i) + ", " ;
      end
  end
  
  testBench = testBench + "b" + num2str(n-1) + ");" + newline;
  
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