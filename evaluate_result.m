function accuracy = evaluate_result
    result_folder = 'again final';
    result_path = dir('again final/');
    accuracy = [];
    for i=3:numel(result_path)
        result_file = result_path(i,1).name;
        %image_id = strrep(result_file,'.tiff');
        [pathstr,name,ext] = fileparts(result_file);
        acc_result = acc_eval(result_folder,name);
        accuracy = [accuracy; acc_result];
    end
end

function acc_result = acc_eval(result_folder,image_id)
    gt = imread(strcat('gt/',image_id,'.ah.bmp'));
    result = imread(strcat(result_folder,'/',image_id,'.tiff'));
    imshow(result);
    A = numel(find(gt~=0&result==0));
    B = numel(find(gt~=0&result~=0));
    C = numel(find(gt==0&result~=0));
    
    recall = B/(A+B);
    precision = B/(B+C);
    acc_result = [recall precision];
end