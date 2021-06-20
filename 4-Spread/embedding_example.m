clc;
clear all; 

% input
L_min = 8*1024; %Minimum segment length
cover_dir = '.\CoverDir\cover.wav';
stego_dir = '.\StegoDir\stego.wav';
msg_dir = '.\MsgDir\text.txt';

[audio.data, audio.fs] = audioread(cover_dir);
finfo = audioinfo(cover_dir);
audio.nbit = finfo.BitsPerSample;

msg_fid  = fopen(msg_dir, 'r');
text = fread(msg_fid,'*char')';
fclose(msg_fid);

[s.len, s.ch] = size(audio.data);

msg_bit = reshape(dec2bin(uint8(text),8)', 1, 8*length(text));     
L2  = floor(s.len/length(msg_bit));  %Length of segments
L   = max(L_min, L2);           
nframe = floor(s.len/L);
N = nframe - mod(nframe, 8);         
if (length(msg_bit) > N)
    warning('Message is too long, is being cropped...');
    msg_bits = msg_bit(1:N);
else
    msg_bits = [msg_bit, num2str(zeros(N-length(msg_bit), 1))'];
end

r = ones(L,1);
pr = reshape(r * ones(1,N), N*L, 1);             
alpha = 0.005;                                   

len = length(msg_bits);                          
encbit = str2num(reshape(msg_bits, len, 1))';    
m_sig  = reshape(ones(L,1)*encbit, len*L, 1);    

K=256; % 
K = K - mod(K, 4);

n   = (0:K-1)';
han_window = .5*(1-cos((2*pi*n)/(K-1)));
c = conv(m_sig, han_window);                     %Hanning windowing

wnorm  = c(K/2+1:end-K/2+1) / max(abs(c));       %Normalization
w_sig  = wnorm * (1+1)-1;                        
m_sig  = m_sig * (1+1)-1;                        

stego = audio.data;
stegoT = audio.data(1:N*L,1) + alpha * m_sig.*pr; 
stego(:,1) = [stegoT; audio.data(N*L+1:s.len,1)];   

audiowrite(stego_dir, stego, audio.fs);


