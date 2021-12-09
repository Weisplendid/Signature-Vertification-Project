SourcePath = 'D:\data\Verification';

cd(SourcePath);
File = dir('*.png');
len = length(File);
for i = 1:len 
    disp(File(i).name)
    img = imread(File(i).name);
    img = imbinarize(img);
    img_edge = edge(img,'Prewitt');
    [featureVector,~] = extractHOGFeatures(img_edge,'CellSize',[96 96]);
    trainedModel.predictFcn(featureVector')
end