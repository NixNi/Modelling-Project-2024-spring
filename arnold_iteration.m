function [V, H] = arnold_iteration(A, v, m)
    % Initialize variables
    n = length(v);
    V = zeros(n, m+1);
    H = zeros(m+1, m);
    V(:, 1) = v / norm(v);

    % Arnoldi iteration
    for j = 1:m
        % Compute Av_j
        w = A * V(:, j);

        % Arnoldi orthogonalization
        for i = 1:j
            H(i, j) = V(:, i)' * w;
            w = w - H(i, j) * V(:, i);
        end

        % Orthogonalize w and store it as the next vector in V
        H(j+1, j) = norm(w);
        if H(j+1, j) ~= 0
            V(:, j+1) = w / H(j+1, j);
        else
            disp('Arnoldi iteration terminated early due to breakdown');
            break;
        end
    end
end
