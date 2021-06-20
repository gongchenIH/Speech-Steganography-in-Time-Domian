clc;
clear all; 

% input
cover_dir = '.\CoverDir\cover.wav';
stego_dir = '.\StegoDir\stego.wav';
msg_dir = '.\MsgDir\text.txt';

d0 = 150;    
d1 = 200;     
alpha = 0.5;  
L = 8*1024;   

[audio.data, audio.fs] = audioread(stego_dir);
finfo = audioinfo(cover_dir);
audio.nbit = finfo.BitsPerSample;

fid  = fopen(msg_dir, 'r');
text = fread(fid,'*char')';
fclose(fid);

N = floor(length(audio.data)/L);             %Number of frames
xsig = reshape(audio.data(1:N*L,1), L, N);   %Divide signal into frames
data = char.empty(N, 0);

for k=1:N
	rceps = ifft(log(abs(fft(xsig(:,k)))));  
	if (rceps(d0+1) >= rceps(d1+1))
        data(k) = '0';
	else
        data(k) = '1';
	end
end

m   = floor(N/8);
bin = reshape(data(1:8*m), 8, m)';   
msg = char(bin2dec(bin))';           

len_msg = 0;
if (len_msg~=0)
	msg = msg(1:len_msg);
end

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




