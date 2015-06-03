A = InitializeAttractor(P);
A = TrainAttractor(A);
A.D.testingset = double(rand(100, P.lengthof_patterns) <= P.sparseness);
A.D.testingset_I = A.D.testingset;
A.D.testingset_O = A.D.testingset;
A = TestAttractor(A);

C = NaN(size(A.T.outputs,1),2);
for i = 1:size(A.T.outputs,1)
    corr_matrix = corrcoef(A.T.outputs(i,:), A.D.testingset(i,:));
    correlation = corr_matrix(1,2);
    C(i,1) = correlation;
    
    corr_matrix = corrcoef(A.T.outputs(i,:), A.D.trainingset);
    correlation = corr_matrix(1,2);
    C(i,2) = correlation;
end

boxplot(C, 'labels', {'With input pattern'; 'With training pattern'})
%set(gca, 'YLim', [0,1])
cim = S.pop_ID;
title(cim)
ylabel('Correlation')
print('-dpng', [folder, cim, '.png'])
close