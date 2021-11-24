Collection of programs for event generation/simulation for HEP experiments.

# Included software
- MG5@NLO 3.2.0 and 3.3.0
- Pythia 8.306 and 8.245
- MG5aMC_PY8_interface 1.2 (MGg3.2.0 + Py8.245)
- MG5aMC_PY8_interface 1.3 (MGg3.3.0 + Py8.306)
- ExRootAnalysis 1.1.5
- Delphes 3.5.0

# Instructions
## Building
```sh
docker build .
```

## Example MG5@NLO with Docker
```
docker run -it kkrizka/mcprod:main /opt/MG5aMC/3.2.0/bin/mg5_aMC
```

## Example MG5@NLO with Singularity
```
singularity exec docker://kkrizka/mcprod:main /opt/MG5aMC/3.2.0/bin/mg5_aMC
```

