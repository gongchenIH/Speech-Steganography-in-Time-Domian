clc;
clear all; 

% input
cover_dir = '.\CoverDir\cover.wav';
stego_dir = '.\StegoDir\stego.wav';
msg_dir = '.\MsgDir\text.txt';

[audio.data, audio.fs] = audioread(stego_dir);
finfo = audioinfo(cover_dir);
audio.nbit = finfo.BitsPerSample;

fid  = fopen(msg_dir, 'r');
text = fread(fid,'*char')';
fclose(fid);

L_min = 8*1024; 
L_msg = 8*length(text);

s.len  = length(audio.data(:,1));
L2 = floor(s.len/L_msg);
L  = max(L_min, L2);           
nframe = floor(s.len/L);
N = nframe - mod(nframe, 8);   

xsig = reshape(audio.data(1:N*L,1), L, N);  %Divide signal into N segments

r = ones(L,1);

data = num2str(zeros(N,1))';
c = zeros(1,N);
for k=1:N  
    c(k)=sum(xsig(:,k).*r)/L;  
    if c(k)<0
        data(k) = '0';
    else
        data(k) = '1';
    end      
end

msg_bin = reshape(data(1:N), 8, N/8)';
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




