colorization��ɫ�㷨
���裺
###### S1.�Բ���ͼ�����SLIC�����طָ� ########
����ͼ�񣬾���һϵ��Ԥ����֮�����ɱ�ע�ĳ����طָ��ͬ��superpixel�ò�ͬ����������ʾ
����������S1_SLIC_Matlab���readme˵��

###### S2.�Զ�����scribble ################
����Ҷ�ͼ���Զ�����scribble
new_guid.m ���ļ�
areaall Ԥ�и�ͼ��
edged ��ȡͼ���Ե
seg ����ͼ�۵�����ָ�
ins ����scribble����

###### S3.����VGG��ȡͼ������ #############
generatecp.m���ȶ�ͼ�����Ԥ�������Ҷ�ͼ���scirbble��ֵͼ���ϣ��õ�����scribble�ĻҶ�ͼ��
getfeature.m����ȡԭʼ�Ҷ�ͼ��ʹ���scribble�Ҷ�ͼ���VGG��5������

###### S4.�Զ�ɫ������ ############
��S4_colorization�ļ�������ڶ���ɫ�����ӷ���
gettestdata.m ��ͼ�������������һ���µ��ļ���������
levin.m **
solver=2ʹ��matlab��\�ķ�������ɫ�����ӣ���Ҫ����levin�Ҷ���������
solver=3ʹ��matlab��\�ķ�������ɫ�����ӣ���Ҫ����VGG��ȡ����������
main_trytorun.m ʧ�ܵ�ʹ��SLIC���ƽ���ɫ������
SLIC_colorization.m ʹ��SLIC���ƽ���ɫ������ **
colorization.m �Զ���ͼƬ��ʹ��SCIC���ƣ����ǲ��øĽ���scribble�����㷨����ɫ������ **
single_colorization.m�Ե���ͼƬ��ʹ��SCIC���ƣ����ǲ��øĽ���scribble�����㷨����ɫ������
demo.m ����ʹ��SLIC��������ɫ�����ӵ��м�����������100��200��300��400��500ʱ���м�Ⱦɫ��� **
others�ļ��� SLIC���ù���
���д��� **���ļ���ʾ��ע�ͣ�������ļ���Ϊ����Щ���ƣ��˲��ٶ���ע��

###### S5.�Խ�����з��� ######
res_evaluate.m ��ɫ����PSNR��������RGB����ͨ����PSNRȡƽ��
BATCHres_evaluate.m ����ͼƬ�Ĳ�ɫ����PSNR��������RGB����ͨ����PSNRȡƽ��
ssimres.m ͼ���ssimָ������������ԣ���δ���뵽�����еĽ�������С�



imgRoot = '../dataset/newdata/��;%ԭʼͼ���ļ�����
imgOrigin = '../dataset/graynewdata/��;%����ͼ�����ļ���
imgDest = '../dataset/sunscribble/��;%ͼ����м����������scribble�� VGG������
imnames=dir([imgRoot '*' '.bmp��]);ɨ��ԭʼ�ļ��ļ���