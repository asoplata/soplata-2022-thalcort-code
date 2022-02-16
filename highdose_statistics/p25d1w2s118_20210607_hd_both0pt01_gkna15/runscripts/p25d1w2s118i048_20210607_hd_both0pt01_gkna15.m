% -------------------------------------------------------------------
%% 1. Define simulation parameters
% -------------------------------------------------------------------
% Where the simulation output files (excluding data) will go.
output_dir = '/YOUR_OUTPUT_DIR_HERE/';
study_dir = strcat(output_dir, mfilename);

random_seed = 85953;

% This is where you set the length of your simulation
time_end = 15000; % in milliseconds

% The time step/"resolution" used for the simulation. By default, DynaSim
% uses 0.01 milliseconds.
dt = 0.01; % in milliseconds

% Global scaling factor by which to multiple the number of cells in each
% population. The default scaling is 1, meaning 100 PYdr, 100 PYso, 20 IN,
% 20 TC, and 20 TRN. Changing the scale changes the population sizes
% proportionally, meaning a scaling of 0.5 would simulate a network using
% 50 PYdr, 50 PYso, 10 IN, 10 TC, and 10 TRN. Use this to decrease (< 1) or
% increase (> 1) the number of cells modeled in each population,
% proportionally.
numCellsScaleFactor = 1;

% Individual changes from default mechanism file parameters:
modifications  = {
    'PYso<-PYdr', 'gKNa',  1.5;
    'PYdr<-PYso', 'gAMPA', 0.01;

      'PYdr<-TC',   'gAMPA',  0.01;
      'IN<-PYso', 'gAMPA',  1.0;
      'PYso<-IN', 'gGABAA', 0.1;
      'IN<-TC',     'gAMPA',  0.1;
      'PYdr',  'appliedStim', 0.1;
      'TRN',   'appliedStim', 0;
      'TC',    'appliedStim', 0;
      'TC',    'gH', 0.005;
      'PYso<-IN', 'propoCondMult', 3;
      'PYso<-IN', 'propoTauMult',  3;
      'IN<-IN',   'propoCondMult', 3;
      'IN<-IN',   'propoTauMult',  3;
      'TC<-TRN',  'propoCondMult', 3;
      'TC<-TRN',  'propoTauMult',  3;
      'TRN<-TRN', 'propoCondMult', 3;
      'TRN<-TRN', 'propoTauMult',  3;
};


% If you want, add parameter values to "vary" simulations over, i.e. add 5
% different values for a certain parameter, say 'TC', 'gH', and DynaSim
% will run 5 independent simulations which are only different in that that
% one parameter is changed across simulations. Can handle independently
% simulating the Cartesian product of multiple dimensions varied together.
% Highly recommended to use on a cluster, since DynaSim will run the
% independent simulations in parallel on a cluster or if specific flags are
% checked. See DynaSim's "dsVary2Modifications.m" for details.
vary={...
};

% Options that affect the simulation properties without affecting the data;
% configuration rather than scientific options.
    % 'memory_limit', '64G',...   % Memory limit for use on cluster
simulator_options={

    'cluster_flag', 1,...       % Whether to submit simulation jobs to a cluster, 0 or 1
    'cluster_matlab_version','2017a',...
    'compile_flag', 0,...       % Whether to compile simulation using MEX, 0 or 1
    'disk_flag', 0,...          % Not implemented, ignore
    'downsample_factor', 10,... % How much to downsample data, proportionally {integer}
    'dt', dt,...                % Fixed time step, in milliseconds
    'memory_limit', '12G',...   % Memory limit for use on cluster
    'mex_flag', 0,...           % Flag for MEX compilation, not recommended
    'num_cores', 1,...          % Number of CPU cores to use, including on cluster
    'overwrite_flag', 1,...     % Whether to overwrite simulation raw data, 0 or 1
    'parfor_flag', 0,...        % Whether to use parfor if running multiple local sims, 0 or 1
    'plot_functions', {@dsPlot, @dsPlot,...
                      },...
    'plot_options', {{'plot_type', 'waveform', 'format', 'png'},...   % Arguments to pass to each of those plot functions
                     {'plot_type', 'rastergram', 'format', 'png'},...
                    },...
    'random_seed', random_seed,...     % What seed to use; use value 'shuffle' to randomize
    'save_data_flag', 0,...     % Whether to save raw output data, 0 or 1
    'save_results_flag', 1,...  % Whether to save output plots and analyses, 0 or 1
    'solver', 'euler',...       % Numerical integration method {'euler','rk1','rk2','rk4'}
    'study_dir', study_dir,...  % Where to save simulation results and code
    'tspan', [0 time_end],...   % Time vector of simulation, [beg end], in milliseconds
    'verbose_flag', 1,...       % Whether to display process info, 0 or 1
};

%     'analysis_functions', {@dsCalcFR, @dsCalcPower,...
%         @dsCalcCoupling,...
%         @dsCalcComodulograms,...
%         @dsCalcCoupling,...
%         @dsCalcComodulograms,...
%         @dsCalcCoupling,...
%         @dsCalcComodulograms,...
%         @dsCalcCoupling,...
%         @dsCalcComodulograms},...
%     'analysis_options', {{}, {},...
%         {'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_sAMPA'},...
%         {'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_sAMPA'},...
%         {'variable', 'PYdr_TC_iAMPA_PYdr_TC_sAMPA'},...
%         {'variable', 'PYdr_TC_iAMPA_PYdr_TC_sAMPA'},...
%         {'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12'},...
%         {'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12'},...
%         {'variable', 'PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC'},...
%         {'variable', 'PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC'}},...
% 
% 
%                      {'plot_type', 'coupling','format','png',...
%                         'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_sAMPA',...
%                         'max_num_rows',1,'xlim',[0.01, 2.41],...
%                         'ylim',[8 14]},...
%                     {'plot_type', 'comodulograms','format','png',...
%                         'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_sAMPA',...
%                         'max_num_rows',1},...
%                      {'plot_type', 'coupling','format','png',...
%                         'variable', 'PYdr_TC_iAMPA_PYdr_TC_sAMPA',...
%                         'max_num_rows',1,'xlim',[0.01, 2.41],...
%                         'ylim',[8 14]},...
%                     {'plot_type', 'comodulograms','format','png',...
%                         'variable', 'PYdr_TC_iAMPA_PYdr_TC_sAMPA',...
%                         'max_num_rows',1},...
%                      {'plot_type', 'coupling','format','png',...
%                         'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12',...
%                         'max_num_rows',1,'xlim',[0.01, 2.41],...
%                         'ylim',[8 14]},...
%                     {'plot_type', 'comodulograms','format','png',...
%                         'variable', 'PYdr_PYso_iAMPA_PYdr_PYso_JB12_IAMPA_PYdr_PYso_JB12',...
%                         'max_num_rows',1},...
%                      {'plot_type', 'coupling','format','png',...
%                         'variable', 'PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC',...
%                         'max_num_rows',1,'xlim',[0.01, 2.41],...
%                         'ylim',[8 14]},...
%                     {'plot_type', 'comodulograms','format','png',...
%                         'variable', 'PYdr_TC_iAMPA_PYdr_TC_iAMPA_PYdr_TC',...
%                         'max_num_rows',1},...

% -------------------------------------------------------------------
%% 2. Assemble and customize the model
% -------------------------------------------------------------------
spec = assembleExtSpec(numCellsScaleFactor);

% Apply local non-vary modifications to spec
spec = dsApplyModifications(spec, modifications);

% -------------------------------------------------------------------
%% 3. Run the simulation
% -------------------------------------------------------------------
data_2_tmax = dsSimulate(spec,'vary',vary,simulator_options{:});

% end
exit

