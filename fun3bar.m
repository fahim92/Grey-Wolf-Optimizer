function out = fun3bar(X)
y1=X(:,1);
y2=X(:,2);
y3=X(:,3);
y4=X(:,4);
y5=X(:,5);
y6=X(:,6);
y7=X(:,7);

a = [0.007, 0.0095, 0.009, 0.009, 0.008, 0.0075, 0.0068];
b = [7, 10, 8.5, 11, 10.5, 12, 10];
c = [400, 200, 220, 200, 240, 200, 180];
fx = 0;
for gen=1:length(a)
fx_solo = a(gen).*X(:,gen).^2+b(gen).*X(:,gen)+c(gen);
fx = fx+fx_solo;
end
%% PV cost addition
Ps = 0;
N= 20;
r= 0.09;
asolar = r/(1+(1+r)^-N);
Ip = 5000;
Ge =0.016;
FPs = Ge.*Ps;%asolar.*Ip.*Ps+Ge.*Ps;
fx = fx+FPs;
%% Wind cost function
Pw = 0.58;
Ipw = 1400;
FPw = Ge.*Pw;%asolar.*Ipw.*Pw+Ge.*Pw;
fx = fx+FPw;
% %Write inequality constraints 
% g(:,1)=y3-130;
% % g(:,1)=y1+y2+y3+y4-700-0.00001;
% % g(:,1)=-y1+0.0193.*y3;
% % g(:,2)=-y2+0.00954.*y3;
% % g(:,3)=-pi.*y3.^2.*y4-(4/3).*pi.*y3.^3+1296000;
% % g(:,4)=y4-240;
% 
% %Define Penalty Term 
% pp=10^9;
% for i=1:size(g,1)
%     for j=1:size(g,2)
%         if g(i,j)>0
%             penalty(i,j)=pp.*g(i,j);
%         else
%             penalty(i,j)=0;
%         end
%     end
% end
% 
% %Compute Objective Function 
% out=fx+sum(penalty,2);

g(:,1) = 800-y1-y2-y3-y4-y5-y6-y7-Ps-Pw;
%g(:,2) = x1+x2+x3-200-0.00001;

pp = 10^9;
for i = 1:size(g,1)
    for j = 1:size(g,2)
        if g(i,j)>0
            penalty(i,j)=pp.*g(i,j);
        else
            penalty(i,j)=0;
        end
    end
end
out=fx+sum(penalty,2)