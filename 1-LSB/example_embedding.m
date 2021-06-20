clc;
clear all;

fprintf('Embedding using matlab code');
MEXstart = tic;
        
% input
cover_dir = '.\CoverDir\cover.wav';
stego_dir = '.\StegoDir\stego.wav';
msg_dir = '.\MsgDir\text.txt';
key = 'PasswordGC666';

%% Cover part
% Skip 44 bytes, the last part is embedding lacation. Header = 1:40, Length  = 41:43, Data = 44:end
cover_f = fopen(cover_dir,'r');
wave_header = fread(cover_f,40,'uint8=>char');
wave_len = fread(cover_f,1,'uint32');
[cover, cover_len] = fread(cover_f,inf,'uint16');
fclose(cover_f);

%% Message part
msg_f = fopen(msg_dir,'r'); 
msg_text = fread(msg_f,'*char')';

%[msg, msg_len] = fread(msg_f,'ubit1') ; 
fclose(msg_f);
% covert to binary 
%msg_double = double(msg_text);       
msg_bin = de2bi(double(msg_text),8);  
[m,n] = size(msg_bin);          
msg_bin_v = reshape(msg_bin,m*n,1);     
row_len = de2bi(m,10)';
col_len = de2bi(n,10)';
msg_bin_len = length(msg_bin_v); 
msg_len_bin=de2bi(msg_bin_len,20)';       

%% Embedding part
key_bin = de2bi( mod( sum( double(key)), 1024),8)';
lsb = 1;
if msg_bin_len+28 > cover_len 
    error('Embeding payload is larger than cover, please select another wave file.') ;
end

%Key is encoded(1:8)
stego = cover;
stego(1:8)=bitset(stego(1:8), lsb, key_bin(1:8));
%Length of message is encoded (9:28)
stego(9:18)=bitset(stego(9:18), lsb, row_len(1:10));
stego(19:28)=bitset(stego(19:28), lsb, col_len(1:10));                              
%Message is encoded (29:end)
stego(29:28+msg_bin_len)=bitset(stego(29:28+msg_bin_len), lsb, msg_bin(1:msg_bin_len)');

%saving stego file 
stego_f = fopen(stego_dir,'w');
fwrite(stego_f, wave_header,'uint8');
fwrite(stego_f, wave_len,'uint32');
fwrite(stego_f, stego,'uint16');
fclose(stego_f);

MEXend = toc(MEXstart);
fprintf('\n- DONE');

figure;
[y1,Fs] = audioread(cover_dir);
x1 = (0:length(y1) - 1)/Fs;
subplot(3, 1, 1);
plot(x1, y1);
axis([0 max(x1) -1 1]);
xlabel('Time / (s)');ylabel('Amplitude');title('cover audio');

[y2,Fs] = audioread(stego_dir);
x2 = (0:length(y2)-1)/Fs;
subplot(3, 1, 2);
plot(x2, y2);
axis([0 max(x2) -1 1]);
xlabel('Time / (s)');ylabel('Amplitude');title('stego audio');

subplot(3, 1, 3);
imshow(double(stego(1:msg_bin_len)') - double(cover(1:msg_bin_len)')); title('embedding changes(white)');

fprintf('\nWave embedded in %.2f seconds, change rate: %.4f\n', MEXend, sum(cover(:)~=stego(:))/numel(cover));

