clc;
clear all;

fprintf('Extracting using matlab code');

%% Extract
stego_dir = '.\StegoDir\stego.wav';
msg_extract_dir = '.\MsgDir\text_extract.txt';
key = 'PasswordGC666';

fid=fopen(stego_dir,'r'); 
header=fread(fid,40,'uint8=>char');
data_size=fread(fid,1,'uint32');
[data, count]=fread(fid,inf,'uint16');
fclose(fid);

lsb=1;
key_extract=bitget(data(1:8),lsb)';

if  key_extract == de2bi( mod( sum( double(key)), 1024),8)
    % message length
    len_bin=zeros(20,1);
    m_bin=zeros(10,1);
    n_bin=zeros(10,1);
    m_bin(1:10)=bitget(data(9:18),lsb);
    n_bin(1:10)=bitget(data(19:28),lsb);    
    len=bi2de(m_bin')*bi2de(n_bin');
    % extract message
    msg_bin=zeros(len,1);   
    msg_bin(1:len)=bitget(data(29:28+len),lsb);
    msg_bin_re=reshape(msg_bin,len/8,8);
    msg_double=bi2de(msg_bin_re); 
    % convert message to char
    msg=char(msg_double)';
    % write message to file
    fid1=fopen(msg_extract_dir,'w'); 
    fwrite(fid1,msg);
    fclose(fid1);
else
    warning('Key is wrong or message is corrupted!');
    out = [];
end

fprintf('\nMessage extract done');
fprintf('\nExtracted message: %s\n', msg);

