function collection = collect_parameters(S,P)

collection = {
    S.pop_ID,
    S.popavg_correlation(end),
    S.popavg_avgscore(end),
    S.popavg_propofcorrect(end),
    S.mode,
    S.popsize,
    S.fitness_measure,
    S.parametersets(1),
    S.popseed,
    S.nbof_generations,
    S.selection_type,
    S.selected_perc,
    S.nbof_global_testingpatterns,
    S.retraining,
    S.forgetting_rate,
    S.mutation_rate,
    S.known_global_problem,
    S.firstgen_input_random,
    S.runningtime_min,
    P.inputseed,
    P.weightseed,
    P.trainingseed,
    func2str(P.weight_init),
    P.strenght_of_memory_traces,
    P.nbof_neurons,
    P.weight_deletion_mode,
    P.connection_density,
    func2str(P.activation_function),
    P.gain_factor,
    P.threshold,
    P.allow_selfloops,
    P.lengthof_patterns,
    P.nbof_patterns,
    P.sparseness,
    P.inactive_input,
    P.trained_percentage,
    P.learning_rule,
    P.learning_rate,
    P.forgetting_rate,
    P.autothreshold_aftertraining,
    P.timeout,
    P.convergence_threshold,
    P.tolerance,
    P.synchronous_update,
    P.field_ratio,
    P.autothreshold_duringtesting,
    P.noise,
    P.missing_perc,
    };