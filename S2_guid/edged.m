path=strcat(img,'r.bmp');
[edge_gx,edge_gy, edge_norm,ss_canny,life_time_map, best_scale_nb] = make_scale_spaces(path, 10);
path=strcat(img,'et.bmp');
imwrite(life_time_map/10,path);
path=strcat(img,'e.bmp');
imwrite((life_time_map==10),path);