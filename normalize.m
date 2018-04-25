function norm_data= normalize(bla)
norm_data = (bla - min(bla)) / ( max(bla) - min(bla) );

end