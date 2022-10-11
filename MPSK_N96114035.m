clc; clear all; close all;
for M = 2 .^ (1 : 4) %M-ary %2 4 8 16
N = 1000;
k = log2(M);
snr_in_dB = 0 : 1 : 20;
E = 1; % energy per symbol
snr = 10 .^ (snr_in_dB / 10); % signal-to-noise ratio
sgma = sqrt(E ./ (2 * k * snr)); % noise variance %要改成general form %越大干擾越大
BER = zeros(1 , length(snr_in_dB));

BPSK_BER_theo = erfc(sqrt(snr)) / 2; % 2 4 BER %2 SER
BPSK_SER_theo = erfc(sqrt(snr)) / 2; % 2 4 BER %2 SER
QPSK_BER_theo = erfc(sqrt(snr)) / 2; 
QPSK_SER_theo = erfc(sqrt(snr));% 4 SER
EIGHT_BER_theo = erfc(sqrt(3 * snr) * sin(pi / 8))/3; % 8 BER 
EIGHT_SER_theo = EIGHT_BER_theo * 3; %8 SER
SIXTEEN_BER_theo = erfc(sqrt(4 * snr) * sin(pi / 16)) / 4; % 16 BER
SIXTEEN_SER_theo = SIXTEEN_BER_theo * 4; %16 SER

two_gray = [ 0 ; 1 ];

four_gray = [ 0 0 ; 0 1 ; 1 1 ; 1 0 ];

eight_gray = [ 0 0 0 ; 0 0 1 ; 0 1 1 ; 0 1 0 ; 1 1 0 ; 1 1 1 ; 1 0 1 ; 1 0 0 ];

sixteen_gray = [ 0 0 0 0 ; 0 0 0 1 ; 0 0 1 1 ; 0 0 1 0 ; 0 1 1 0 ; 0 1 1 1 ; 0 1 0 1 ; 0 1 0 0 ; 1 1 0 0 ; 1 1 0 1 ; 1 1 1 1 ; 1 1 1 0 ; 1 0 1 0 ; 1 0 1 1 ; 1 0 0 1 ; 1 0 0 0 ];

for t = 1 : length(snr_in_dB)
    symbolerror = 0;
    numofbiterror = 0;
    numofsymbolerror = 0;

    for i = 1 : N

        for m = 1 : M 
            s(m,:) = [sqrt(E)*cos(m*(2*pi/M)),sqrt(E)*sin(m*(2*pi/M))]; %signal mapping
        end
        
        n(1) = normrnd(0,sgma(t)); 
        n(2) = normrnd(0,sgma(t));
        a = randi(M);
        decis_index = 0;
        r = [];
        r = s(a,:) + n; %add noise to received signal

        for l = 1 : M %find maximum distance
            c(l) = (r(1) - s(l,1))^2 + (r(2) - s(l,2))^2;
        end 
        
        [min_c decis_index] = min(c);

        if(M == 2)
            if (two_gray(decis_index) ~= two_gray(a))
                numofbiterror = numofbiterror + 1;
            elseif (two_gray(decis_index) ~= two_gray(a))
                numofbiterror = numofbiterror + 1;
            end
            if (decis_index ~= a)
                numofsymbolerror = numofsymbolerror + 1;
            end
            Pb = numofbiterror / (k * N);
            Ps = numofsymbolerror / N;
        end
        if(M == 4)
            if (four_gray(decis_index,1) ~= four_gray(a,1))
                numofbiterror = numofbiterror + 1;
            elseif (four_gray(decis_index,2) ~= four_gray(a,2))
                numofbiterror = numofbiterror + 1;
            end
            if (decis_index ~= a)
                numofsymbolerror = numofsymbolerror + 1;
            end
            Pb = numofbiterror / (k * N);
            Ps = numofsymbolerror / N;
        end    
        if(M == 8)
            if (eight_gray(decis_index,1) ~= eight_gray(a,1))
                numofbiterror = numofbiterror + 1;
            elseif (eight_gray(decis_index,2) ~= eight_gray(a,2))
                numofbiterror = numofbiterror + 1;
            elseif (eight_gray(decis_index,3) ~= eight_gray(a,3))
                numofbiterror = numofbiterror + 1;
            end
            if (decis_index ~= a)
                numofsymbolerror = numofsymbolerror + 1;
            end
            Pb = numofbiterror / (k * N);
            Ps = numofsymbolerror / N;
        end
        if(M == 16)
            if (sixteen_gray(decis_index,1) ~= sixteen_gray(a,1))
                numofbiterror = numofbiterror + 1;
            elseif (sixteen_gray(decis_index,2) ~= sixteen_gray(a,2))
                numofbiterror = numofbiterror + 1;
            elseif (sixteen_gray(decis_index,3) ~= sixteen_gray(a,3))
                numofbiterror = numofbiterror + 1;
            elseif (sixteen_gray(decis_index,4) ~= sixteen_gray(a,4))
                numofbiterror = numofbiterror + 1;
            end
            if (decis_index ~= a)
                numofsymbolerror = numofsymbolerror + 1;
            end
            Pb = numofbiterror / (k * N);
            Ps = numofsymbolerror / N;
        end
    BER(t) = Pb;
    SER(t) = Ps;
    end
end

figure(1)
    if(M == 2)
        semilogy(snr_in_dB , BER , '*');
        legend('M = 2');
        hold on;
        semilogy(snr_in_dB , BPSK_BER_theo,'-r');
        axis([0 20 1e-4 1]);
        xlabel('SNR[dB]');                                    
        ylabel('Bit Error Rate'); 
    end
    if(M == 4)
        semilogy(snr_in_dB , BER , 'o');
        legend('M = 4');
        hold on;
        semilogy(snr_in_dB , QPSK_BER_theo,'-b');
        axis([0 20 1e-4 1]);
        xlabel('SNR[dB]');                                    
        ylabel('Bit Error Rate'); 
    end
    if(M == 8)
        semilogy(snr_in_dB , BER , 'h');
        legend('M = 8');
        hold on;
        semilogy(snr_in_dB , EIGHT_BER_theo,'-g');
        axis([0 20 1e-4 1]);
        xlabel('SNR[dB]');                                    
        ylabel('Bit Error Rate'); 
    end
    if(M == 16)
        semilogy(snr_in_dB , BER , '+');
        legend('M = 16');
        hold on;
        semilogy(snr_in_dB , SIXTEEN_BER_theo,'-y');
        axis([0 20 1e-4 1])
        xlabel('SNR[dB]')                                    
        ylabel('Bit Error Rate'); 
    end


figure(2)
    if(M == 2)
        semilogy(snr_in_dB , SER , '*');
        hold on;
        semilogy(snr_in_dB , BPSK_SER_theo ,'r');
        axis([0 20 1e-4 1])
        xlabel('SNR[dB]')                                    
        ylabel('Symbol Error Rate'); []
    end
    if(M == 4)
        semilogy(snr_in_dB , SER , 'o');
        hold on;
        semilogy(snr_in_dB , QPSK_SER_theo ,'b');
        axis([0 20 1e-4 1])
        xlabel('SNR[dB]')                                    
        ylabel('Symbol Error Rate'); 
    end
    if(M == 8)
        semilogy(snr_in_dB , SER , 'h');
        hold on;
        semilogy(snr_in_dB , EIGHT_SER_theo ,'g');
        axis([0 20 1e-4 1])
        xlabel('SNR[dB]')                                    
        ylabel('Symbol Error Rate'); 
    end
    if(M == 16)
        semilogy(snr_in_dB , SER , '+');
        hold on;
        semilogy(snr_in_dB , SIXTEEN_SER_theo ,'y');
        axis([0 20 1e-4 1])
        xlabel('SNR[dB]')                                    
        ylabel('Symbol Error Rate'); 
    end
end
