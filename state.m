function st = state(initstate)
    % Unfortunately, MATLAB use column-first method to arrange 2D Matrix, or
    % a 2D image. So we need to use a function to make things compatible.
    
    % check if numbers need to be integer
    if any(initstate - round(initstate))
        disp('warning: initstate is not an integer vector');
    end

    
    initstate = round(initstate);
    y = initstate(1);% x axis at the Top left corner
    x = initstate(2);
    st.w = initstate(3);% width of the rectangle
    st.h = initstate(4);% height of the rectangle

    st.x1 = x;
    st.x2 = x+st.h-1;
    st.y1 = y;
    st.y2 = y+st.w-1;
end