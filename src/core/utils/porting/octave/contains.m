function [val] = contains(stringcollection, pattern)
val = zeros(0, 1);
for i=1:length(stringcollection)
    if strcmp(stringcollection{i}, pattern)
        val = i;
        return
    end
end
end
