function WTF = makeWind(w,A,B) % WTG: Wind Turbine Generation; WTC: Wind Turbine Installed Capacity (rated)
    %% wind turbine parameters
    v_cut_in = 2.5;
    v_rated = 10;
    v_cut_off = 20;
    Vmax = 50;
    %% wind situation
    Wind_range = [0 v_cut_in v_rated v_cut_off Vmax];
    %A = 6; B = 2.1885 ;
    Wind_CDF = wblcdf(Wind_range, A, B);
    %%
    if w <= Wind_CDF(2) % out-of-operation: not enough to reach cut in speed
        WTF = 0;
    elseif w <= Wind_CDF(3)% partial power operation
        WTF = (wblinv(w,A,B) - v_cut_in)/(v_rated - v_cut_in);
    elseif w <= Wind_CDF(4)% rated power operation
        WTF = 1;
    else % out of operation: active stall control
        WTF = 0;
    end
    
end
% This code receives 