clc;
clear all; 

% input
cover_dir = '.\CoverDir\cover.wav';
stego_dir = '.\StegoDir\stego.wav';
msg_dir = '.\MsgDir\text.txt';
L = 1024;

[audio.data, audio.fs] = audioread(stego_dir);
finfo = audioinfo(cover_dir);
audio.nbit = finfo.BitsPerSample;

fid  = fopen(msg_dir, 'r');
text = fread(fid,'*char')';
fclose(fid);

m   = 8*length(text);             
x   = audio.data(1:L,1);      
Pha = angle(fft(x));       

data = char(zeros(1,m));   
for k=1:m
	if Pha(L/2-m+k)>0
    	data(k)='0';
    else
        data(k)='1';
	end
end

msg_bin = reshape(data(1:m), 8, m/8)';
msg = char(bin2dec(msg_bin))';

% check message
y = reshape(dec2bin(uint8(text),8)', 1, 8*length(text));
x = reshape(dec2bin(uint8(msg),8)', 1, 8*length(msg));
len = min(length(x), length(y));   
err_t = 0;
for i=1:len
    check = (x(i)~= y(i));
    err_t = err_t + check;
end
err = 100*(err_t/len);


fprintf('Extrcted Text: %s\n', msg);
fprintf('Extrcted bit error rate : %d%%\n', err);




