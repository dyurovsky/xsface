clear all

filepath = '../data/detectors/';
files = dir([filepath '*.txt']);
files = {files.name};
ages = {'08','12','16'};

% [6437,18069,25659,21071,
%   20021,6696,12891,25982,
%   7667,3545,17039,18589,
%   2615,26933,8757,17559,
%   18118,16967,27833,23864]

%% read files one by one

cs = zeros(length(ages),1); % age counters to merge into an age structure

for i = 1:length(files)
  disp(files{i})
  data = dlmread([filepath files{i}]); 
  agegrp = find(strcmp(ages,files{i}(1:2)));

  all_dets{agegrp}{cs(agegrp)+1} = data;
  subids{agegrp}{cs(agegrp)+1} = files{i}(1:4);
  cs(agegrp) = cs(agegrp) + 1;
end

%% output

frame_size = [720 480];
total_pixels = prod(frame_size);

ages = {'8','12','16'};

fid = fopen('../data/all_detectors.csv','w');
fprintf(fid,'subid,frame,face\n');

for a = 1:length(ages)    
    for c = 1:length(all_dets{a})                 
        % there is a face if either the mother or father is present
        preds{a}{c} = any(squeeze(~isnan((all_dets{a}{c}(:,2,:)))),2);             
        
        fprintf('%s: %d detections\n',subids{a}{c},sum(preds{a}{c}));
               
        % now output
        for d = 1:length(preds{a}{c})
          fprintf(fid,'%s,%s,%d\n',....
            ['XS_' subids{a}{c}],num2str(d),preds{a}{c}(d));
        end    
    end
end

fclose(fid);

save(['mats/detectors_' datestr(now,1) '.mat'],'all_dets','files');
