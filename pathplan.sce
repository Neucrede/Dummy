
function plot_stencil(d)
    scf();
    a = gca();
    // [xmin,ymin; xmax,ymax]
    a.data_bounds = [   min(d(1,:))-2,  min(d(2,:))-2; 
                        max(d(1,:))+2,  max(d(2,:))+2   ];
    
    plot(d(1,:), d(2,:), 'O');
    
    yy = unique(d(2,:));
    yy = yy(:)'; // now, yy is a row vector
    X = repmat([min(d(1,:))-2; max(d(1,:))+2], 1, length(yy));
    Y = repmat(yy, 2, 1);
    plot(X, Y, 'blue');
endfunction

function out = unfold(d, n, min_gap)
    batches = [];
    
    y_group = gsort(unique(d(2,:)), 'g', 'i');
    y_weight = [];
    for i = 1 : length(y_group)
        y_weight = [y_weight, length(find(d(2,:) == y_group(i)))];
    end
    
    out = [];
endfunction

function out = sort_by_y_coord(d)
    d_swapped = [d(2,:); d(1,:)];
    d_swap_and_sorted = gsort(d_swapped, 'lc', 'i');
    d_sorted = [d_swap_and_sorted(2,:); d_swap_and_sorted(1,:)];
    
    out = d_sorted;
endfunction

function out = find_y_interval_of_adjacent_y_groups(d)
    d_sorted_by_y_coord = sort_by_y_coord(d);
    y1 = d_sorted_by_y_coord(2,:);
    if length(y1) < 2 then
        out = [];
        return;
    end
    
    y1 = unique(y1);
    y2 = [y1(2:$), 0];
    
    y_diff = [y2; (y2 - y1)];
    y_diff(:, find(y_diff(2,:) <= 0)) = [];
    
    out = y_diff;
endfunction

function out = penalty(s, y, w_total, w_avg, w, a, b, c)
    out = a * abs(y - s) + b * (w_total + w - w_avg) + c;
endfunction

function out = pp(d, m, min_gap, l)
    y = gsort(unique(d(2,:)), 'g', 'i');
    
    // number of distinct y values
    n = length(y);
    
    // weight vector
    w = [];
    for i = 1 : n
        w = [w, length(find(d(2,:) == y(i)))];
    end
    
    // range of movement of tip number i under the situation that all other 
    // tips been moved to both ends of the rack.
    limits = [];
    for i = 1 : m
        limits = [limits; (i - 1) * min_gap, l - ((m - i) * min_gap)];
    end
    
    mprintf("limits: \n %e \n\n", limits);
    
    dp = list();
    wtotal = list();
    
    for i = 1 : n
        dp_i = list();
        wtotal_i = list();
        
        for j = 1 : m
            A_j = zeros(n, n);
            
            next = find(y > limits(j,1) && y < limits(j,2));
            mprintf("available next(j=%d): \n %d \n\n", j, next);
            
            for r = 1 : n
                p = [next; %nan * ones(next)];
                for s = next
                    if ()
                end
            end
            
            dp_i(j) = A_j;
        end
        
        dp(i) = dp_i;
        wtotal(i) = wtotal_i;
    end
    
    out = [];
endfunction

