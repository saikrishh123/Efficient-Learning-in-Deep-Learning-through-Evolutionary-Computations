function out=createreducedMnistdata(train,idx)

for i=1:length(train)
    
    img=train{1,i};
    img=img';
    img=img(:);
    out(i,:)=img(idx)';
    
        
    
end

end