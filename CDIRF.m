function [Weight] =CDIRF(sigma,trainData1,trainData2,trainLabel1,trainLabel2)
%CDIRF1 using absolute distance
%CDIRF2 using squared Euclidean distance
Uc = unique(trainLabel2);%number of classes
N_patterns1 = length(trainLabel1);% # number of samples
N_patterns2 = length(trainLabel2);
dim = size(trainData2,2);      % Data dimenionality

%sort samples of the two scene according to classes
for n=1:length(Uc)
    temp1 = find(trainLabel1==n);
    index1{n} =temp1;
    N1(n) = length(temp1);
end
for n=1:length(Uc)
    temp2 = find(trainLabel2==n);
    index2{n} =temp2;
    N2(n) = length(temp2);
end

Prioi1 = N1/sum(N1);
Prioi2 = N2/sum(N2);

History = zeros(100,dim);%Store the weights for each iteration
Weight = 1/sqrt(dim)*ones(1,dim);%initial weights
History(1,:)= Weight;

Difference =1;
t=0;
Theta =[];
while Difference>0.00001 && t<=100
    t=t+1;
  %select sample in target scene
    NM_s = zeros(N_patterns1,dim);
    NH_s = zeros(N_patterns1,dim);
    NM_t = zeros(N_patterns2,dim);
    NH_t = zeros(N_patterns2,dim);
for i = 1:N_patterns2
        Prob_dif_s = 0;
        Prob_same_s = 0;
        Prob_dif_t = 0;
        Prob_same_t = 0;
        for c = 1:length(Uc)
           
                  %CDIRF1
              %Temp_s    = abs(trainData1(index1{c},:) -ones(N1(c),1)*trainData2(i,:));  
              %Temp_t    = abs(trainData2(index2{c},:) -ones(N2(c),1)*trainData2(i,:));
                  %CDIRF2
              Temp_s    = (trainData1(index1{c},:) -ones(N1(c),1)*trainData2(i,:)).^2;
              Temp_t    = (trainData2(index2{c},:) -ones(N2(c),1)*trainData2(i,:)).^2;
              dist_s    = sum((ones(N1(c),1)*Weight(1,:)).*Temp_s,2);
              dist_t    = sum((ones(N2(c),1)*Weight(1,:)).*Temp_t,2);
              temp_index = find(dist_t==0);
              prob_s = exp(-dist_s/sigma);%f() 
              prob_t = exp(-dist_t/sigma);
              prob_t(temp_index) = 0; 
               if sum(prob_s)~=0
                   prob_s1 = prob_s/sum(prob_s);
                   else
                   prob_s1=zeros(length(prob_s),1);
               end
               
               if sum(prob_t)~=0
                   prob_t1 = prob_t/sum(prob_t);
                   else
                   prob_t1=zeros(length(prob_t),1);
               end
               
            if trainLabel2(i)==c                
                for j=1:N1(c)
                    TEMP_s(j,:)=prob_s1(j,1).*Temp_s(j,:);
                end
                NH_s(i,:)=sum(TEMP_s);
                Prob_same_s = sum(prob_s)/N1(c);
                
                for j=1:N2(c)
                    TEMP_t(j,:)=prob_t1(j,1).*Temp_t(j,:);
                end
                NH_t(i,:)=sum(TEMP_t);
                Prob_same_t = sum(prob_t)/N2(c);
            end
            
            if trainLabel2(i)~=c 
                NM_s(i,:) = NM_s(i,:)+ (prob_s1(:,1)')*Temp_s*Prioi1(c)/(1-Prioi1(trainLabel2(i)));
                NM_t(i,:) = NM_t(i,:)+ (prob_t1(:,1)')*Temp_t*Prioi2(c)/(1-Prioi2(trainLabel2(i)));
                Prob_dif_s = Prob_dif_s+sum(prob_s)/N1(c);
                Prob_dif_t = Prob_dif_t+sum(prob_t)/N2(c);
            end
        end
        
                Pro_NoT_Outlier(i) = (Prob_same_s+Prob_same_t)/(Prob_same_s+Prob_same_t+Prob_dif_s+Prob_dif_t);%outlier
                NH_s(i,:) = NH_s(i,:)*Pro_NoT_Outlier(i);
                NM_s(i,:) = NM_s(i,:)*Pro_NoT_Outlier(i);
                NH_t(i,:) = NH_t(i,:)*Pro_NoT_Outlier(i);
                NM_t(i,:) = NM_t(i,:)*Pro_NoT_Outlier(i);
end
%%
 %select sample in source scene
  NM = zeros(N_patterns1,dim);
  NH = zeros(N_patterns1,dim);
  NM2 = zeros(N_patterns1,dim);
  NH2 = zeros(N_patterns1,dim);
for i = 1:N_patterns1
    Prob_dif = 0;
    Prob_same = 0;
    Prob_dif2 = 0;
    Prob_same2 = 0;
    
      for c = 1:length(Uc)
                    %CDIRF2
              Temp   = (trainData2(index2{c},:) -ones(N2(c),1)*trainData1(i,:)).^2;
              Temp2    = (trainData1(index1{c},:) -ones(N1(c),1)*trainData1(i,:)).^2;
                    %CDIRF1
  %           Temp   = abs(trainData2(index2{c},:) -ones(N2(c),1)*trainData1(i,:));
  %           Temp2   = abs(trainData1(index1{c},:) -ones(N1(c),1)*trainData1(i,:));
              dist   = sum((ones(N2(c),1)*Weight(1,:)).*Temp,2);
              dist2   = sum((ones(N1(c),1)*Weight(1,:)).*Temp2,2);
              temp_index = find(dist2==0);
              prob = exp(-dist/sigma); %f()  
               if sum(prob)~=0
                   prob_1 = prob/sum(prob);
                    else
                    prob_1=zeros(length(prob),1);
               end
               prob2 = exp(-dist2/sigma);
               prob2(temp_index) = 0;
               if sum(prob2)~=0
                  prob_2 = prob2/sum(prob2);
               else
                   prob_2=zeros(length(prob2),1);
               end
               
            if trainLabel1(i)==c
                for j=1:N2(c)
                    TEMP(j,:)=prob_1(j,1).*Temp(j,:);
                end
                NH(i,:)=sum(TEMP);
                Prob_same = sum(prob)/N2(c);
                    
                 for j=1:N1(c)
                    TEMP2(j,:)=prob_2(j,1).*Temp2(j,:);
                 end
                 NH2(i,:)=sum(TEMP2);
                 Prob_same2 = sum(prob2)/N1(c);
            end
            
            if trainLabel1(i)~=c 
                NM(i,:) = NM(i,:)+ (prob_1(:,1)')*Temp*Prioi2(c)/(1-Prioi2(trainLabel1(i))); 
                NM2(i,:) = NM2(i,:)+ (prob_2(:,1)')*Temp2*Prioi1(c)/(1-Prioi1(trainLabel1(i)));
                Prob_dif = Prob_dif+sum(prob)/N2(c);
                Prob_dif2 = Prob_dif2+sum(prob2)/N1(c);
            end                                                  
      end 

                Pro_NoT_Outlier_s(i) = (Prob_same+Prob_same2)/(Prob_same+Prob_same2+Prob_dif+Prob_dif2);%outlier
                NH(i,:) = NH(i,:)*Pro_NoT_Outlier_s(i);               
                NM(i,:) = NM(i,:)*Pro_NoT_Outlier_s(i);

                NH2(i,:) = NH2(i,:)*Pro_NoT_Outlier_s(i);               
                NM2(i,:) = NM2(i,:)*Pro_NoT_Outlier_s(i);
end

    C = (sum(NM_s)-sum(NH_s)+ sum(NM_t)-sum(NH_t))/N_patterns2 +(sum(NM)-sum(NH)+ sum(NM2)-sum(NH2))/N_patterns1  ;
    in = find(C<0); %Remove the negative distance feature
    C(in)=0;
    Weight = C/norm(C);    
    Difference = norm(Weight-History(t,:));
    Theta(t) = Difference;
    History(t+1,:) = Weight;
end
end

