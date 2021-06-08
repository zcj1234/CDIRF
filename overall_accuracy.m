function oa_val=overall_accuracy(trueLabel,pridictedLabel)
oa_val=sum(trueLabel==pridictedLabel)/length(trueLabel);

