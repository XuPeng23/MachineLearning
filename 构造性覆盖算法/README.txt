Matlab Example

	运行TestCCA.m文件
	
	导入的In.mat和Label.mat为处理过的数据集
	In.mat是去掉标签的数据，Label.mat为标签


	CCA(Input2,Label)		基本CCA算法
	CCA(Input2,Label)		基于投票的改进VCCA算法
	normalization();              	归一化
	dimensionRaise();		数据升维

	TestCCA.m		主程序