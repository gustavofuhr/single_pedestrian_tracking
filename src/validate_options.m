% 
% USAGE
%  options = validate_options(options)
%
function options = validate_options(options)

% use default values
if ~isfield(options, 'min_patch_height'), options.min_patch_height = 20; end;
if ~isfield(options, 'search_window_size'), options.search_window_size = 30; end;
if ~isfield(options, 's_temporal_window'), options.s_temporal_window = 30; end;


if ~isfield(options, 'head_point') || ~isfield(options, 'foot_point')
    error('You need to specify points for the head and foot!');
end

if ~isfield(options, 'feature_type')
    warning('No feature type was informed! Using covariance...');
    options.feature_type = 'covariance';
end

if ~ismember(options.feature_type, {'color_hist', 'covariance'})
    error('Invalid feature type!');
else
    if strcmp(options.feature_type, 'color_hist')
        % gamma parameter for the exponential in the wvmf
        options.wvmf_gamma = 0.25;
        if ~isfield(options, 'n_bins'), options.n_bins = 64; end
    elseif strcmp(options.feature_type, 'covariance')
        options.wvmf_gamma = 0.15;
    end
end

if ~isfield(options, 'calib_filename')
    error('You need to inform the calibration xml file');
end


% precompute values and parse calibration
options.world_search_radius = compute_wsearch_radius(options);
[options.K, options.Rt] = parse_xml_calibration_file(options.calib_filename);
options.H = Rt2homog(options.Rt, options.K);