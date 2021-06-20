clc;
clear all; 

% input
cover_dir = '.\CoverDir\cover.wav';
stego_dir = '.\StegoDir\stego.wav';
msg_dir = '.\MsgDir\text.txt';
%d0     : Delay rate for bit0
%d1     : Delay rate for bit1
%alpha  : Echo amplitude
%L      : Length of frame
d0 = 150;     %Delay rate for bit0
d1 = 200;     %Delay rate for bit1
alpha = 0.5;  %Echo amplitude
L = 8*1024;   %Length of frame

[audio.data, audio.fs] = audioread(cover_dir);
finfo = audioinfo(cover_dir);
audio.nbit = finfo.BitsPerSample;

msg_fid  = fopen(msg_dir, 'r');
text = fread(msg_fid,'*char')';
fclose(msg_fid);

data_c = audio.data;
[s.len, s.ch] = size(data_c);

text_bin  = dec2bin(uint8(text),8);
text_bin = reshape(text_bin', 1, 8*length(text));

nframe = floor(s.len/L);
N = nframe - mod(nframe,8);      %Number of frames (for 8 bit)

if (length(text_bin) > N)
    fprintf('Message is too long, it will be cropped!\n');
    bits = text_bin(1:N);
else
    fprintf('Message is being zero padding.\n');
    bits = [text_bin, num2str(zeros(N-length(text_bin), 1))'];
end

k0 = [zeros(d0, 1); 1]*alpha;        %Echo kernel for bit0
k1 = [zeros(d1, 1); 1]*alpha;        %Echo kernel for bit1
echo_zro = filter(k0, 1, data_c);    %Echo signal for bit0
echo_one = filter(k1, 1, data_c);    %Echo signal for bit1
%% Embedding part
N = length(bits);                            %Number of segments
encbit = str2num(reshape(bits, N, 1))';      %char -> double
m_sig  = reshape(ones(L,1)*encbit, N*L, 1);  %Mixer signal
n   = (0:L-1)';
han_window = .5*(1-cos((2*pi*n)/(L-1)));
c = conv(m_sig, han_window);            %Hanning windowing
wnorm  = c(256/2+1:end-256/2+1) / max(abs(c));   %Normalization
w_sig  = wnorm * (1-0)+0;        %Adjusting bounds
m_sig  = m_sig * (1-0)+0;        %Adjusting bounds
mix = m_sig * ones(1, s.ch);     %Adjusting up to channel size
                   
data_s = data_c(1:N*L, :) + echo_zro(1:N*L, :) .* abs(mix-1)+echo_one(1:N*L, :) .* mix;
data_s = [data_s; data_c(N*L+1:s.len, :)];   %Rest of the signal

audiowrite(stego_dir, data_s, audio.fs);

