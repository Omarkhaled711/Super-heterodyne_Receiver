%% Clearing workspace
clear all;
close all;

%% Reading the modulating signals and getting the sampling frequency.
%% List of modulating signals
modulating_signals = {"Short_BBCArabic2.wav", "Short_FM9090.wav"};

%% Loop through each modulating signal
for i = 1:length(modulating_signals)
    %% Reading the modulating signal and getting the sampling frequency
    [stereo_signal, FS] = audioread(modulating_signals{i});
    %% Converting from two channel stereo signal to single channel srtream by
    %% adding the two channels (the two columns) of each modulating signal.
    single_channel = stereo_signal(:, 1) + stereo_signal(:, 2);
    %% Increasing the sampling frequency by increasing the no. of samples to
    %% conform the Nyquist criteria for the carrier signals.
    single_channel = interp(single_channel, 10);


    %% Getting the FFT of the modulating signal to get its Baseband bandwidth.
    signal_spectrum = fft(single_channel);
    spectrum_L = length(signal_spectrum);
     %% Adjusting the Axis scale so the signal spectrum is
    %% plotted versus frequncy centered at zero to get the BW of the positive side of the spectrum.
    k = -spectrum_L/2:spectrum_L/2-1;

    [peaks, bandwidth, BW] = plot_spectrum(k, FS, spectrum_L, signal_spectrum, ['Signal ', num2str(i), ' Spectrum']);
    %% Generating carrier signals
    Fc = 100000 + (i - 1) * 55000;  % Adjust frequency for each signal
    Ts = 1/(10 * FS);
    L = length(single_channel);
    t = (0:L-1) * Ts;
    message_carrier = cos(2 * pi * Fc * t);

    %% Mixing the modulating signal with the carrier signal by multiplying them.
    AM_signal = single_channel .* message_carrier';

    %% Create a new figure for each AM signal
    figure;
    %% Plotting AM signal
    plot(t, AM_signal);
    title(['AM Signal ', num2str(i)]);
    xlabel('Time');
    ylabel('Amplitude');
end
   
%% Function: plot_spectrum
%% Description:
    %% This function plots the spectrum of a given signal and calculates
    %% relevant information such as peaks, bandwidth, and BW.
%% Return: peaks, bandwidth, and BW.
function [peaks, bandwidth, BW] = plot_spectrum(k, FS, spectrum_L, signal_spectrum, title_str)
    threshold_dB = -3;
    threshold = 10^(threshold_dB / 20);
    peaks = find(abs(signal_spectrum) > max(abs(signal_spectrum)) * threshold);
    bandwidth = max(k(peaks));
    BW = bandwidth * 10 * FS / spectrum_L;
    
    figure;
    plot(k * 10 * FS / spectrum_L, fftshift(abs(signal_spectrum)));
    title(title_str);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    fprintf('%s Bandwidth: %.2f Hz\n', title_str, BW);
end
