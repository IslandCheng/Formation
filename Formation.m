clc
clear
%%
A=[ 0 1 1 0;
    1 0 1 0;
    1 1 0 1;
    0 0 1 0];
L=diag(sum(A,2))-A;

%% 初始化
N=4;
X=50*ones(N,N);
X(1,1)=-50; X(2,2)=50; X(3,3)=-50; X(4,4)=50;
Y=50*ones(N,N);
Y(1,1)=50; Y(2,2)=50; Y(3,3)=-50; Y(4,4)=-50;
X_nos=zeros(N,N);
T_end=30000;

NE=[-15.8499999999997 7.15000000000026;
13.6500000000003 6.65000000000026;
-20.1999999999996 -22.1999999999996;
6.40000000000027 -15.5999999999997];

%% 循环
for k=1:T_end
    c_k=0.8/(log(sqrt(k)+1)+8+0.7*k^(0.5));
    %c_k=0.08;
    c(k)=c_k;
    %c_k=0.05;
    
    alpha_k=0.2/(log(sqrt(k)+1)+5+0.7*k^(0.5));
    %alpha_k=0.01;
    alpha(k)=alpha_k;

    Omega=normrnd(0,3,N,N);

%     Omega(Omega>0)=5;
%         Omega(Omega<0)=-5;

    X_nos=X+Omega;
    Y_nos=Y+Omega;

    for i=1:N
        x=diag(X);
        y=diag(Y);

        x_i=x(i);
        y_i=y(i);

        consen_x=0;
        consen_y=0;

        PI=normrnd(0,1,N,N);
        PI(PI>0)=1;
        PI(PI<0)=-1;
        
        for j=1:N
            consen_x=consen_x+A(i,j)*(X_nos(i,j)-X_nos(i,i))+A(i,j)*PI(i,j)*(X_nos(i,j)-X_nos(i,i));
            consen_y=consen_y+A(i,j)*(Y_nos(i,j)-Y_nos(i,i))+A(i,j)*PI(i,j)*(Y_nos(i,j)-Y_nos(i,i));
        end
        X_nos(i,i)=x_i;
        Y_nos(i,i)=y_i;

        x_i=x_i-alpha_k*form_game_x(X_nos(:,i),i)+c_k*consen_x;
        y_i=y_i-alpha_k*form_game_y(Y_nos(:,i),i)+c_k*consen_y;

        %% estimate
        X_others=X;
        Y_others=Y;

        X_others(i,:)=[];
        Y_others(i,:)=[];

        xi_others=X_others(:,i);
        yi_others=Y_others(:,i);

        ix_Sum_others=0;
        iy_Sum_others=0;

        for j=1:N
            ix_Sum_others=ix_Sum_others+A(i,j)*(1+PI(i,j))*(X_others(:,j)-X_others(:,i));
            iy_Sum_others=iy_Sum_others+A(i,j)*(1+PI(i,j))*(Y_others(:,j)-Y_others(:,i));
        end

        xi_others=xi_others+c_k*ix_Sum_others;
        yi_others=yi_others+c_k*iy_Sum_others;

        if i==1
            X_i=[x_i;xi_others];
            Y_i=[y_i;yi_others];
        elseif i==N
            X_i=[xi_others;x_i];
            Y_i=[yi_others;y_i];
        else
            X_i(1:i-1)=xi_others(1:i-1);
            Y_i(1:i-1)=yi_others(1:i-1);

            X_i(i)=x_i;
            Y_i(i)=y_i;

            X_i(i+1:end)=xi_others(i:end);
            Y_i(i+1:end)=yi_others(i:end);
        end

        %存储起来
        X_STemp(:,i)=X_i;
        Y_STemp(:,i)=Y_i;
        Error(i,k)=norm([x_i,y_i]-NE(i,:));
    end
    X=X_STemp;
    Y=Y_STemp;

    S_x(k,:)=diag(X_STemp);
    S_y(k,:)=diag(Y_STemp);

    S_X(N*k-N+1:N*k,:)=X_STemp;
    S_Y(N*k-N+1:N*k,:)=Y_STemp;
    T(k)=k;
    
end

Sx=S_x';
Sy=S_y';


figure(1)
plot(Sx(1,:),Sy(1,:),'-','color',[0 0.4470 0.7410],'LineWidth',1.2)
hold on
plot(Sx(2,:),Sy(2,:),'-','color',[0.8500 0.3250 0.0980],'LineWidth',1.2)
hold on
plot(Sx(3,:),Sy(3,:),'-','color',[0.4940 0.1840 0.5560],'LineWidth',1.2)
hold on
plot(Sx(4,:),Sy(4,:),'-','color',[0.4660 0.6740 0.1880],'LineWidth',1.2)
hold on 
plot(Sx(1,1),Sy(1,1),'o','color',[0 0.4470 0.7410],'LineWidth',1.2);hold on
plot(Sx(2,1),Sy(2,1),'o','color',[0.8500 0.3250 0.0980],'LineWidth',1.2); hold on
plot(Sx(3,1),Sy(3,1),'o','color',[0.4940 0.1840 0.5560],'LineWidth',1.2); hold on
plot(Sx(4,1),Sy(4,1),'o','color',[0.4660 0.6740 0.1880],'LineWidth',1.2); hold on
plot(Sx(1,T_end),Sy(1,T_end),'*','color',[0 0.4470 0.7410],'LineWidth',1.2);hold on
plot(Sx(2,T_end),Sy(2,T_end),'*','color',[0.8500 0.3250 0.0980],'LineWidth',1.2); hold on
plot(Sx(3,T_end),Sy(3,T_end),'*','color',[0.4940 0.1840 0.5560],'LineWidth',1.2); hold on
plot(Sx(4,T_end),Sy(4,T_end),'*','color',[0.4660 0.6740 0.1880],'LineWidth',1.2); hold on
grid minor;
h1=legend({'Agent 1','Agent 2','Agent 3','Agent 4'},NumColumns=2);
set(h1,'fontsize',10)
axis([-80,100,-80,100])
xlabel('$x_{i,1},\quad i\in \mathcal{N}$','Interpreter','latex','fontsize',14)
ylabel('$x_{i,2},\quad i\in \mathcal{N}$','Interpreter','latex','fontsize',14)

figure(2)
plot(T,Error(1,:),'-','color',[0 0.4470 0.7410],'LineWidth',1.2)
hold on
plot(T,Error(2,:),'-','color',[0.8500 0.3250 0.0980],'LineWidth',1.2)
hold on
plot(T,Error(3,:),'-','color',[0.4940 0.1840 0.5560],'LineWidth',1.2)
hold on
plot(T,Error(4,:),'-','color',[0.4660 0.6740 0.1880],'LineWidth',1.2)
hold on
h1=legend({'Agent 1','Agent 2','Agent 3','Agent 4'},NumColumns=2);
set(h1,'fontsize',10)
ylabel('$\|\xi_i-\xi_i^{*}\|,\quad i\in \mathcal{N}$','Interpreter','latex','fontsize',14)
xlabel('$\tau$','Interpreter','latex','fontsize',14)

figure (3)
p1=plot(c);
hold on
p2=plot(alpha);
h1=legend([p1,p2],'C','Alpha');
set(h1,'fontsize',10)
