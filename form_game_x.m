function dif_i=form_game_x(x,i)

A=[ 0 1 1 0;
    1 0 1 0;
    1 1 0 1;
    0 0 1 0];
D=40*[ 0 -1 0 -1;
    1 0 1 0;
    0 -1 0 -1;
    1 0 1 0];
p_i=2*i-1;
f_1=0;

    for j=1:4
        f_1=f_1+A(i,j)*(x(i)-x(j)-D(i,j));
    end

dif_i=x(i)+p_i+f_1;
clear f_1;
end