classdef Tagger  < handle
  properties(SetAccess=private)
    tagfun
    priorityTable
    defaultPriority = 0;
    transitionTable
    transitionMax
  end
  methods
    function obj = Tagger(taggingType, varargin)
      tt = mp.TaggingType(taggingType);
      switch tt
        case mp.TaggingType.Max 
          obj.tagfun = @obj.tag_max;
        case mp.TaggingType.Min
          obj.tagfun = @obj.tag_min;
        case mp.TaggingType.Transition
          obj.tagfun = @obj.tag_table;
          if length(varargin) < 1
            error('Tagging table for Tagger not given')
          end
          obj.transitionTable = varargin{1};
          obj.transitionMax = max(obj.transitionTable(:));
          s = size(obj.transitionTable);
          if s(1) ~= s(2)
            error('Transition table for Tagger is not square');
          end
          if obj.transitionMax > s(1)
            error('Transition table max %d > table size %d', obj.transitionMax, s(1));
          end
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
    function tag = tag_table(obj, oldTag, newTag)
      if oldTag > obj.transitionMax || newTag > obj.transitionMax
        error("Tag values (%d, %d) exceede transition table max %d",...
          oldTag, newTag, obj.transitionMax);
      end
      if oldTag < 1 || newTag < 1
        tag = oldTag;
      else
        tag = obj.transitionTable(oldTag, newTag);
      end  
    end
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
