function c= find_right_number_of_clusters(population)

for i=1:100
idx(i,:) = kmeans(population,i, 'Distance','cityblock','Display','iter');
[silh(i,:),h] = silhouette(population,idx(i,:),'cityblock');
c(i)=mean(silh(i,:));
end

display(max(c));
end