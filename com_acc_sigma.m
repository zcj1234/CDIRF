        clc
        clear
     
        Sigma=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.5,2,10,100]; 
        exp_num=10;
        featNum_range=5:5:60;
        c_range=10.^(-2:3);
        g_range=2.^(-10:10);
        
        oa_ci_featNum=zeros(1,12);
        aa_ci_featNum=zeros(1,12);
        kappa_ci_featNum=zeros(1,12);
        oa_exp=zeros(exp_num,length( featNum_range));
        aa_exp=zeros(exp_num,length( featNum_range));
        kappa_exp=zeros(exp_num,length( featNum_range));
        
        m=0;
     for exp_count=1:exp_num
             m=m+1;
             aa_featNum_sigma=zeros(length(Sigma),length( featNum_range));
             oa_featNum_sigma=zeros(length(Sigma),length( featNum_range));
             kappa_featNum_sigma=zeros(length(Sigma),length( featNum_range));
             n=0;
             for sigma=Sigma
                    n=n+1;
                    s=0;
              for featureNum=featNum_range
                    s=s+1;
                    aa=zeros(length(g_range),length(c_range));
                    oa=zeros(length(g_range),length(c_range));
                    kappa=zeros(length(g_range),length(c_range));
                    
                    i=0;
                    for g=g_range
                        i=i+1;j=0;
                        for c=c_range
                            j=j+1;
                            load(fullfile('data2',sprintf('result-exp%d-feat=%d-SVM-g=%.16g-c=%.16g-sigma=%.16g.mat',exp_count,featureNum,g,c,sigma)),'featureNum', 'model2','predict_label2', 'aa_val2','oa_val2','kappa_val2','c','g','sigma');
                            aa(i,j)=aa_val2;
                            oa(i,j)=oa_val2;
                            kappa(i,j)=kappa_val2;
                        end
                    end
                   
                    [max_oa2,idx_oa2]=max(oa(:));
                    oa_featNum_sigma(n,s)=max_oa2;                      

                    [max_aa2,idx_aa2]=max(aa(:));
                    aa_featNum_sigma(n,s)=max_aa2;

                    [max_kappa2,idx_kappa2]=max(kappa(:));
                    kappa_featNum_sigma(n,s)=max_kappa2;                   
              end  
                    
             end       
                       [sigma_index_oa,~]=find(mean(oa_featNum_sigma,2)==max(mean(oa_featNum_sigma,2)));
                       [sigma_index_aa,~]=find(mean(aa_featNum_sigma,2)==max(mean(aa_featNum_sigma,2)));
                       [sigma_index_kappa,~]=find(mean(kappa_featNum_sigma,2)==max(mean(kappa_featNum_sigma,2)));
                       sigma_oa=Sigma(sigma_index_oa(1));
                       sigma_aa=Sigma(sigma_index_aa(1));
                       sigma_kappa=Sigma(sigma_index_kappa(1));
                       save(fullfile('csigma',sprintf('exp%d-sigma.mat',exp_count)),'sigma_oa','sigma_aa','sigma_kappa');
            
                       oa_exp(m,:)=oa_featNum_sigma(sigma_index_oa(1),:);
                       aa_exp(m,:)=aa_featNum_sigma(sigma_index_aa(1),:);
                       kappa_exp(m,:)=kappa_featNum_sigma(sigma_index_kappa(1),:);
%                 
     end
        oa_ci_featNum=mean( oa_exp);
        aa_ci_featNum=mean( aa_exp);
        kappa_ci_featNum=mean( kappa_exp);
        OA=mean(oa_exp,2);
        save(fullfile('acc_sigma',sprintf('acc_exp.mat')),'oa_exp','aa_exp','kappa_exp','OA');
        save(fullfile('acc_sigma',sprintf('acc.mat')),'oa_ci_featNum','aa_ci_featNum','kappa_ci_featNum');