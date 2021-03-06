function [ highway, fall, traffic ] = LoadDatabases( cfg )
%LOADDATABASES Summary of this function goes here
%   Detailed explanation goes here

HWtrain = LoadImages(cfg.highway.inputPath, cfg.highway.trainFrames, 'in', 'jpg');
HWtest = LoadImages(cfg.highway.inputPath, cfg.highway.testFrames, 'in', 'jpg');
HWgt = LoadImages(cfg.highway.gtPath, cfg.highway.testFrames, 'gt', 'png');
HWseqName = 'highway';
HWnumTrainingFrames = length(cfg.highway.trainFrames);
HWpathVideo = [cfg.pathToHighway 'video.avi'];

Ftrain = LoadImages(cfg.fall.inputPath, cfg.fall.trainFrames, 'in', 'jpg');
Ftest = LoadImages(cfg.fall.inputPath, cfg.fall.testFrames, 'in', 'jpg');
Fgt = LoadImages(cfg.fall.gtPath, cfg.fall.testFrames, 'gt', 'png');
FseqName = 'fall';
FnumTrainingFrames = length(cfg.fall.trainFrames);
FpathVideo = [cfg.pathToFall 'video.avi'];

Ttrain = LoadImages(cfg.traffic.inputPath, cfg.traffic.trainFrames, 'in', 'jpg');
Ttest = LoadImages(cfg.traffic.inputPath, cfg.traffic.testFrames, 'in', 'jpg');
Tgt = LoadImages(cfg.traffic.gtPath, cfg.traffic.testFrames, 'gt', 'png');
TseqName = 'traffic';
TnumTrainingFrames = length(cfg.traffic.trainFrames);
TpathVideo = [cfg.pathToTraffic 'video.avi'];


if cfg.grayscale
    highway.train = cellfun(@(c) double(rgb2gray(c)), HWtrain, 'UniformOutput', false);
    highway.test = cellfun(@(c) double(rgb2gray(c)), HWtest, 'UniformOutput', false);
    highway.gt = HWgt;
    highway.seqName = HWseqName;
    highway.numTrainingFrames = HWnumTrainingFrames;
    highway.pathVideo = HWpathVideo ;
    
    fall.train = cellfun(@(c) double(rgb2gray(c)), Ftrain, 'UniformOutput', false);
    fall.test = cellfun(@(c) double(rgb2gray(c)), Ftest, 'UniformOutput', false);
    fall.gt = Fgt;
    fall.seqName = FseqName;
    fall.numTrainingFrames = FnumTrainingFrames;
    fall.pathVideo = FpathVideo ;
    
    traffic.train = cellfun(@(c) double(rgb2gray(c)), Ttrain, 'UniformOutput', false);
    traffic.test = cellfun(@(c) double(rgb2gray(c)), Ttest, 'UniformOutput', false);
    traffic.gt = Tgt;
    traffic.seqName = TseqName;
    traffic.numTrainingFrames = TnumTrainingFrames;
    traffic.pathVideo = TpathVideo ;
end

% if cfg.hsv
%     [highway{1}.train, highway{2}.train, highway{3}.train] = obtainHSV(HWtrain);
%     [highway{1}.test, highway{2}.test, highway{3}.test] = obtainHSV(HWtest);
%     highway{1}.gt = HWgt; highway{2}.gt = HWgt; highway{3}.gt = HWgt;
%     highway{1}.seqName = HWseqName; highway{2}.seqName = HWseqName; highway{3}.seqName = HWseqName;
%     
%     [fall{1}.train, fall{2}.train, fall{3}.train] = obtainHSV(Ftrain);
%     [fall{1}.test, fall{2}.test, fall{3}.test] = obtainHSV(Ftest);
%     fall{1}.gt = Fgt; fall{2}.gt = Fgt; fall{3}.gt = Fgt;
%     fall{1}.seqName = FseqName; fall{2}.seqName = FseqName; fall{3}.seqName = FseqName;
%     
%     
%     [traffic{1}.train, traffic{2}.train, traffic{3}.train] = obtainHSV(Ttrain);
%     [traffic{1}.test, traffic{2}.test, traffic{3}.test] = obtainHSV(Ttest);
%     traffic{1}.gt = Tgt; traffic{2}.gt = Tgt; traffic{3}.gt = Tgt;
%     traffic{1}.seqName = TseqName; traffic{2}.seqName = TseqName; traffic{3}.seqName = TseqName;
% 
% end

if cfg.removeShadow
    highway.hsv.train = cellfun(@(c) double(rgb2hsv(c)), HWtrain, 'UniformOutput', false);
    highway.hsv.test = cellfun(@(c) double(rgb2hsv(c)), HWtest, 'UniformOutput', false);
    
    fall.hsv.train = cellfun(@(c) double(rgb2hsv(c)), Ftrain, 'UniformOutput', false);
    fall.hsv.test = cellfun(@(c) double(rgb2hsv(c)), Ftest, 'UniformOutput', false);
    
    traffic.hsv.train = cellfun(@(c) double(rgb2hsv(c)), Ttrain, 'UniformOutput', false);
    traffic.hsv.test = cellfun(@(c) double(rgb2hsv(c)), Ttest, 'UniformOutput', false);
end


end
