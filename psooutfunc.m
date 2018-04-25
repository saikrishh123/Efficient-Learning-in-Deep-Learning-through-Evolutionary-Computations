function [stop] = psooutfunc(options,state)
stop=false;
 disp('In Iteration');







load val1;
load val2;
load iteration;
iteration=options.iteration;
save iteration iteration;
disp(strcat(num2str(val1),'.',num2str(val2),'.' ,num2str(options.iteration)));
%load G;
s.iteration=options.iteration;
s.Best=options.bestfval;

s.BestGenome=options.bestx;
s.val1=val1;
s.val2=val2;

load latestSwarm;
load G

latestSwarm=options.swarm;
save latestSwarm latestSwarm;
G.xbest=s.BestGenome;

switch G.opts.funcName
    case 'computecostIris'
        [O,s.valAcc,c]=G.testIris(G.TestInput,G.TestTarget);
        disp(s.valAcc);
        
    otherwise
        s.valAcc=G.testComplex(G.TestInput,G.TestTarget,G.opts.weights_activation_func_parameter,G.opts.node_activation_func_parameter);
        disp(s.valAcc);
end


global StateInfo;
StateInfo{options.iteration+1}=s;



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