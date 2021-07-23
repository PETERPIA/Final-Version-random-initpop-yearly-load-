function pc_load = LoadFraction

    hourload =...
       [67 78 64 74 63 75;
        63 72 60 70 62 73;
        60 68 58 66 60 69;
        59 66 56 65 58 66;
        59 64 56 64 59 65;
        60 65 58 62 65 65;
        74 66 64 62 72 68;
        86 70 76 66 85 74;
        95 80 87 81 95 83;
        96 88 95 86 99 89;
        96 90 99 91 100 92;
        95 91 100 93 99 94;
        95 90 99 93 93 91;
        95 88 100 92 92 90;
        93 87 100 91 90 90;
        94 87 97 91 88 86;
        99 91 96 92 90 85;
        100 100 96 94 92 88;
        100 99 93 95 96 92
        96 97 92 95 98 100;
        91 94 92 100 96 97;
        83 92 93 93 90 95;
        73 87 87 88 80 90;
        63 81 72 80 70 85];

    hourload = hourload/100; %INTO decimal form (xx.x%==>0.xxx)
    
    rng('shuffle');
    r = rand;
    h = randi(24);
    s1 = 2 * randi(3);
    s2 = s1 - 1;
    if r <= 2/7 % weekend, choose column 2 4 6
        pc_load = hourload(h, s1);
    else %weekday
        pc_load = hourload(h, s2);
    end

end