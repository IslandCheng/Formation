function dif_i=form_game_y(y,i)

A=[ 0 1 1 0;
    1 0 1 0;
    1 1 0 1;
    0 0 1 0];

D=40*[ 0 0 1 1;
    0 0 1 1;
    -1 -1 0 0;
    -1 -1 0 0];
p_i=2*i+1;
f_1=0;

    for j=1:4
        f_1=f_1+A(i,j)*(y(i)-y(j)-D(i,j));
    end

dif_i=y(i)+p_i+f_1;
clear f_1;
end