function [HS_data,hdr_info] = auto_load_HS(filename)

data_name = filename;
hdr_name = [data_name(1:size(data_name,2)-4),'.hdr'];

HS_data = readenvi_multib(data_name);
hdr_info = read_envihdr(hdr_name);

end