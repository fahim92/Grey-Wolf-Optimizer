format short %Display output upto 4 digits
clear all %Clear all the Stored variable
clc % Clear the screen

%Initialize the parameters
fun=@fun3bar  %Call the function
N=100;  %Population Size
D=7; % Dimension of Problem

lb=[100, 50, 50, 50, 100, 50, 100];%[0.0625 0.0625 10 10];
ub=[575, 100, 140, 100, 550, 100, 410];%[99*0.0625 99*0.0625 200 200];

% lb=[0 0];
% ub=[1 1];
itermax=800;

%Generating the initial population

for i=1:N
    for j=1:D
        pos(i,j)=lb(j)+rand.*(ub(j)-lb(j));
        disp(pos);
    end
end


% Evaluate the objective function
fx=fun(pos);   % Compute objective function

%Initialize gbest
[fminvalue,ind]=min(fx);  %Finding minimum value 
gbest=pos(ind,:);         %Finding corresponding position


%GWO main loop start

iter=1;
while iter<=itermax
    Fgbest=fminvalue;
    a=2-2*iter/itermax;
    for i=1:N
        X=pos(i,:)  %Take grey wolf
        pos1=pos;  %Store a copy of position %pos and pos1 are actually the same thing.
        A1=2.*a.*rand(1,D)-a;  %Compute A1 
        C1=2.*rand(1,D);
        [alpha,alphaind]=min(fx);  %Finding best value
        [alpha,alphaind]=min(fx);  %Finding the best value (copy)
        alphapos=pos1(alphaind,:);  % Finding Best Position index--for finding alphapos 
        Dalpha=abs(C1.*alphapos-X); % Here X is the first postion -- alphapos is the functions minimum value.  
        X1=alphapos-A1.*Dalpha;     % alphapos 
        pos1(alphaind,:)=[];  % Remove the best position from population
        fx1=fun(pos1);      % Compute the fitness value- Finding the minimum value from the rest of the N-1 postions. fx1
        
        %Finding beta position
        [bet,betind]=min(fx1);   % Finding the minimum value from the rest of the N-1 values. fx1 is the curtailed of fx
        betpos=pos1(betind,:);   % 5 ta value chhilo pore curtail kore hoyto 4 ta thaklo.. shei 4 tar minimum position    
        A2=2.*a.*rand(1,D)-a;  %Compute A2
        C2=2.*rand(1,D);        % Compute C2
        Dbet=abs(C2.*betpos-X); % Calculating Dbet 
        X2=betpos-A2.*Dbet;     % X2-- if found.. ekhon alphaind and betaind rekhe baki position gula pos1 theke delete maro 
        
        pos1(betind,:)=[];  % Remove the best position from the population
        fx1=fun(pos1);     %Compute the fitness value the 4 values (Assuming initial population was 5)
        
        %finding delta position 
        
        [delta,deltaind]=min(fx1);  %Finding best value out of the rest 3 position values
        deltapos=pos1(deltaind,:);  % Finding best position index
        A3=2.*a.*rand(1,D)-a;  %Calculating A3
        C3=2.*rand(1,D);       %Calculating C3
        Ddelta=abs(C3.*deltapos-X);  % 
        X3=deltapos-A3.*Ddelta;
        
        Xnew=(X1+X2+X3)./3         %Compute the new solution 
        
        
        %Check the bounds
        Xnew=max(Xnew,lb);         %Preserver lower bounds
        Xnew=min(Xnew,ub);         %Preserve the upper bounds
        fnew=fun(Xnew);
        
        %%Greedy Selection 
        
        if fnew<fx(i)
            pos(i,:)=Xnew;
            fx(i,:)=fnew;
            
        end
    end
    
    %Update Gbest (destination)
    
    [fmin,find]=min(fx);
    if fmin<Fgbest;
        Fgbest=fmin;
        gbest=pos(find,:);
    end
    
    
    % Memorize the best value
    [optval,optind]=min(fx);
    BestFx(iter)=optval;
    BestX(iter,:)=pos(optind,:);
    
    
    %Plotting the result
    
    plot(BestFx,'LineWidth',2);
    xlabel('Iteration Number');
    ylabel('Fitness Value');
    title('Convergence vs Iteration');
    grid on
    
    iter=iter+1;
end
        