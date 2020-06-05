%%% DIRECTORY: Full path to directory containing files/folders
%%% INCLUDE_KEYS: Cell array containing keywords that files MUST have (AND)
%%% EXCLUDE_KEYS: Cell array containing keywords that files MUST not have
%%% (OR)
function [data_files, data_files_full] = getFiles(files_directory, include_keys, exclude_keys)

files_struct = dir(files_directory);
files_folder = files_struct.folder;
%data_files = extractfield(files_struct, 'name'); THIS FUNCTION LICENSE IS
%ALWAYS BUSY 
data_files = struct2cell(files_struct);
data_files = data_files(1,:);

final_include_indices = ones(1, length(data_files));
final_exclude_indices = ones(1, length(data_files));

if (~isempty(include_keys))
    include_indices = cellfun(@(x) strfind(data_files, x), include_keys, 'UniformOutput', false);
    include_indices = cellfun(@(x) ~cellfun('isempty', x), include_indices, 'UniformOutput', false);
    final_include_indices = ones(1, length(data_files));
    for i = 1:length(include_indices)
        cur_indices = include_indices{i};
        final_include_indices = cur_indices & final_include_indices;
    end
end


if (~isempty(exclude_keys))
    exclude_indices = cellfun(@(x) strfind(data_files, x), exclude_keys, 'UniformOutput', false);
    exclude_indices = cellfun(@(x) cellfun('isempty', x), exclude_indices, 'UniformOutput', false);
    final_exclude_indices = zeros(1, length(data_files));
    for i = 1:length(exclude_indices)
        cur_indices = exclude_indices{i};
        final_exclude_indices = cur_indices | final_exclude_indices;
    end
end

final_grab_indices = final_include_indices & final_exclude_indices;
data_files = data_files(final_grab_indices);

data_files_full = cellfun(@(x) strcat(strcat(files_folder,'/'),x), data_files, 'UniformOutput', false);