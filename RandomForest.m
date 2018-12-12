%% Load Dataset

function call_random_forest()

data_matrix= importdata('wdbc.mat')
icol= size(data_matrix,2)
data_predictor = data_matrix(:,1:icol-1); % predictors matrixdata_predictor
label = data_matrix(:,end); % last column is 'B' for benign, 'M' for malignant

BaggedEnsemble = generic_random_forests(data_predictor, label, 300, 'classification')

predict(BaggedEnsemble, [857155	12.05	14.63	78.04	449.3	0.1031	0.09092	0.06592	0.02749	0.1675	0.06043	0.2636	0.7294	1.848	19.87	0.005488	0.01427	0.02322	0.00566	0.01428	0.002422	13.76	20.7	89.88	582.6	0.1494	0.2156	0.305	0.06548	0.2747	0.08301	])


%% RandomForest
function BaggedEnsemble = generic_random_forests(X,Y,iNumBags,str_method)
% find optimal leaf size
leaf = [5 10 20 50 100];
col = 'rbcmy';

% Figure1
figure
for i=1:length(leaf)
    % The initial random seed is set as 50,
    RF = TreeBagger(50,X,Y,'Method',str_method,'OOBPred','On',...
            'MinLeafSize',leaf(i));
   
    
    %RF.DefaultYfit= ''; 
    %The method trains ensembles with few trees on observations that are in bag for all trees.
    %For such observations, it is impossible to compute the true out-of-bag prediction, 
    %and TreeBagger returns the most probable class for classification and the sample mean for regression.   
    plot(oobError(RF),col(i))
    hold on
end

xlabel 'Number of Grown Trees'
ylabel 'Mean Squared Error'
legend({'5' '10' '20' '50' '100'},'Location','NorthEast')
hold off

% Optimizing Parameters Automatically 
Mdl = fitctree(X,Y,'OptimizeHyperparameters','auto')
% We 
min_leaf_size = 5 % TODO: to be computed automatically from above, now hard-coded

BaggedEnsemble = TreeBagger(iNumBags,X,Y,'OOBPred','On','Method',str_method)

%% Interpretation of output
%% Figure 2

%% Plot Out-Of-Bag(OOB) Prediction Error
oobErrorBaggedEnsemble = oobError(BaggedEnsemble);
figID = figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-Of-Bag(OOB)Classification Error';
print(figID, '-dpdf', sprintf('randomforest_errorplot_%s.pdf', date)); %save figure in pdf format

oobPredict(BaggedEnsemble)

%% Figure 5
% View Trees
view(BaggedEnsemble.Trees{1}) % text description
view(BaggedEnsemble.Trees{1},'mode','graph') % graphic description

% Estimate Feature Importance
RF = TreeBagger(iNumBags,X,Y,'Method',str_method,'OOBVarImp','On',...
    'MinLeafSize',min_leaf_size);
%% Figure3
figure
plot(oobError(RF))
xlabel 'Number of Grown Trees'
ylabel 'Out-of-Bag Mean Squared Error'

%% Figure4

figure
bar(RF.OOBPermutedVarDeltaError)
xlabel 'Feature Number'
ylabel 'Out-of-Bag Feature Importance'
idxvar = find(RF.OOBPermutedVarDeltaError>0.7)

%% Figure 6
figure
plot(oobMeanMargin(RF));
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Mean Classification Margin')
%% Classification Error
oobErr = oobError(RF, 'Mode','ensemble');
oobErr
















% %%Additional
% RF = fillProximities(RF);
% figure
% histogram(RF.OutlierMeasure)
% xlabel('Outlier Measure')
% ylabel('Number of Observations')
% extremeOutliers = RF.Y(RF.OutlierMeasure>40)
% percentGood = 100*sum(strcmp(extremeOutliers,'g'))/numel(extremeOutliers)
% gPosition = find(strcmp('g',RF.ClassNames))
% figure
% [s,e] = mdsProx(RF,'Colors','rb');
% xlabel('First Scaled Coordinate')
% ylabel('Second Scaled Coordinate')
% figure
% bar(e(1:20))
% xlabel('Scaled Coordinate Index')
% ylabel('Eigenvalue')
% 
% [Yfit,Sfit] = oobPredict(RF);
% 
% [fpr,tpr] = perfcurve(RF.Y,Sfit(:,gPosition),'g');
% figure
% plot(fpr,tpr)
% xlabel('False Positive Rate')
% ylabel('True Positive Rate')
% 
% [fpr,accu,thre] = perfcurve(RF.Y,Sfit(:,gPosition),'g','YCrit','Accu');
% figure(20)
% plot(thre,accu)
% xlabel('Threshold for ''good'' Returns')
% ylabel('Classification Accuracy')
% 
% accu(abs(thre-0.5)<eps)
% 
% [maxaccu,iaccu] = max(accu)
% 
% thre(iaccu)

    




