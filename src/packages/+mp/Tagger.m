classdef Tagger  < handle
  properties(SetAccess=private)
    tagfun
    priorityTable
    defaultPriority = 0;
  end
  methods
    function obj = Tagger(taggingType, varargin)
      tt = mp.TaggingType(taggingType);
      switch tt
        case mp.TaggingType.Max 
          obj.tagfun = @obj.tag_max;
        case mp.TaggingType.Min
          obj.tagfun = @obj.tag_min;
        case mp.TaggingType.Priority
          obj.tagfun = @obj.tag_priority;
          if length(varargin) < 1
            error('Priority table for Tagger not given')
          end
          obj.priorityTable = varargin{1};
          if length(varargin) > 1
            obj.defaultPriority = varargin{2};
          end
        otherwise
          error('Invalid tagging type');
      end
    end
    function t=tag(obj,oldTag, newTag)
      t = obj.tagfun(oldTag, newTag);
    end
  end
  methods(Access=private)
    function tag = tag_max(obj, oldTag, newTag)
      tag = newTag;
      if oldTag > newTag
        tag = oldTag;
      end
    end
    function tag = tag_min(obj, oldTag, newTag)
      tag = newTag;
      if oldTag < newTag
        tag = oldTag;
      end
    end
    function tag = tag_priority(obj, oldTag, newTag)
      tag = newTag;
      if obj.priority(oldTag) > obj.priority(newTag) 
        tag = oldTag;
      end
    end
    function p = priority(obj, tag)
      id = find(obj.priorityTable(:,1) == tag);
      if isempty(id)
        p = obj.defaultPriority;
      else
        p = obj.priorityTable(id, 2);
      end
    end 
  end
end
