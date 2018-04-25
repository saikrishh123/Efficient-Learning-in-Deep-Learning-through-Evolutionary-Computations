function [state,options,optchanged] = gaoutfnc_nn_fb(options,state,flag)
optchanged=false;
 disp('In generation');
 load n;
 disp(strcat(num2str(n),'.', num2str(state.Generation)));
 if(strcmp(flag,'init'))
 [net,err]=ffnettrain(state.Population',state.Score');
 Population=state.Population;
 Score=state.Score;
     
 save Population Population
 save Score Score

 else
     load Population;
     load Score;
     Population=[Population;state.Population];
     Score=[Score;state.Score];
     
     [net,err]=ffnettrain(Population',Score');
     save Population Population
     save Score Score
 end
 disp('NN Error');
 display(err);
 R=perform_opt(net);
 disp(R.fbest);
 state.Population(end-99:end,:)=R.population(1:100,:);
% disp(options.PopulationSize)
% disp(options.CrossoverFraction)
% [options]=linearBalance(state,options,flag);
% optchanged=true;
% 
end

function [options]=linearBalance(state,options,flag)

if(strcmp(flag,'init'))
    options.CrossoverFraction=0.1;
    options.PopulationSize=1000;


else
   maxgen=200;
   minpop=100;
   maxpop=1000;
   minc=0.1;
   maxc=0.8;

   slopepop=(maxpop-minpop)/maxgen;
   slopec=(maxc-minc)/maxgen;
   
   options.PopulationSize=round(maxpop-slopepop*state.Generation);
   options.CrossoverFraction=slopec*state.Generation;
   
end
   



end