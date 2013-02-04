%ostu image segment
% created by linxin
% mcrc 2006.02.28

function threshold=ostu(x)

[m,n]=size(x);
N=m*n;
num=zeros(1,1000);
p=zeros(1,1000);

for i=1:m
     for j=1:n
         num(x(i,j)+1)=num(x(i,j)+1)+1;
     end
end

for i=0:999;
     p(i+1)=num(i+1)/N;
end

totalmean=0;
for i=0:999;
     totalmean=totalmean+i*p(i+1);
end

maxvar=0;

for k=0:999
     kk=k+1;
     zerosth=sum(p(1:kk));
    
     firsth=0;
     for h=0:k
         firsth=firsth+h*p(h+1);
     end

     var=totalmean*zerosth-firsth;
     var=var*var;
     var=var/(zerosth*(1-zerosth)+0.01);
     var=sqrt(var);
     if(var>maxvar)
         maxvar=var;
         point=k;
     end
   
end

threshold=point;