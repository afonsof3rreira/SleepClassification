function FileNames = get_filenames_from_path(file_rel_dir)
% INPUT: 
% file_rel_dir: relative file directory

% OUTPUT:
% 1 x N string array containing N crawled filenames

file_path_struct = dir(file_rel_dir);

FileNames = {};
i=1;

for k=1:length(file_path_struct)
    if file_path_struct(k).bytes>10000
        FileNames{i}=(file_path_struct(k).name);i=i+1;
    end
end

end