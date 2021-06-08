function aa_val=average_accuracy(trueLabel,pridictedLabel)
% 每个类的精确度算平均
classes=unique(trueLabel);
classnum=length(classes);
acc(classnum)=0;
for i=1:classnum
    acc(i)=sum(trueLabel==classes(i)&pridictedLabel==classes(i)) /  sum(trueLabel==classes(i));
end
aa_val=mean(acc);

