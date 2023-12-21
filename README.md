# Super-heterodyne Receiver

simulateing an AM modulator and a corresponding super-heterodyne receiver using radio-station generated signals.
![System Diagram](/images/system.png)

## Introduction

This MATLAB code demonstrates the amplitude modulation (AM) signal processing pipeline for a set of modulating signals. The code processes both "Short_BBCArabic2.wav" and "Short_FM9090.wav" signals, providing insights into the various stages of AM signal generation, filtering, and analysis.

## Code Structure

The code is structured into several sections, each serving a specific purpose in the AM signal processing pipeline. The main sections include:

- Modulating Signals:
      - The code begins by specifying a list of modulating signals (e.g., "Short_BBCArabic2.wav", "Short_FM9090.wav").

- Signal Processing Loop:
      - A loop iterates through each modulating signal, processing and analyzing it individually.

- Signal Analysis:
      - The modulating signals are read and transformed into single-channel streams.
      - The frequency spectrum of each modulating signal is analyzed to determine its baseband bandwidth.

- Carrier Signal Generation:
      - A carrier signal is generated based on the modulating signal's characteristics.
      - The modulating signal is mixed with the carrier signal to produce the AM signal.

- Band-Pass Filtering:
      - The AM signals are passed through band-pass filters to isolate the desired frequency range.
      - The filtered signals are then analyzed and visualized.

- Intermediate Frequency (IF) Stage:
      - An IF carrier is generated, and the filtered signals are mixed with the IF carrier.
      - The resulting signals undergo IF band-pass filtering.

- Baseband detection Stage:
      - An signal with frequency equal to $\omega_{IF}$ is generated, and the filtered IF signals are mixed with this signal.
      - The final baseband signals are obtained.

- Low-Pass Filtering:
      - The baseband signals undergo low-pass filtering to remove high-frequency components.

- Spectrum Analysis:
      - The original and filtered signal spectra are analyzed and plotted for comparison.

- Audio Export:
      - The processed baseband signals are exported as audio files (found in received directory).

## Results for "Short_BBCArabic2.wav" and "Short_FM9090.wav"

For both signals -Short_BBCArabic2.wav represents signal 1, and Short_FM9090.wav represents signal 2- the following results and plots are generated:

- AM Signals:
Time-domain plots of the AM signals are displayed, illustrating their amplitude variations:
  - AM Signal 1
      ![System Diagram](/images/AM_Signal_1.png)
  - AM Signal 2
      ![System Diagram](/images/AM_Signal_2.png)

- Received Signals after Band-Pass Filtering:
Time-domain plots of the received signals after band-pass filtering are shown.
  - Received Signal after BandPass 1:
        ![System Diagram](/images/Received_Signal_after_BandPass_1.png)
  - Received Signal after BandPass 2
        ![System Diagram](/images/Received_Signal_after_BandPass_2.png)
- Baseband Signals:
Time-domain plots of the baseband signals are presented.
  - Baseband Signal 1
        ![System Diagram](/images/Baseband_Signal_1.png)
  - Baseband Signal 2
        ![System Diagram](/images/Baseband_Signal_2.png)  
- Original Vs Demodulated and Filtered received Signal Spectra:
Spectra of the original and filtered baseband signals are compared.
  - Original Signal Spectrum 1
        ![System Diagram](/images/Signal_1_Spectrum.png)
  - Original Signal Spectrum 2
        ![System Diagram](/images/Signal_2_Spectrum.png)
  - Filtered Signal Spectrum 1
        ![System Diagram](/images/Filtered_Signal_Spectrum_1.png)
  - Filtered Signal Spectrum 2
        ![System Diagram](/images/Filtered_Signal_Spectrum_2.png)
- Band-Pass Filter Visualizations:
Frequency response visualizations of the band-pass filters are provided.
  - Bandpass Signal 1 Center Fc Filter Visualization
        ![System Diagram](/images/Bandpass_signal1_center_Fc_filter_visulaization.png)
  - Bandpass Signal 1 Center IF Filter Visualization
        ![System Diagram](/images/Bandpass_signal1_center_If_filter_visulaization.png)
  - Bandpass Signal 2 Center Fc Filter Visualization
        ![System Diagram](/images/Bandpass_signal2_center_Fc_filter_visualization.png)
  - Bandpass Signal 2 Center IF Filter Visualization
        ![System Diagram](/images/Bandpass_signal2_center_IF_filter_visualization.png)
- Low-Pass Filter Visualizations:
Frequency response visualizations of the low-pass filters are provided.
  - LPF Signal 1 Filter Visualization
        ![System Diagram](/images/LPF_signal1_filter_visualization.png)
  - LPF Signal 2 Filter Visualization
        ![System Diagram](/images/LPF_signal2_filter_visualization.png)

## Instructions for Use

To use this code for other modulating signals:

    Update the modulating_signals list with the desired signal filenames.
    Adjust parameters such as filter orders, frequencies, and gains as needed.
