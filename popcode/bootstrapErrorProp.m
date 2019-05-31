function stderr = bootstrapEP(func, argsmu, argstd, ns)
% bootstrapErrorProp Error propoagation by bootstrapping
% 
% stderr = bootstrapEP(func, argsmu, argstd, ns)
% func: handle of function with one return value and n args
% argsmu: cell array of n mean values
% argstd: cell array of n standard deviations
% ns: number of samples
%

% Sample a set of inputs to the function
args = cellfun(@(a,b) a + b .* randn(size(b)), argsmu, argstd, 'UniformOutput', false);

% Execute function
retval = func(args{:});

% Use size of returned variable to preallocate array for further output samples
samps = zeros(size(retval,1), size(retval,2), ns);
samps(:,:,1) = retval;

for i = 2 : ns
   % sample inputs
   args = cellfun(@(a,b) a + b .* randn(size(b)), argsmu, argstd, 'UniformOutput', false);
   % execute function and store output
   samps(:,:,i) = func(args{:});
end

% compute standard deviation
stderr = std(samps,0,3);