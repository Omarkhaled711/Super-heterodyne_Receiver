%%Reading the modulating signals and getting the sampling frequency.
modulating_signal_1="Short_BBCArabic2.wav";  
modulating_signal_2="Short_FM9090.wav";  

[stereo_signal_1, FS_1] = audioread(modulating_signal_1);
[stereo_signal_2, FS_2] = audioread(modulating_signal_2);

%%Converting from two channel stereo signal to single channel srtream by
%%adding the two channels (the two columns) of each modulating signal.
single_channel_1=stereo_signal_1(:,1)+stereo_signal_1(:,2);
single_channel_2=stereo_signal_2(:,1)+stereo_signal_2(:,2);

%%Increasing the sampling frequency by increasing the no. of samples to
%%conform the Nyquist criteria for the carrier signals.
single_channel_1=interp(single_channel_1,10);
single_channel_2=interp(single_channel_2,10);

%%Getting the FFT of the modulating signal to get it's Baseband bandwidth.
%%%First message
signal_spectrum_1=fft(single_channel_1);
spectrum_L_1=length(signal_spectrum_1);
k_1=-spectrum_L_1/2:spectrum_L_1/2-1;                          %%Adjusting the Axis scale so the signal spectrum is 
subplot(2,1,1)                                                 %%plotted versus frequncy centered at zero to get the BW of the positive side of the spectrum.
plot(k_1*10*FS_1/spectrum_L_1,fftshift(abs(signal_spectrum_1)))   
title("Signal 1 spectrum")                      
xlabel("freq. (Hz)")
ylabel("Magnitude")

%%%Second message
signal_spectrum_2=fft(single_channel_2);          
spectrum_L_2=length(signal_spectrum_2);
k_2=-spectrum_L_2/2:spectrum_L_2/2-1; 
subplot(2,1,2)
plot(k_2*10*FS_2/spectrum_L_2,fftshift(abs(signal_spectrum_2)))
title("Signal 2 spectrum")                      
xlabel("freq. (Hz)")
ylabel("Magnitude")


%%Getting the BW 
%%%BW of the first message
threshold_dB = -3;  
threshold = 10^(threshold_dB / 20);  
peaks_1 = find(abs(signal_spectrum_1) > max(abs(signal_spectrum_1)) * threshold);
bandwidth_1 = max(k_1(peaks_1));
BW_1=bandwidth_1*10*FS_1/spectrum_L_1;
%%%BW of the second message
peaks_2 = find(abs(signal_spectrum_2) > max(abs(signal_spectrum_2)) * threshold);
bandwidth_2 = max(k_2(peaks_2));
BW_2=bandwidth_2*10*FS_2/spectrum_L_2;


%%Generating the carrier signals.
  %%%Carrier of the first message(n=0).
Fc_1=100000;
Ts_1=1/(10*FS_1);                              %%Getting the Ts to Generate the carrier with the same sampling frequency of the message.
L_1=length(single_channel_1);                  %%Getting the length of the message signal to generate the carreir with the same no. of samples.
t_1=(0:L_1-1)*Ts_1;
message_1_carrier=cos(2*pi*Fc_1*t_1);

  %%%Carrier of the second message(n=1).
Fc_2=155000;
Ts_2=1/(10*FS_2);
L_2=length(single_channel_2);
t_2=(0:L_2-1)*Ts_2;
message_2_carrier=cos(2*pi*Fc_2*t_2);

%%Mixing the modulating signal with the carrier signal by multiplying them.
AM_signal_1=single_channel_1 .* message_1_carrier';
figure;
subplot(2,1,1)
plot(t_1,AM_signal_1)
title("AM signal 1")                      
xlabel("time")
ylabel("Amplitude")

AM_signal_2=single_channel_2 .* message_2_carrier';
subplot(2,1,2)
plot(t_2,AM_signal_2)
title("AM signal 2")                      
xlabel("time")
ylabel("Amplitude")