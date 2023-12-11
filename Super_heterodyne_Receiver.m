%% Clearing workspace
clear all;
close all;

%% List of modulating signals
modulating_signals = {"Short_BBCArabic2.wav", "Short_FM9090.wav"};

%% Loop through each modulating signal
for i = 1:length(modulating_signals)
    %% Reading the modulating signal and getting the sampling frequency.
    [stereo_signal, FS] = audioread(modulating_signals{i});
    %% Converting from two channel stereo signal to single channel srtream by
    %% adding the two channels (the two columns) of each modulating signal.
    single_channel = stereo_signal(:, 1) + stereo_signal(:, 2);
    
    %% Getting the FFT of the modulating signal to get its Baseband bandwidth.
    signal_spectrum = fft(single_channel); 
    spectrum_L = length(signal_spectrum);
    %% Adjusting the Axis scale so the signal spectrum is
    %% plotted versus frequncy centered at zero to get the BW of the positive side of the spectrum.
    k = -spectrum_L/2:spectrum_L/2-1;

    [peaks, bandwidth, BW] = plot_spectrum(k, FS, spectrum_L, signal_spectrum, ['Signal ', num2str(i), ' Spectrum']);
    %% Increasing the sampling frequency by increasing the no. of samples to
    %% conform the Nyquist criteria for the carrier signals.
    Upsampled_signal = interp(single_channel, 10);
   
    %% Generating carrier signals
    Fc = 100000 + (i - 1) * 55000;  % Adjust frequency for each signal
    Ts = 1/(10 * FS);
    L = length(Upsampled_signal);
    t = (0:L-1) * Ts;
    Carrier_signal = cos(2 * pi * Fc * t);

    %% Mixing the modulating signal with the carrier signal by multiplying them.
    AM_signal = Upsampled_signal .* Carrier_signal';

    %% Create a new figure for each AM signal
    figure;
    %% Plotting AM signal
    plot(t, AM_signal);
    title(['AM Signal ', num2str(i)]);
    xlabel('Time');
    ylabel('Amplitude');

    %% Design and apply band-pass filter using fdesign
    received_signal = apply_bandpass_filter(AM_signal, Fc, 10 * FS, BW);
    %% Create a new figure for each received signal
    figure;
    %% Plotting received signal after band-pass filtering
    plot(t, received_signal);
    title(['Received Signal after Band-Pass Filtering - Signal ', num2str(i)]);
    xlabel('Time');
    ylabel('Amplitude');    
end
   
%% Function: plot_spectrum
%% Description:
    %% This function plots the spectrum of a given signal and calculates
    %% relevant information such as peaks, bandwidth.
%% Return: peaks, bandwidth, and BW.
function [peaks, bandwidth, BW] = plot_spectrum(k, FS, spectrum_L, signal_spectrum, title_str)
    threshold_dB = -3;
    threshold = 10^(threshold_dB / 20);
    peaks = find(abs(signal_spectrum) > max(abs(signal_spectrum)) * threshold);
    bandwidth = max(k(peaks));
    BW = bandwidth * FS / spectrum_L;
    
    figure;
    plot(k * FS / spectrum_L, fftshift(abs(signal_spectrum)));
    title(title_str);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    fprintf('%s Bandwidth: %.2f Hz\n', title_str, BW);
end

%% Function: apply_bandpass_filter
%% Description:
    % This function applies a band-pass filter to the input signal using
    % the fdesign approach. It designs a band-pass filter with the
    % specified center frequency (Fc), upsampled frequency (Fs_filter), and
    % bandwidth (BW), and then applies the filter to the input signal.
%% Return:
    % - received_signal: The filtered signal after applying the band-pass filter.

function received_signal = apply_bandpass_filter(input_signal, Fc, Fs_filter, BW)
    % Design the band-pass filter using fdesign
    filter_order = 100;  % Adjust as needed

    % Create the filter design object
    fd = fdesign.bandpass('N,Fc1,Fc2', filter_order, Fc - BW/2, Fc + BW/2, Fs_filter);
    
    % Design the filter
    Hd = design(fd, 'fir', 'window', 'hamming');
    
    % Visualize the frequency response
    fvtool(Hd, 'Color', 'White');

    % Apply the filter to the input signal
    received_signal = filter(Hd, input_signal);
end