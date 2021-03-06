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
RUN yum -y install HepMC-devel gnuplot

# Install ROOT
ADD installROOT.sh .
ADD setupROOT.sh /opt/ROOT/
RUN yum -y install git libX11-devel libXpm-devel libXft-devel libXext-devel openssl-devel && \
    yum -y install mesa-libGL-devel mesa-libGLU-devel glew-devel && \
    ./installROOT.sh v6-24-06 && \
    echo "source /opt/ROOT/setupROOT.sh v6-24-06" >> /etc/profile.d/root.sh

# Install LHAPDF
ADD installLHAPDF.sh .
ADD setupLHAPDF.sh /opt/LHAPDF/
RUN ./installLHAPDF.sh 6.4.0 && \
    echo "source /opt/LHAPDF/setupLHAPDF.sh 6.4.0" >> /etc/profile.d/lhapdf.sh && \
    source /etc/profile.d/lhapdf.sh && \
    lhapdf install CT10nlo && \
    lhapdf install NNPDF23_lo_as_0130_qed && \
    lhapdf install NNPDF23_nlo_as_0119 && \
    lhapdf install NNPDF30_nlo_as_0118 && \
    lhapdf install NNPDF30_nnlo_as_0118 && \
    lhapdf install NNPDF31_nnlo_as_0118

# Install MadGraph
RUN wget https://launchpad.net/mg5amcnlo/3.0/3.2.x/+download/MG5_aMC_v3.2.0.tar.gz && \
    tar -xf MG5_aMC_v3.2.0.tar.gz && \
    rm MG5_aMC_v3.2.0.tar.gz && \
    mkdir -p /opt/MG5aMC && \
    pushd MG5_aMC_v3_2_0 && \
    rsync -ar Template/LO/Source/.make_opts Template/LO/Source/make_opts && \
    pushd && \
    mv MG5_aMC_v3_2_0 /opt/MG5aMC/3.2.0

RUN wget https://launchpad.net/mg5amcnlo/3.0/3.3.x/+download/MG5_aMC_v3.3.1.tar.gz && \
    tar -xf MG5_aMC_v3.3.1.tar.gz && \
    rm MG5_aMC_v3.3.1.tar.gz && \
    mkdir -p /opt/MG5aMC && \
    pushd MG5_aMC_v3_3_1 && \
    rsync -ar Template/LO/Source/.make_opts Template/LO/Source/make_opts && \
    pushd && \
    mv MG5_aMC_v3_3_1 /opt/MG5aMC/3.3.1

# Install MadGraph models
ADD installModel.sh .
RUN ./installModel.sh http://madgraph.phys.ucl.ac.be/Downloads/models/heft.tgz

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
RUN source /etc/profile.d/root.sh && \
    wget http://madgraph.phys.ucl.ac.be/Downloads/ExRootAnalysis/ExRootAnalysis_V1.1.5.tar.gz && \
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
ADD installDelphes.sh .
RUN source /etc/profile.d/root.sh && \
    ./installDelphes.sh 3.5.0

# Configure MG5@NLO to use external paths
RUN sed -i -e 's|[# ]*f2py_compiler_py3\s*=\s*.*|f2py_compiler_py3 = /usr/bin/f2py3|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*mg5amc_py8_interface_path\s*=\s*.*|mg5amc_py8_interface_path = /opt/pythia/8.245|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*pythia8_path\s*=\s*.*|pythia8_path = /opt/pythia/8.245|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*exrootanalysis_path\s*=\s*.*|exrootanalysis_path = /opt/ExRootAnalysis/1.1.5/bin|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*delphes_path\s*=\s*.*|delphes_path = /opt/delphes/3.5.0/bin|' /opt/MG5aMC/3.2.0/input/mg5_configuration.txt

RUN sed -i -e 's|[# ]*f2py_compiler_py3\s*=\s*.*|f2py_compiler_py3 = /usr/bin/f2py3|' /opt/MG5aMC/3.3.1/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*mg5amc_py8_interface_path\s*=\s*.*|mg5amc_py8_interface_path = /opt/pythia/8.306|' /opt/MG5aMC/3.3.1/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*pythia8_path\s*=\s*.*|pythia8_path = /opt/pythia/8.306|' /opt/MG5aMC/3.3.1/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*exrootanalysis_path\s*=\s*.*|exrootanalysis_path = /opt/ExRootAnalysis/1.1.5/bin|' /opt/MG5aMC/3.3.1/input/mg5_configuration.txt && \
    sed -i -e 's|[# ]*delphes_path\s*=\s*.*|delphes_path = /opt/delphes/3.5.0/bin|' /opt/MG5aMC/3.3.1/input/mg5_configuration.txt