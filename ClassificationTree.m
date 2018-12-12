load fisheriris.mat

GT= unique(species);
GT = strcmp(species,'setosa');

test = [GT meas(:,1) meas(:,2) meas(:,3) meas(:,4)];

var2 = meas(:,2);

row0 = find(GT ==0);
row1 = find(GT ==1);

mu0 = mean(var2(row0));
mu1 = mean(var2(row1));

var0= var(var2(row0));
var1= var(var2(row1));

%conditinal likelihoods
p0 = mvnpdf(var2,mu0,var0);
p1 = mvnpdf(var2,mu1,var1);

t = 3.1;

d1 = (var2-t)>=0;

node2 = meas(find(d1==1));
node3 = meas(find(d1==0));

GTn2 = GT(find(d1==1));
GTn3 = GT(find(d1==0));

pn2_1 = sum(GTn2)/length(GTn2);
pn2_0 = 1- pn2_1;

gini_n2 = 1-(pn2_1^2 + pn2_0^2)

pn3_1 = sum(GTn3)/length(GTn3);
pn3_0 = 1- pn3_1;

gini_n3 = 1-(pn3_1^2 + pn3_0^2)

p_org1 = sum(GT)/length(GT);
p_org0 = 1-p_org1;
gini_org = 1-(p_org1^2 + p_org0^2);




