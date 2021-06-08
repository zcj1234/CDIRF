function test(featureNums,exp_count,sigma)
load(fullfile('C:\Users\111\Desktop\CDIRF\data',sprintf('exp%d-sample.mat',exp_count)),'trainData1','trainData2','testData2','trainLabel1','trainLabel2','testLabel2');


[weight]=CDIRF(sigma,trainData1,trainData2,trainLabel1,trainLabel2);%feature selection
[~,ig_idx]=sort(weight,2,'descend');
save(fullfile('cindex_i',sprintf('exp%d-sigma=%.16g.mat',exp_count,sigma)),'ig_idx','weight');

for featureNum=featureNums
trainData2Sel=trainData2(:,ig_idx(1,1:featureNum)); 
testDataSel=testData2(:,ig_idx(1,1:featureNum)); 
    for g=2.^(-10:10)
        for c=10.^(-2:3)
            model2=svmtrain(trainLabel2,trainData2Sel,sprintf('-s 0 -t 2 -g %.16f -c  %.16f',g,c));
            [predict_label2,accuracy2,decision_values2]=svmpredict(testLabel2,testDataSel,model2);
            %three accuracies
            aa_val2=average_accuracy(testLabel2,predict_label2);
            oa_val2=overall_accuracy(testLabel2,predict_label2);
            kappa_val2=compute_kappa(testLabel2,predict_label2);
            save(fullfile('data2',sprintf('result-exp%d-feat=%d-SVM-g=%.16g-c=%.16g-sigma=%.16g.mat',exp_count,featureNum,g,c,sigma)),'featureNum', 'model2','predict_label2', 'aa_val2','oa_val2','kappa_val2','c','g','sigma');
        end
    end
end
