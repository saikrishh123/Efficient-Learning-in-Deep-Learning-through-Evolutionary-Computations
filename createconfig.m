function l=createconfig(n,genome_length,pop_length,InputLength,InputCount,TargetCount,problemType)
a=fileread('config_template.h');
a=strrep(a, '$gl$', num2str(genome_length));
a=strrep(a, '$n$', num2str(n));
a=strrep(a, '$tc$', num2str(TargetCount));
a=strrep(a, '$ic$', num2str(InputCount));
a=strrep(a, '$il$', num2str(InputLength));
a=strrep(a, '$pl$', num2str(pop_length));

fname='config.h';
fileID = fopen(fname,'w');
fprintf(fileID,'%s',a);
fclose(fileID);
switch problemType
    case 'regression'
        system('nvcc -ptx cost.cu')
        l = parallel.gpu.CUDAKernel('cost.ptx','cost.cu');
        l.ThreadBlockSize=[InputLength,1,1];
        l.GridSize=[pop_length,1,1];
        
        
    otherwise
        system('nvcc -ptx cost_CE.cu')
        l = parallel.gpu.CUDAKernel('cost_CE.ptx','cost_CE.cu');
        l.ThreadBlockSize=[InputLength,1,1];
        l.GridSize=[pop_length,1,1];
end


end