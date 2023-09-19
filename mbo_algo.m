function [region1, region2] = img_segmentation(init_img)
% IMG_SEGMENTATION segment image into two regions, with countour
%	[REGION1, REGION2] = IMG_SEGMENTATION(IMAGE) segments image into two regions
%	
%	See also GIK, CONVOLUTION
%
%   by Abe Raouh, 07/27/2023
%   Following Algorithm by Dong Wang, Haohan Li, Xiaoyu Wei, Xiao-Ping Wang (Refered to as JCP paper)


    %% Initialize Parameters (Same as JCP Paper)
    dt = 0.03;                               % Time step
    lambda = 0.01;                           % Parameter lambda used in Step 1
    tolerance = 1e-12;                       % Error tolerance
    M = size(init_img, 1);                   % Height of the image
    N = size(init_img, 2);                   % Width of the image
	error = 1;                               % Initialize error value
    iteration = 0;                           % Number of iterations made by the loop
	P = init_img;							 % Copy of original image (needs to be normalized and grayscale)


    %% Initialize Regions (Contours, total of 2 regions)
    region1 = zeros(M, N);
    S = 0;                                  % Border width for initial regions -> init = 10
    region1(S:M-S, S:N-S) = 1;              % Set region1 as a square region inside the image
    region2 = ones(M, N) - region1;         % region2 is the complement of region1

    prev_region1 = - ones(size(region1));   % Initialize previous regions for convergence check
    prev_region2 = - ones(size(region1));
    
	
    %% Iterate Until Convergence
    while error > tolerance
        error = norm(region1 - prev_region1) + norm(region2 - prev_region2);
        prev_region1 = region1;
        prev_region2 = region2;
        iteration = iteration + 1;

		% Calculating gik and convolution
        [g1, g2] = gik(P, region1, region2);
        [conv1, conv2] = convolution(dt, region1, region2);

        % Update the regions based on thresholding
        phi1 = g1 + (2 * lambda * sqrt(pi) / sqrt(dt)) * conv2;
        phi2 = g2 + (2 * lambda * sqrt(pi) / sqrt(dt)) * conv1;

        region1 = double(phi1 <= phi2);      % Thresholding: If phi1 > phi2, region1 = 1, else 0
        region2 = 1 - region1;               % region2 is the complement of region1
    end

    %% Results
    fprintf('Number of Iterations : %d\n', iteration);
    fprintf('Error vs. Tolerance  : %d < %d\n', error, tolerance);
	fprintf(region1)
end


%% Helper Functions
function [g1, g2] = gik(f, region1, region2)
    c1 = sum(sum(region1 .* f)) / sum(sum(region1));
    c2 = sum(sum(region2 .* f)) / sum(sum(region2));
    
    g1 = (c1 - f).^2;  
    g2 = (c2 - f).^2;
end

function [c1, c2] = convolution(dt, region1, region2)
    %! Convolution with FFT    
end
