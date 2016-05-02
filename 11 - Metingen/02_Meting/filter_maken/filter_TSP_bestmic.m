signaal_goed_maken
close all;

lengte_filter=1000;

s = input(1:end);
x = output_padded(1:end)/max(output_padded);

    %% undo effect of filter    
    r=[x(1); zeros(lengte_filter-1,1)];             % r for toeplitz matrix
    
    x_toepl=[x; zeros(lengte_filter-1,1)];
    X=toeplitz(x_toepl,r);                          % inverse filter: x * h = s -> X h = s -> h = Xinv s
    
    Xinv=pinv(X);                                   % pseudo-inverse
    
    if length(s)<length(x_toepl)                    % enlarge or cutoff s
        s_mult=[s; zeros(length(x_toepl)-length(s),1)];
    elseif length(s)>length(x_toepl)
        s_mult=s(1:length(x_toepl));
    else
        s_mult=s;
    end
    
    h=Xinv*s_mult;                                       % find inverse filter

    %% reproduce s with inverse filter and output signal x
    s_reproduce=conv(x,h);
    
    % convolution_and_toeplitz=any((X*h==s_reproduce)==0)

    %% plot them
    figure;
    plot(s);hold on;plot(s_reproduce,'g');
    legend('inputsignal','reconstructed inputsignal');
    axis([0 length(s_reproduce) -1 1]);
    figure;
    plot(s);hold on;plot(x,'r');
    legend('inputsignal','outputsignal');
    hold off