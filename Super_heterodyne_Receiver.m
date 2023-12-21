%% Clearing workspace
clear all;
close all;

%% List of modulating signals
modulating_signals = {"Short_BBCArabic2.wav", "Short_FM9090.wav"};
lengths=zeros(length(modulating_signals),1);
AM_signal_padded={};
%% Loop through each modulating signal
for i = 1:length(modulating_signals)
    %% Reading the modulating signal and getting the sampling frequency.
    [stereo_signal, FS] = audioread(modulating_signals{i});
    %% Converting from two channel stereo signal to single channel stream by
    %% adding the two channels (the two columns) of each modulating signal.
    single_channel = stereo_signal(:, 1) + stereo_signal(:, 2);
    
    %% Getting the FFT of the modulating signal to get its Baseband bandwidth.
    signal_spectrum = fft(single_channel); 
    spectrum_L = length(signal_spectrum);
    %% Adjusting the Axis scale so the signal spectrum is
    %% plotted versus frequency centered at zero to get the BW of the positive side of the spectrum.
    k = -spectrum_L/2:spectrum_L/2-1;

    [peaks, bandwidth, BW] = plot_spectrum(k, FS, spectrum_L, signal_spectrum, ['Signal ', num2str(i), ' Spectrum']);
    fprintf('%s Bandwidth: %.2f Hz\n', ['Signal ', num2str(i), ' Spectrum'], BW);
    %% Increasing the sampling frequency by increasing the no. of samples to
    %% conform the Nyquist criteria for the carrier signals.
    Upsampled_signal = interp(single_channel, 20);
   
    %% Generating carrier signals
    Fc = 100000 + (i - 1) * 55000;  % Adjust frequency for each signal
    Ts = 1/(20 * FS);
    L_upsampled = length(Upsampled_signal);
    t_upsampled = (0:L_upsampled-1) * Ts;
    Carrier_signal = cos(2 * pi * Fc * t_upsampled);

    %% Mixing the modulating signal with the carrier signal by multiplying them.
    AM_signal = Upsampled_signal .* Carrier_signal';
    % Calculate and plot the AM signal spectrum
    AM_signal_spectrum = fft(AM_signal);
    k_upsampled = -L_upsampled/2 : L_upsampled/2 - 1;
    
    [~, ~, ~] = plot_spectrum(k_upsampled, 20 * FS, L_upsampled, AM_signal_spectrum, ['AM Signal spectrum - Signal  ', num2str(i)]);
    %% Create a new figure for each AM signal
    figure;
    %% Plotting AM signal in the time domain
    plot(t_upsampled, AM_signal);
    title(['AM Signal ', num2str(i)]);
    xlabel('Time');
    ylabel('Amplitude');
    
    %%get the maximum length of the modulated signals to pad the short signals
    %%with zeros so they have equal length to add them for multiplexing
    lengths(i,1)=length(AM_signal);
    L_padded=max(lengths);
    AM_signal_padded = [AM_signal; zeros( L_padded - length(AM_signal), 1)];
    AM_signals_padded{i} = AM_signal_padded;
end
%%Add the AM signals
transmitted_signal=AM_signals_padded{1}+AM_signals_padded{2};
 % Calculate and plot the transmitted signal spectrum
    transmitted_signal_spectrum = fft(transmitted_signal);
    k_padded = -L_padded/2 : L_padded/2 - 1;
    [~, ~, ~] = plot_spectrum(k_padded, 20 * FS, L_padded, transmitted_signal_spectrum, 'transmitted Signal');
for i=1:length(modulating_signals)
    Fc = 100000 + (i - 1) * 55000;
    %% Design and apply band-pass filter using fdesign
    received_signal = apply_bandpass_filter(transmitted_signal, Fc, 20 * FS, BW);
   
    % Calculate and plot the received RF signal spectrum after band-pass filtering
    received_signal_spectrum = fft(received_signal);
    k_padded = -L_padded/2 : L_padded/2 - 1;
    
    [~, ~, ~] = plot_spectrum(k_padded, 20 * FS, L_padded, received_signal_spectrum, ['Received RF Signal spectrum after Band-Pass Filtering - Signal  ', num2str(i)]);
    
    
    %%Generate the IF stage carrier
    t_padded = (0:L_padded-1) * Ts;
    IF = 27500;
    Flo = Fc + IF;  
    IF_stage_carrier = cos(2 * pi * Flo * t_padded);
    
    %% Mixing the received signal with the IF carrier by multiplying them
    IF_signal = received_signal .* IF_stage_carrier';
    
    % Calculate and plot the IF signal spectrum
    IF_spectrum = fft(IF_signal);
    [~, ~, ~] = plot_spectrum(k_padded, 20 * FS, L_padded, IF_spectrum, ['IF Signal Spectrum ', num2str(i)]);
    %% Apply IF band-pass filter using fdesign
    filtered_IF_signal = apply_bandpass_filter(IF_signal, IF, 20 * FS, BW);
    
    % Calculate and plot the filtered IF signal spectrum
    IF_signal_spectrum = fft(filtered_IF_signal);
    [~, ~, ~] = plot_spectrum(k_padded, 20 * FS, L_padded, IF_signal_spectrum, ['filtered IF Signal Spectrum ', num2str(i)]);
    
    %% Generate LO signal
    LO_signal = cos(2 * pi * IF * t_padded);

    %% Mixing the filtered IF signal with the LO signal
    baseband_signal = filtered_IF_signal .* LO_signal';

    %% Apply low-pass filter
    baseband_signal_filtered = apply_lowpass_filter(baseband_signal, BW, 20 * FS);
    %% Create a new figure for the baseband signal
    figure;
    %% Plotting baseband signal
    plot(t_padded, baseband_signal_filtered);
    title(['Baseband Signal - Signal ', num2str(i)]);
    xlabel('Time');
    ylabel('Amplitude');
    
    % Calculate and plot the filtered signal spectrum
    filtered_spectrum = fft(baseband_signal_filtered);
    [~, ~, ~] = plot_spectrum(k_padded, 20 * FS, L_padded, filtered_spectrum, ['Filtered Signal Spectrum ', num2str(i)]);
    
    %% Export the audio
    gain_factor = 8;
    output_filename = ['Received_Signal_', num2str(i), '.wav'];
    normalized_signal = normalize(gain_factor * baseband_signal_filtered, 'range', [-1, 1]);
    % Write the normalized signal to the audio file
    audiowrite(output_filename, normalized_signal, 20 * FS);

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
    fd = fdesign.bandpass('N,Fc1,Fc2', filter_order, Fc - BW, Fc + BW, Fs_filter);
    
    % Design the filter
    Hd = design(fd, 'fir', 'window', 'hamming');
    
    % Visualize the frequency response
    fvtool(Hd, 'Color', 'White');

    % Apply the filter to the input signal
    received_signal = filter(Hd, input_signal);
end

%% Function: apply_lowpass_filter
%% Description:
    % This function applies a low-pass filter to the input signal using
    % the fdesign approach.
%% Return:
    % - filtered_signal: The filtered signal after applying the low-pass filter.
function filtered_signal = apply_lowpass_filter(input_signal,BW, Fs)
    % Design the low-pass filter using fdesign
    cutoff_frequency = BW;
    passband_ripple = 0.5;
    stopband_attenuation = 60;  
    % Create the filter design object
    fd = fdesign.lowpass('Fp,Fst,Ap,Ast', cutoff_frequency, cutoff_frequency*1.2, passband_ripple, stopband_attenuation, Fs);
    
    % Design the filter
    Hd = design(fd, 'fir', 'window', 'hamming');
    
    % Visualize the frequency response
    fvtool(Hd, 'Color', 'White');

    % Apply the filter to the input signal
    filtered_signal = filter(Hd, input_signal);
end
