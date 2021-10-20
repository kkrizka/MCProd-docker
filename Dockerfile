FROM centos:8

# Useful tools
RUN yum -y install yum-utils && \
    yum-config-manager --set-enabled powertools && \
    yum -y install epel-release wget cmake libarchive rsync && \
    yum -y install python38 python38-six && \
    yum -y groupinstall "Development Tools"

# Install random HEP tools
RUN yum -y install HepMC-devel

# Install ROOT
RUN yum -y install root root-montecarlo-eg root-graf3d-eve root-gui-html root-genvector

# Install MadGraph
RUN wget https://launchpad.net/mg5amcnlo/3.0/3.2.x/+download/MG5_aMC_v3.2.0.tar.gz && \
    tar -xf MG5_aMC_v3.2.0.tar.gz && \
    rm MG5_aMC_v3.2.0.tar.gz && \
    mkdir -p /opt/MG5aMC && \
    mv MG5_aMC_v3_2_0 /opt/MG5aMC/3.2.0

# Install Pythia 8
RUN wget https://pythia.org/download/pythia83/pythia8306.tgz && \
    tar -xzf pythia8306.tgz && \
    rm pythia8306.tgz && \
    pushd pythia8306 && \
    ./configure --with-hepmc2 --prefix=/opt/pythia/8.306 && \
    make && make install && \
    popd && rm -rf pythia8306

RUN wget https://pythia.org/download/pythia82/pythia8245.tgz && \
    tar -xzf pythia8245.tgz && \
    rm pythia8245.tgz && \
    pushd pythia8245 && \
    ./configure --with-hepmc2 --prefix=/opt/pythia/8.245 && \
    make && make install && \
    popd && rm -rf pythia8245

# MG/Py8 interface (specific to Pythia version)
RUN wget http://madgraph.physics.illinois.edu/Downloads/MG5aMC_PY8_interface/MG5aMC_PY8_interface_V1.2.tar.gz && \
    mkdir MG5aMC_PY8_interface_V1.2 && \
    tar -xf MG5aMC_PY8_interface_V1.2.tar.gz -C MG5aMC_PY8_interface_V1.2 && \
    rm MG5aMC_PY8_interface_V1.2.tar.gz && \
    pushd MG5aMC_PY8_interface_V1.2 && \
    python3.8 compile.py /opt/pythia/8.245/ --pythia8_makefile && \
    install MG5aMC_PY8_interface /opt/pythia/8.245 && \
    popd && rm -rf MG5aMC_PY8_interface_V1.2

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