clear;clc;close all;
%% load Data;
data=xlsread('SVMѵ������-��.xls','������ϸ����','B3:B6602');
% 6600/24=275��
%��һ��24��������Ϊ���� Ԥ����һ���24������
for i=1:274
    X(i,:)=data((i-1)*24+1:i*24);
    Y(i,:)=data(i*24+1:(i+1)*24);
end
% ��һ��
[inputn,inputps]=mapminmax(X',0,1);
X=inputn';
[outputn,outputps]=mapminmax(Y',0,1);
Y=outputn';

%% �������ݼ�
rand('state',0)
r=randperm(size(X,1));
ntrain =size(X,1)*0.5 ;          % 50%��Ϊѵ���� ʣ��Ϊ���Լ�
Xtrain = X(r(1:ntrain),:);       % ѵ��������
Ytrain = Y(r(1:ntrain),:);       % ѵ�������
Xtest  = X(r(ntrain+1:end),:);   % ���Լ�����
Ytest  = Y(r(ntrain+1:end),:);   % ���Լ����

%% û�Ż���24���msvm
% ��������ͷ�������˲���
C    = 1000*rand;%�ͷ�����
par  = 1000*rand;%�˲���
ker  = 'rbf';
tol  = 1e-20;
epsi = 1;
% ѵ��
[Beta,NSV,Ktrain,i1] = msvr(Xtrain,Ytrain,ker,C,epsi,par,tol);
% ����
Ktest = kernelmatrix(ker,Xtest',Xtrain',par);
Ypredtest = Ktest*Beta;

% ����������
mse_test=sum(sum((Ypredtest-Ytest).^2))/(size(Ytest,1)*size(Ytest,2))

% ����һ��
yuce=mapminmax('reverse',Ypredtest',outputps);yuce=yuce';
zhenshi=mapminmax('reverse',Ytest',outputps);zhenshi=zhenshi';
%% ����Ⱥ�Ż������֧��������
[y ,trace]=psoformsvm(Xtrain,Ytrain,Xtest,Ytest);
%% ���õõ����ųͷ�������˲�������ѵ��һ��֧��������
C    = y(1);%�ͷ�����
par  = y(2);%�˲���
[Beta,NSV,Ktrain,i1] = msvr(Xtrain,Ytrain,ker,C,epsi,par,tol);
Ktest = kernelmatrix(ker,Xtest',Xtrain',par);
Ypredtest_pso = Ktest*Beta;
% ���
pso_mse_test=sum(sum((Ypredtest_pso-Ytest).^2))/(size(Ytest,1)*size(Ytest,2))
% ����һ��
yuce_pso=mapminmax('reverse',Ypredtest_pso',outputps);yuce_pso=yuce_pso';

%% ��ͼ
figure
plot(trace)
xlabel('��������')
ylabel('��Ӧ��ֵ')
title('psosvm��Ӧ�����ߣ�Ѱ�����ߣ�')
%�������Լ������һ������ݣ�������������ֵģ���˲����Ǵ���12�·����һ�죩

figure;hold on;grid on;axis([0 23 -inf inf]);t=0:1:23;
plot(t,yuce(end,:),'-r*')
plot(t,zhenshi(end,:),'-ks')
legend('Ԥ��ֵ','��ʵֵ')
title('�Ż�ǰ');xlabel('ʱ��');ylabel('����')

figure;hold on;grid on;axis([0 23 -inf inf]);t=0:1:23;
plot(t,yuce_pso(end,:),'-r*')
plot(t,zhenshi(end,:),'-ks')
legend('Ԥ��ֵ','��ʵֵ')
title('�Ż���');xlabel('ʱ��');ylabel('����')

%�ϲ���һ��ͼ
figure;hold on;grid on;t=0:1:23;axis([0 23 -inf inf])
plot(t,yuce(end,:),'-bp')
plot(t,yuce_pso(end,:),'-r*')
plot(t,zhenshi(end,:),'-ks')
legend('svmԤ��ֵ','psosvmԤ��ֵ','��ʵֵ')
title('�Ż�ǰ��');xlabel('ʱ��');ylabel('����')

save data_svm_psosvm 