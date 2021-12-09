clear, clc

SourcePath = 'D:\data\dataset';
name = 'lt';       %训练集master
setSize = 200;      %训练集大小

cd(SourcePath);
File = dir('*.');
if(strcmp(File(3).name,name))
    Genuine = [SourcePath '\' name];
    Fake = [SourcePath '\' File(4).name];
else
    Genuine = [SourcePath '\' File(4).name];
    Fake = [SourcePath '\' File(3).name];
end
clear File name


RandomCol = 50;
Row = 108;
Col = length(dir([Fake '/*png'])) + length(dir([Genuine '/*png'])) + RandomCol;
trainingSet_ = zeros(Row, Col);
resultSet_ = zeros(1, Col);

file = dir([Fake '/*png']);
FCol = length(file);
cd(Fake)
for i = 1:FCol
    img = imread(file(i).name);
    img=img(:,:,1);
    img_edge = edge(img,'Prewitt');
    [featureVector,~] = extractHOGFeatures(img_edge,'CellSize',[96 96]);
    trainingSet_(:,i) = featureVector;
    resultSet_(1,i) = 0;
end

file = dir([Genuine '/*png']);
GCol = FCol + length(file);
cd(Genuine)
for i = FCol+1:GCol
    img = imread(file(i - FCol).name);
    img=img(:,:,1);
    img_edge = edge(img,'Prewitt');
    [featureVector,~] = extractHOGFeatures(img_edge,'CellSize',[96 96]);
    trainingSet_(:,i) = featureVector;
    resultSet_(1,i) = 1;
end

height = 250;
width = 450;
for i = GCol+1:GCol+RandomCol
   img = randi([0 1],height,width);     %生成随机图片
   [featureVector,~] = extractHOGFeatures(img,'CellSize',[96 96]);
   trainingSet_(:,i) = featureVector;
   resultSet_(1,i) = 0;
end

TrainingSet = zeros(Row, setSize);
ResultSet = zeros(1, setSize);
for i = 1:setSize
    rand = randi(Col);
    TrainingSet(:,i) = trainingSet_(:,rand);
    ResultSet(1,i) = resultSet_(1,rand);
end

cd(SourcePath);
fp=fopen('TrainingSet.txt','w');
for i = 1:Row
    for j = 1:setSize
        if j == setSize
            fprintf(fp,'%.7f\n',TrainingSet(i, j));
        else
            fprintf(fp,'%.7f\t',TrainingSet(i, j));
        end
    end
end
fclose(fp);
disp('TrainingSet写入成功')

fp=fopen('ResultSet.txt','w');
for i = 1:1
    for j = 1:setSize
        if j == setSize
            fprintf(fp,'%u\n',ResultSet(i, j));
        else
            fprintf(fp,'%u \t',ResultSet(i, j));
        end
    end
end
fclose(fp);
disp('ResultSet写入成功')

Set = [TrainingSet; ResultSet];

