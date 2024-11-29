# The MIT License (MIT)
#
# Copyright (c) 2024 Kris Jusiak <kris@jusiak.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM ubuntu:22.04
ARG CLANG=18
ARG GCC=13

RUN apt-get update && apt-get install -y \
  gnupg software-properties-common lsb-release ca-certificates \
  kmod linux-headers-6.2.0-39-generic linux-tools-generic linux-tools-*-generic \
  wget bzip2 pkg-config hwloc dbus-x11 \
  python3-pip \
  git \
  cmake \
  msr-tools \
  llvm-dev \
  libpfm4 libpapi-dev papi-tools \
  libgoogle-perftools-dev google-perftools graphviz gnuplot \
  valgrind kcachegrind \
  coz-profiler \
  pahole \
  likwid \
  hotspot \
  hyperfine

RUN pip3 install \
  pyperf \
  osaca \
  jupyter \
  numpy \
  pandas \
  matplotlib

RUN wget -qO - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | \
    gpg --dearmor -o /usr/share/keyrings/intel-oneapi-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/intel-oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | \
    tee /etc/apt/sources.list.d/oneAPI.list
RUN apt-get update && apt-get install -y libnss3 intel-oneapi-vtune

RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh $CLANG && rm llvm.sh
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt update && apt install g++-$GCC -y

RUN wget -qP /usr/include https://raw.githubusercontent.com/qlibs/prof/main/prof

ENV DISPLAY=:0
