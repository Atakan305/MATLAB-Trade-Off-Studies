# MATLAB Trade-off Studies

MATLAB/Simulink practice projects for signal processing, step response analysis, validation, and control-system trade-off studies.

## Overview

This repository contains a collection of small MATLAB and Simulink projects developed to practice fundamental engineering and control-system concepts.

The projects start from basic signal generation and filtering, then move toward second-order system analysis, requirement validation, trade-off studies, and Simulink-based parameter sweep automation.

The main purpose of this repository is to build practical experience with MATLAB scripting, system response analysis, and engineering-style validation workflows.

## Repository Contents

```text
MATLAB-Trade-Off-Studies/
│
├── signal_noise_01.m
├── step_response_02.m
├── req_check_validation_03.m
├── trade_off_study_04.m
├── sim_project_05.m
├── simulink_param_sweep_final_06.m
└── README.md
```

## Project Files

### `signal_noise_01.m`

This script demonstrates a basic signal-processing workflow.

It creates a clean signal, adds random noise, applies moving average filters with different window sizes, and compares the filtering performance using RMSE values.

Main topics:

```text
Signal generation
Noise addition
Moving average filtering
RMSE calculation
Signal visualization
```

This project is useful for understanding how filtering affects noisy data and how error metrics can be used to compare signal quality.

---

### `step_response_02.m`

This script analyzes the step response of second-order systems with different damping ratios.

A fixed natural frequency is used, while multiple damping ratios are tested. The script plots the responses and extracts system-performance metrics.

Main topics:

```text
Second-order systems
Transfer functions
Natural frequency
Damping ratio
Rise time
Settling time
Overshoot
Peak value
```

This project shows how damping ratio changes the dynamic behavior of a system.

---

### `req_check_validation_03.m`

This script validates a candidate second-order system against predefined performance requirements.

The system is tested using common control-system metrics such as overshoot, settling time, and steady-state error.

Main topics:

```text
Requirement checking
Step response validation
Overshoot analysis
Settling time analysis
Steady-state error calculation
Pass/fail logic
```

Example requirements:

```text
Overshoot < 10%
Settling time < 2.0 s
Steady-state error < 0.02
```

The script prints a structured validation report in the MATLAB Command Window.

---

### `trade_off_study_04.m`

This script performs a trade-off study for multiple second-order system designs.

Different combinations of natural frequency and damping ratio are tested. For each candidate design, the script calculates performance metrics and checks whether the design satisfies the requirements.

Main topics:

```text
Design-space exploration
Parameter sweep
Trade-off analysis
Requirement validation
Best-design selection
Step response comparison
```

The script also displays result tables and plots all candidate step responses.

This is one of the main scripts in the repository because it combines modeling, simulation, performance evaluation, and design comparison.

---

### `sim_project_05.m`

This script runs a Simulink model from MATLAB and analyzes the output response.

The Simulink output is used to calculate performance metrics manually, including final value, peak value, overshoot, settling time, and steady-state error.

Main topics:

```text
MATLAB and Simulink integration
Running Simulink models from scripts
Simulation output analysis
Manual performance metric calculation
Validation of Simulink results
```

Important note:

```text
This script requires the related Simulink model file to be available in the same folder.
```

---

### `simulink_param_sweep_final_06.m`

This script performs an automated parameter sweep for a Simulink model.

It tests different values of gain, natural frequency, and damping ratio. For every parameter combination, the script runs the Simulink model, extracts the output, calculates performance metrics, checks the requirements, and stores the results.

Main topics:

```text
Automated Simulink simulations
Parameter sweep
Batch testing
Control-system validation
Requirement-based filtering
Best-design selection
CSV result export
```

The script exports the final results to:

```text
simulation_results.csv
```

This is the most complete script in the repository because it combines automation, simulation, validation, visualization, and result export.

## Main Concepts Covered

This repository covers the following concepts:

```text
MATLAB scripting
Simulink simulation
Signal processing
Moving average filtering
RMSE calculation
Transfer functions
Second-order system response
Step response analysis
Overshoot
Rise time
Settling time
Steady-state error
Natural frequency
Damping ratio
Parameter sweep
Trade-off study
Requirement validation
Best-design selection
```

## Requirements

To run the scripts, you need:

```text
MATLAB
Simulink
Control System Toolbox
```

Recommended MATLAB version:

```text
R2020b or newer
```

Some scripts may work with older versions, but newer versions are recommended for better compatibility.

## How to Run

Clone the repository:

```bash
git clone https://github.com/Atakan305/MATLAB-Trade-Off-Studies.git
```

Open MATLAB and set the repository folder as the current working directory.

Then run any script from the MATLAB Command Window.

Example:

```matlab
step_response_02
```

or:

```matlab
run('step_response_02.m')
```

## Simulink Notes

The files below require a Simulink model:

```text
sim_project_05.m
simulink_param_sweep_final_06.m
```

The expected Simulink model name is:

```text
trade_off_study.slx
```

The model should return output data through:

```matlab
simOut.yout
simOut.tout
```

If your Simulink output format is different, the output-reading section of the scripts may need to be adjusted.
