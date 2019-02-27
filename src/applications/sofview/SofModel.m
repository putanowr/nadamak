classdef SofModel < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        config
    end
    
    methods
        function obj = SofModel()
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.config = 'ala';
        end
        
        function [status, msg] = readConfig(obj,fname)
            try
                text = fileread(fname);
            catch
                status = false;
                msg = 'Reading file failed';
                return
            end 
            try
                obj.config = jsondecode(text);
            catch
                status = false;
                msg = 'Decoding JSON failed';
                return
            end
            msg = 'File read corectly';
            status = true;
        end
    end
end

