function collection = collect_parameters_trees(S,P)

collection = {
    S.pop_ID,
    S.popsize,
    S.fitness_measure,
    S.popseed,
    S.nbof_generations,
    S.selection_type,
    S.selected_perc,
    S.retraining,
    S.forgetting_rate,
    S.mutation_rate,
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
    P.sparseness,
    P.inactive_input,
    P.learning_rule,
    P.learning_rate,
    P.forgetting_rate,
    P.autothreshold_aftertraining,
    P.timeout,
    P.convergence_threshold,
    P.tolerance,
    P.synchronous_update,
    P.noise,
    P.missing_perc,
    };