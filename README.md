# Super-heterodyne Receiver

simulateing an AM modulator and a corresponding super-heterodyne receiver using radio-station generated signals.
![System Diagram](/images/system.png)

## Modulating Signal Analysis

This directory contains MATLAB code for analyzing modulating signals, including reading audio files, calculating signal spectra, generating carrier signals, and mixing them to produce Amplitude Modulated (AM) signals.

### Prerequisites

Before running the code, ensure that you have MATLAB installed on your system. The code utilizes the built-in functions provided by MATLAB for signal processing.

### Usage

1. **Clear Workspace:** Execute the following commands to clear the MATLAB workspace and close any open figures.

    ```matlab
    clear all;
    close all;
    ```

2. **Read Modulating Signals:** Define a list of modulating signals (audio files) in the `modulating_signals` array. The code will loop through each signal for analysis.

    ```matlab
    modulating_signals = {"Short_BBCArabic2.wav", "Short_FM9090.wav", %...etc};
    ```

3. **Loop Through Modulating Signals:** The code iterates through each modulating signal, performs signal analysis, and generates AM signals.

    ```matlab
    for i = 1:length(modulating_signals)
        % ... (code within the loop)
    end
    ```

4. **Function: plot_spectrum:** The function `plot_spectrum` is defined to plot the spectrum of a given signal and calculate relevant information such as peaks, bandwidth, and BW. The function returns these calculated values.

    ```matlab
    function [peaks, bandwidth, BW] = plot_spectrum(k, FS, spectrum_L, signal_spectrum, title_str)
        % ... (function code)
    end
    ```

### Signal Analysis Process

1. **Reading Modulating Signals:** Audio files are read, and their sampling frequency is obtained.

2. **Converting to Single Channel:** Two-channel stereo signals are converted to a single channel stream by adding the two channels.

3. **Increasing Sampling Frequency:** Sampling frequency is increased by interpolating the signal to conform to the Nyquist criteria for carrier signals.

4. **Calculating Spectrum:** FFT is applied to the modulating signal to obtain its baseband bandwidth. The spectrum is then plotted.

5. **Generating Carrier Signals:** Carrier signals are generated for each modulating signal with varying frequencies.

6. **Mixing Signals:** Modulating signals are mixed with their respective carrier signals by multiplication.
7. **Plotting AM Signals:** AM signals are plotted in separate figures.

### Function Description

The `plot_spectrum` function is responsible for plotting the spectrum of a given signal and calculating relevant information such as peaks, bandwidth, and BW. It returns these calculated values for further use.

```matlab
function [peaks, bandwidth, BW] = plot_spectrum(k, FS, spectrum_L, signal_spectrum, title_str)
    % ... (function code)
end
