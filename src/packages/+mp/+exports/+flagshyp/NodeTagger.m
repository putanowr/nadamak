classdef NodeTagger  < handle
  properties (Constant)
     tagTable = [0  1  2  3  4  5  6  7
                 1  1  3  3  5  5  7  7
                 2  3  2  3  6  7  6  7
                 3  3  3  3  7  7  7  7
                 4  5  6  7  4  5  6  7
                 5  5  7  7  5  5  7  7
                 6  7  6  7  6  7  6  7
                 7  7  7  7  7  7  7  7];   
  end
  methods
    function obj = NodeTagger()
    end
    function t = tag(obj, oldTag, newTag)
      t = obj.tagTable(oldTag+1, newTag+1);
    end
  end  
end
