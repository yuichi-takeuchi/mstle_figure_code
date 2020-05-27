function [ flag ] = dpf_getDependencyAndFiles( srcfilename, destFldr )
%
% This function collect and copy m files on which srcfile is dependent to
% destination folder.
%
% Copyright (c) Yuichi Takeuchi 2018

flag = 0;
% get info
[fList,~] = matlab.codetools.requiredFilesAndProducts(srcfilename);
% for i = 1:length(fList)
%     disp(fList(i))
% end

%Copy dependencies to dep sub folder made in current folder
mkdir dep
for i=1:length(fList)
    C = strsplit(fList{i},'\');
    system(['copy ' fList{i} ' ' pwd '\dep\' C{length(C)}]);
end

% move dependency file to the destination folder
movefile('dep',...
    destFldr);
flag = 1;