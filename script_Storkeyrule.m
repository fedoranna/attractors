%%
clear all
A.P.nbof_neurons = 5;

A.D.trainingset = [1:5;6:10];

A.D.trainingset = double(rand(2, 5) <= 0.5);
A.D.trainingset = sign(A.D.trainingset-0.1);

A.W.state = rand(5,5);
A.W.state(1,2) = 0;
diagonal = 1 : A.P.nbof_neurons+1 : A.P.nbof_neurons*A.P.nbof_neurons;
A.W.state(diagonal)=0;

%A.D.trainingset = [1:5];
% A.W.state = ones(5,5);

%% No1

inc1_mod = zeros(size(A.W.state));
inc1 = zeros(size(A.W.state));

h = A.D.trainingset * A.W.state;
for p = 1:size(A.D.trainingset, 1)
    pattern = A.D.trainingset(p,:);
    for i = 1:A.P.nbof_neurons;
        for j = 1:A.P.nbof_neurons;
%             pattern_mod = pattern;
%             pattern_mod(i) = 0;
%             pattern_mod(j) = 0;
%             h_mod = pattern_mod * A.W.state;
%             inc1_mod(i,j) = inc1_mod(i,j) + 1/A.P.nbof_neurons*(pattern(i)*pattern(j) - pattern(i)*h_mod(j) - pattern(j)*h_mod(i));            inc1_mod(i,j) = inc1_mod(i,j) + 1/A.P.nbof_neurons*(pattern(i)*pattern(j) - pattern(i)*h_mod(j) - pattern(j)*h_mod(i));
%             
%             h_i = 0;
%             h_j = 0;
%             for k = 1:A.P.nbof_neurons
%                 h_i = h_i + pattern(k)*A.W.state(k,i);
%                 h_j = h_j + pattern(k)*A.W.state(k,i);
%             end
            %inc1(i,j) = inc1(i,j) + 1/A.P.nbof_neurons*(pattern(i)*pattern(j) - pattern(i)*h_j - pattern(j)*h_i);
            
            inc1(i,j) = inc1(i,j) + 1/A.P.nbof_neurons*(pattern(i)*pattern(j) - pattern(i)*h(p,j) - pattern(j)*h(p,i));

        end
    end
end
inc1_mod;
inc1

%% No2

h = A.D.trainingset * A.W.state;
inc2 = zeros(size(A.W.state));
%inc2_mod = zeros(size(A.W.state));
for i = 1:A.P.nbof_neurons;
    for j = 1:A.P.nbof_neurons;
%         pattern_mod = A.D.trainingset;
%         pattern_mod(:,i) = 0;
%         pattern_mod(:,j) = 0;
%         h_mod = pattern_mod * A.W.state;                
%        inc2_mod(i,j) = 1/A.P.nbof_neurons*(A.D.trainingset(:,i)'*A.D.trainingset(:,j) - A.D.trainingset(:,i)'*h_mod(:,j) - A.D.trainingset(:,j)'*h_mod(:,i));
        inc2(i,j) = 1/A.P.nbof_neurons*(A.D.trainingset(:,i)'*A.D.trainingset(:,j) - A.D.trainingset(:,i)'*h(:,j) - A.D.trainingset(:,j)'*h(:,i));
    end
end
inc2
%inc2_mod;

%% No4

inc4_mod = zeros(size(A.W.state));
inc_decr = NaN(size(A.W.state));
for i = 1:A.P.nbof_neurons;
    for j = 1:A.P.nbof_neurons;
        P_mod_ij = A.D.trainingset;
        P_mod_ij(:,i) =0;
        P_mod_ij(:,j) =0;
        h_mod_ij = P_mod_ij * A.W.state;
        inc4_mod(i,j) = 1/A.P.nbof_neurons * (sum(A.D.trainingset(:,i).*A.D.trainingset(:,j)) - sum(A.D.trainingset(:,i).*h_mod_ij(:,j)) - sum(A.D.trainingset(:,j).*h_mod_ij(:,i)));
    end
end
inc4_mod;

%% No3

h = A.D.trainingset * A.W.state;
inc3 = 1/A.P.nbof_neurons * (A.D.trainingset'*A.D.trainingset - A.D.trainingset'*h - h'*A.D.trainingset);
inc3

% decr_h = zeros(size(A.D.trainingset));
% inc3_mod = zeros(size(A.W.state));
% for i = 1:A.P.nbof_neurons;
%     for j = 1:A.P.nbof_neurons;
%         decr_h = zeros(size(A.D.trainingset));
%         decr_h(:,i) = A.D.trainingset(:,j)*A.W.state(j,i) + A.D.trainingset(:,i)*A.W.state(i,i);
%         decr_h(:,j) = A.D.trainingset(:,i)*A.W.state(i,j) + A.D.trainingset(:,j)*A.W.state(j,j);
%         if i==j
%             decr_h(:,i) = decr_h(:,i)/2;
%         end
%         
%         h_mod = h - decr_h;
%         
%         B = A.D.trainingset(:,i)'* (h(:,j) - decr_h(:,j));
%         C = A.D.trainingset(:,j)'* (h(:,i) - decr_h(:,i));   
%         inc3_mod(i,j) = 1/A.P.nbof_neurons*(A.D.trainingset(:,i)'*A.D.trainingset(:,j) - B - C);
%     
%     end
% end





























