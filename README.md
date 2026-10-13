# ReactorEngineeringDataSimulation

This repository presents a computational workflow for the automated generation of simulation datasets for machine learning applications in chemical reactor engineering. The methodology integrates OpenSCAD, OpenFOAM, and Python to automate reactor geometry generation, computational fluid dynamics (CFD) simulations, and data processing.

The workflow focuses on Continuous Stirred-Tank Reactors (CSTRs), investigating the influence of geometric and operating parameters on reactor hydrodynamics and Residence Time Distribution (RTD). Parametric three-dimensional geometries are generated using OpenSCAD, while OpenFOAM is employed to perform CFD simulations and characterize fluid flow behavior. Python scripts coordinate the workflow, automate simulation tasks, and organize the resulting data into structured datasets.

To assess the reliability of the proposed methodology, the CFD simulation framework is validated against the results reported by Wu et al. (2025), who investigated the residence time distribution of variable-viscosity fluids in stirred tanks. This reference provides a basis for comparing RTD behavior and evaluating the consistency of the numerical approach.

The repository aims to support reproducible computational research by documenting the simulation workflow and providing the scripts and configurations required to generate datasets for machine learning applications in reactor engineering.

Reference

Wu, G.; Li, L.; Li, Z.; Wang, J.; Gao, Z. Residence Time Distribution of Variable Viscosity Fluids in the Stirred Tank. Processes, 2025, 13, 2997. https://doi.org/10.3390/pr13092997
