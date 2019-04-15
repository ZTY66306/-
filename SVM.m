
%% I. ��ջ�������
clear all
clc
%% II. ��������
attributes=xlsread('C:\Users\ZTY0918\Desktop\Ԫ��.xlsx')';
%attributes=xlsread('C:\Users\ZTY0918\Desktop\C��Ԥ������.xlsx')';
strength=xlsread('C:\Users\ZTY0918\Desktop\C������.xlsx')';
Max1=0;
R2=0;
avg1=0;
sum1=0;
for o=1:20
    %%
    % 1. �������ѵ�����Ͳ��Լ�
    n = randperm(size(attributes,2));

    %%
    % 2. ѵ�����D�D800������
    p_train = attributes(:,n(1:800))';
    t_train = strength(:,n(1:800))';

    %%
    % 3. ���Լ��D�D162������
    p_test = attributes(:,n(801:end))';
    t_test = strength(:,n(801:end))';

    %% III. ���ݹ�һ��
    %%
    % 1. ѵ����
    [pn_train,inputps] = mapminmax(p_train');
    pn_train = pn_train';
    pn_test = mapminmax('apply',p_test',inputps);
    pn_test = pn_test';

    %%
    % 2. ���Լ�
    [tn_train,outputps] = mapminmax(t_train');
    tn_train = tn_train';
    tn_test = mapminmax('apply',t_test',outputps);
    tn_test = tn_test';

    

    %% VII. BP������
    %%
    % 1. ����ת��
    pn_train = pn_train';
    tn_train = tn_train';
    pn_test = pn_test';
    tn_test = tn_test';

    %[p1,minp,maxp,t1,mint,maxt]=premnmx(pn_train,tn_train);
    %%
    % 2. ����BP������
    %net=newff(minmax(pn_train),[16,10,2],{'tansig','tansig','purelin'},'trainlm');
    net = newff(pn_train,tn_train,10);

    %%
    % 3. ����ѵ������
    net.trainParam.epochs = 1000;
    net.trainParam.goal = 1e-3;
    net.trainParam.show = 10;
    net.trainParam.lr = 0.1;

    %%
    % 4. ѵ������
    %[net,tr]=train(net,p1,t1);
    net = train(net,pn_train,tn_train);

    %%
    % 5. �������
    tn_sim = sim(net,pn_test);

    %%
    % 6. �������
    E = mse(tn_sim - tn_test);

    %%
    % 7. ����ϵ��
    N = size(t_test,1);
    R2=(N.*sum(tn_sim.*tn_test)-sum(tn_sim).*sum(tn_test)).^2/((N.*sum((tn_sim).^2)-(sum(tn_sim)).^2).*(N.*sum((tn_test).^2)-(sum(tn_test)).^2)); 
 if (R2>Max1)
        Max1=R2;
    end
    sum1=sum1+R2;
%     if (R2>0.9)
%         break;
%     end
end
 avg1=sum1/20
%%
% 8. ����һ��
t_sim = mapminmax('reverse',tn_sim,outputps);
 
%%
% 9. ��ͼ
figure(3)
plot(1:length(t_test),t_test,'r-*',1:length(t_test),t_sim,'b:o')
grid on
legend('��ʵֵ','Ԥ��ֵ')
xlabel('�������')
ylabel('��ѹǿ��')
string_3 = {'���Լ�Ԥ�����Ա�(BP������)';
           ['mse = ' num2str(E) ' R^2 = ' num2str(R2)]};
title(string_3)