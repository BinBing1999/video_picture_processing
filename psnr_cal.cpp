#include <iostream>
#include <string>

using namespace std;

//参数输入格式：原始视频路径 需评估的视频路径 宽 高 需比较的帧数，共4个参数
void main(int argc, char* argv[])
{
	if (strcmp(argv[1], "-h") == 0)
	{
		cout << "参数输入格式：原始视频路径 需评估的视频路径 宽 高 需比较的帧数" << endl;
		cout << "Example: PSNR org.yuv dec.yuv 1024 768 9" << endl;
		return;
	}
	//psnr
	float psnr = 0.0;
	//视频分辨率
	int width = atoi(argv[3]);
	int height = atoi(argv[4]);
	//帧数
	int num = atoi(argv[5]);

	//yuv视频
	FILE* org, * synth;
	if (width > 0 && height > 0 && num > 0)
	{
		cout << "------------视频相关信息-----------" << endl;
		cout << "视频分辨率:" << width << "x" << height << endl;
		cout << "原始视频路径：" << argv[1] << endl;
		cout << "需测量视频路径：" << argv[2] << endl;
		cout << "计算帧数：" << num << endl;
		//打开视频文件
		if ((org = fopen(argv[1], "rb")) == NULL)
		{
			cout << "视频文件路径不对\n" << endl;
			return;
		}
		if ((synth = fopen(argv[2], "rb")) == NULL)
		{
			cout << "视频文件路径不对\n" << endl;
			return;
		}
		//分配一帧Y分量内存
		unsigned char* m_orgY = new unsigned char[width * height];
		unsigned char* m_synthY = new unsigned char[width * height];
		for (int i = 0; i < num; i++)
		{
			if ((width * height) != fread(m_orgY, sizeof(unsigned char), width * height, org))
			{
				cout << "读取文件失败！" << endl;
				//释放内存
				delete m_orgY;
				delete m_synthY;
				fclose(org); fclose(synth);//关闭文件
				return;
			}
			if ((width * height) != fread(m_synthY, sizeof(unsigned char), width * height, synth))
			{
				cout << "读取文件失败！" << endl;
				//释放内存
				delete m_orgY;
				delete m_synthY;
				fclose(org); fclose(synth);//关闭文件
				return;
			}
			float mse = 0.0;//MSE
			float tmp_psnr;//每一帧的PSNR
			char delta;
			for (int j = 0; j < width * height; j++)
			{
				delta = *(m_orgY + j) - *(m_synthY + j);
				mse += (float)(delta * delta);
			}
			mse /= (width * height);
			if (mse < 0.000001)
				tmp_psnr = 99.9999;
			else
				tmp_psnr = 10 * log10(65025.0 / mse);
			psnr += tmp_psnr;
			printf("Frame %d: %.4fdB\n", i, tmp_psnr);
			if (fseek(org, (width * height) >> 1, SEEK_CUR) < 0)
			{
				cout << "文件帧数设置错误！" << endl;
				return;
			}
			if (fseek(synth, (width * height) >> 1, SEEK_CUR) < 0)
			{
				cout << "文件帧数设置错误！" << endl;
				return;
			}
		}
		cout << "---------PSNR平均值------------" << endl;
		printf("总帧数：%d帧，PSNR:%.4fdB\n", num, psnr / num);
		//释放内存
		delete m_orgY;
		delete m_synthY;
		fclose(org); fclose(synth);//关闭文件
	}
	else
	{
		cout << "输入数据不合法，参数输入格式：原始视频路径 需评估的视频路径 宽 高" << endl;
	}
}