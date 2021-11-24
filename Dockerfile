FROM centos:8

# Useful tools
RUN yum -y install yum-utils && \
    yum-config-manager --set-enabled powertools && \
    yum -y install epel-release wget cmake libarchive rsync && \
    yum -y install python38 python38-six python38-numpy python38-numpy-f2py && \
    alternatives --set python /usr/bin/python3.8 && \
    alternatives --set python3 /usr/bin/python3.8 && \
    yum -y groupinstall "Development Tools" && \
    yum -y install gcc-gfortran

# Install random HEP tools
RUN yum -y install HepMC-devel  gnuplot

# Install ROOT
RUN yum -y install root root-montecarlo-eg root-graf3d-eve root-gui-html root-genvector

# Install LHAPDF
RUN wget -O LHAPDF-6.4.0.tar.gz https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.4.0.tar.gz && \
    tar -xvzf LHAPDF-6.4.0.tar.gz && \
    rm LHAPDF-6.4.0.tar.gz && \
    pushd LHAPDF-6.4.0 && \
    ./configure --prefix=/opt/LHAPDF/6.4.0 && \
    make && \
    make install &&\
    popd && rm -rf LHAPDF-6.4.0 && \
    DATADIR=$(/opt/LHAPDF/6.4.0/bin/lhapdf-config --datadir) && \
    wget http://lhapdfsets.web.cern.ch/lhapdfsets/current/CT10nlo.tar.gz -O- | tar xz -C ${DATADIR} && \
    wget http://lhapdfsets.web.cern.ch/lhapdfsets/current/NNPDF30_nlo_as_0118.tar.gz -O- | tar xz -C ${DATADIR} && \
    wget http://lhapdfsets.web.cern.ch/lhapdfsets/current/NNPDF30_nnlo_as_0118.tar.gz -O- | tar xz -C ${DATADIR} && \
    wget http://lhapdfsets.web.cern.ch/lhapdfsets/current/NNPDF23_nlo_as_0119.tar.gz -O- | tar xz -C ${DATADIR}

# Install MadGraph
RUN wget https://launchpad.net/mg5amcnlo/3.0/3.2.x/+download/MG5_aMC_v3.2.0.tar.gz && \
    tar -xf MG5_aMC_v3.2.0.tar.gz && \
    rm MG5_aMC_v3.2.0.tar.gz && \
    mkdir -p /opt/MG5aMC && \
    pushd MG5_aMC_v3_2_0 && \
    rsync -ar Template/LO/Source/.make_opts Template/LO/Source/make_opts && \
    pushd && \
    mv MG5_aMC_v3_2_0 /opt/MG5aMC/3.2.0

RUN wget https://launchpad.net/mg5amcnlo/3.0/3.3.x/+download/MG5_aMC_v3.3.0.tar.gz && \
    tar -xf MG5_aMC_v3.3.0.tar.gz && \
    rm MG5_aMC_v3.3.0.tar.gz && \
    mkdir -p /opt/MG5aMC && \
    pushd MG5_aMC_v3_3_0 && \
    rsync -ar Template/LO/Source/.make_opts Template/LO/Source/make_opts && \
    pushd && \
    mv MG5_aMC_v3_3_0 /opt/MG5aMC/3.3.0

# Install Pythia 8
RUN wget https://pythia.org/download/pythia82/pythia8245.tgz && \
    tar -xzf pythia8245.tgz && \
    rm pythia8245.tgz && \
    pushd pythia8245 && \
    ./configure --with-hepmc2 --with-gzip --prefix=/opt/pythia/8.245 && \
    make && make install && \
    popd && rm -rf pythia8245

RUN wget https://pythia.org/download/pythia83/pythia8306.tgz && \
    tar -xzf pythia8306.tgz && \
    rm pythia8306.tgz && \
    pushd pythia8306 && \
    ./configure --with-hepmc2 --with-gzip --prefix=/opt/pythia/8.306 && \
    make && make install && \
    popd && rm -rf pythia8306

# MG/Py8 interface (specific to Pythia version)
RUN wget http://madgraph.physics.illinois.edu/Downloads/MG5aMC_PY8_interface/MG5aMC_PY8_interface_V1.2.tar.gz && \
    mkdir MG5aMC_PY8_interface_V1.2 && \
    tar -xf MG5aMC_PY8_interface_V1.2.tar.gz -C MG5aMC_PY8_interface_V1.2 && \
    rm MG5aMC_PY8_interface_V1.2.tar.gz && \
    pushd MG5aMC_PY8_interface_V1.2 && \
    python3.8 compile.py /opt/pythia/8.245/ --pythia8_makefile && \
    install MG5aMC_PY8_interface /opt/pythia/8.245 && \
    install MG5AMC_VERSION_ON_INSTALL /opt/pythia/8.245 && \
    install PYTHIA8_VERSION_ON_INSTALL /opt/pythia/8.245 && \
    popd && rm -rf MG5aMC_PY8_interface_V1.2

RUN wget http://madgraph.physics.illinois.edu/Downloads/MG5aMC_PY8_interface/MG5aMC_PY8_interface_V1.3.tar.gz && \
    mkdir MG5aMC_PY8_interface_V1.3 && \
    tar -xf MG5aMC_PY8_interface_V1.3.tar.gz -C MG5aMC_PY8_interface_V1.3 && \
    rm MG5aMC_PY8_interface_V1.3.tar.gz && \
    pushd MG5aMC_PY8_interface_V1.3 && \
    python3.8 compile.py /opt/pythia/8.306/ --pythia8_makefile && \
    install MG5aMC_PY8_interface /opt/pythia/8.306 && \
    install MG5AMC_VERSION_ON_INSTALL /opt/pythia/8.306 && \
    install PYTHIA8_VERSION_ON_INSTALL /opt/pythia/8.306 && \
    popd && rm -rf MG5aMC_PY8_interface_V1.3

# Install ExRootAnalysis
RUN wget http://madgraph.phys.ucl.ac.be/Downloads/ExRootAnalysis/ExRootAnalysis_V1.1.5.tar.gz && \
    tar -xf ExRootAnalysis_V1.1.5.tar.gz && \
    rm ExRootAnalysis_V1.1.5.tar.gz && \
    pushd ExRootAnalysis && \
    make && \
    mkdir -p /opt/ExRootAnalysis/1.1.5/lib && \
    mkdir -p /opt/ExRootAnalysis/1.1.5/bin && \
    install libExRootAnalysis.so /opt/ExRootAnalysis/1.1.5 && \
    install ExRootLHEFConverter ExRootLHCOlympicsConverter ExRootSTDHEPConverter ExRootHEPEVTConverter /opt/ExRootAnalysis/1.1.5 && \
    popd && rm -rf ExRootAnalysis

# Install Delphes
RUN git clone https://github.com/delphes/delphes.git && \
    pushd delphes && \
    git checkout -b 3.5.0 3.5.0 && \
    cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=/opt/delphes/3.5.0 && \
    cmake --build build && \
    cmake --install build && \
    popd && rm -rf delphes

# Configure MG5@NLO to use external paths
RUN sed -i -e 's|[# ]*f2py_compiler_py3\s*=\s*.*|f2py_compiler_py3 = /usr/bin/f2py3|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*mg5amc_py8_interface_path\s*=\s*.*|mg5amc_py8_interface_path = /opt/pythia/8.245|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*pythia8_path\s*=\s*.*|pythia8_path = /opt/pythia/8.245|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*exrootanalysis_path\s*=\s*.*|exrootanalysis_path = /opt/ExRootAnalysis/1.1.5/bin|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*delphes_path\s*=\s*.*|delphes_path = /opt/delphes/3.5.0/bin|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt

RUN sed -i -e 's|[# ]*f2py_compiler_py3\s*=\s*.*|f2py_compiler_py3 = /usr/bin/f2py3|' /opt/MG5aMC/3.3.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*mg5amc_py8_interface_path\s*=\s*.*|mg5amc_py8_interface_path = /opt/pythia/8.306|' /opt/MG5aMC/3.3.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*pythia8_path\s*=\s*.*|pythia8_path = /opt/pythia/8.306|' /opt/MG5aMC/3.3.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*exrootanalysis_path\s*=\s*.*|exrootanalysis_path = /opt/ExRootAnalysis/1.1.5/bin|' /opt/MG5aMC/3.3.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*delphes_path\s*=\s*.*|delphes_path = /opt/delphes/3.5.0/bin|' /opt/MG5aMC/3.3.0/input/mg5_configuration.txt