%% Using enumerations for categorical data
% 
% Using integer values to describe categorical data, e.g. types of
% elements,types of DOFs, etc. is cumbersome and error prone. 
% It forces developers to remember many 'magic' values.
%
% Contrary to this, enumeration classes provide many advantages. Besides
% improving code readability they can also prevent many, hard to debug,
% errors. This is the reason that combMESBMRS package provides several
% enum types. 
%


%% Enums for DOF types
enumeration mp.FEM.DofType

%% 
% To create enumeration value
dt = mp.FEM.DofType.Temperature

%% 
% To make syntax shorter one can also import the enum class
import mp.FEM.DofType
dt = DofType.Temperature;

%%
% Instead of using enum tags one can use conversion from strings
dt = DofType('Temperature')

%%
% It is also possible to use abreviated names and different cases, as long
% as the conversion is unique
dt = DofType('temp')

%%
% To convert enumeration value to string
disp(char(dt))

%%
% To convert enumeration value to integer
disp(int32(dt))

%% Enums for finite element types
enumeration mp.FEM.FemType

%% Enums for boundary condition types
enumeration mp.FEM.BcType

%% Check if value is an enum or object of given class
dt = DofType('temp');

%%
% Check if value is enum type
isenum(dt)

%%
% Check if value is an object of given class
isa(dt, 'mp.FEM.BcType')

%% 
% Internal management of demo. Do not call if reporducing this demo
mp_manage_demos('report', 'mp_enumerations', true);
