function tagger = mp_get_tagger(taggingType)
  %% Return Tagger object depending on tagging type.
  % This function wrapps as 'default' tagger a priority tagger
  % with the priorities 0->0, 1->100, 2->75, 3->50, 4->25, which are set
  % to server purpose of kernel implementation.
  if strcmp(taggingType, 'default')
    tagger = mp.Tagger('priority', [0,0; 1, 100; 2,75; 3,50; 4, 25]);
  else
    tagger = mp.Tagger(taggingType);
  end
end
