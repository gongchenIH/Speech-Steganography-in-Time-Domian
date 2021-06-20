clc;
clear all; 

% input
L = 1024;
cover_dir = '.\CoverDir\cover.wav';
stego_dir = '.\StegoDir\stego.wav';
msg_dir = '.\MsgDir\text.txt';

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

data = audio.data(:,1);
data_bin = reshape(dec2bin(uint8(text),8)', 1, 8*length(text));
I = length(data);
m = length(data_bin);  % Length of bit sequence to hide
N = floor(I/L);        % Number of frames
seg = reshape(data(1:N*L,1), L, N);  % Dividing audio file into frames

w = fft(seg);          % FFT of each segment
Pha = angle(w);        % Phases matrix including each segments
Amp = abs(w);            % Amplitude matrix including each segments

% Calculating phase differences of adjacent segments
DeltaPhi = zeros(L,N);
for k=2:N
	DeltaPha(:,k)=Pha(:,k)-Pha(:,k-1); 
end

% Binary data is represented as {-pi/2, pi/2} and stored in PhaData
PhaData = zeros(1,m);
for k=1:m
	if data_bin(k) == '0'
        PhaData(k) = pi/2;
    else
        PhaData(k) = -pi/2;
	end
end

% PhaData is written onto the middle of first phase matrix
Pha_new(:,1) = Pha(:,1);
Pha_new(L/2-m+1:L/2,1) = PhaData;             % Hermitian symmetry
Pha_new(L/2+1+1:L/2+1+m,1) = -flip(PhaData);  % Hermitian symmetry

% Re-creating phase matrixes using phase differences
for k=2:N
	Pha_new(:,k) = Pha_new(:,k-1) + DeltaPhi(:,k);
end

% Reconstructing the sound signal by applying the inverse FFT
z = real(ifft(Amp .* exp(1i*Pha_new)));    % Using Euler's formula
snew = reshape(z, N*L, 1);
data_s  = [snew; data(N*L+1:I)];             % Adding rest of signal

audiowrite(stego_dir, data_s, audio.fs);


