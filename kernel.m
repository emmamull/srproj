function kn = kernel(set,state)
    % search radius in X/Y direction
    sx = set(1);
    sy = set(2);
    rx = set(3);
    cy = set(4);
    
    kn.sx = sx;
    kn.sy = sy;
    % # locs (rows,cols) that need to be tracked
    kn.rx = rx;
    kn.cy = cy;
    
    % region of interest width and height
    kn.w = state.w;
    kn.h = state.h;
    
    % default minimum elements in the lateral/axial direction
    hx = 7; 
    hy = 1;
    
    if kn.h/rx/2 > hx
        hx = floor(kn.h/rx/2);
    end
    
    if kn.w/cy/2 > hy
        hy = floor(kn.w/cy/2);
    end
        
    kn.hx = hx;
    kn.hy = hy;

end