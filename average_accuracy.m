function aa_val=average_accuracy(trueLabel,pridictedLabel)
% ÿ����ľ�ȷ����ƽ��
classes=unique(trueLabel);
classnum=length(classes);
acc(classnum)=0;
for i=1:classnum
    acc(i)=sum(trueLabel==classes(i)&pridictedLabel==classes(i)) /  sum(trueLabel==classes(i));
end
aa_val=mean(acc);

