# NVIDIA system check


```python
!echo $PATH | tr ':' '\n'
```

    /home/gp21012/.cache/pypoetry/virtualenvs/dve-sample-r-x2RGOxK1-py3.12/bin
    /run/user/21012/fnm_multishells/124873_1743177110819/bin
    /home/gp21012/.local/share/fnm
    /home/gp21012/.pyenv/shims
    /run/user/21012/fnm_multishells/124790_1743177110659/bin
    /home/gp21012/.local/share/fnm
    /run/user/21012/fnm_multishells/124543_1743177102418/bin
    /home/gp21012/.local/share/fnm
    /run/user/21012/fnm_multishells/124453_1743177102247/bin
    /home/gp21012/.local/share/fnm
    /home/gp21012/.local/bin
    /run/user/21012/fnm_multishells/51728_1743163143869/bin
    /home/gp21012/.local/share/fnm
    /home/gp21012/.pyenv/bin
    /run/user/21012/fnm_multishells/51571_1743163143375/bin
    /home/gp21012/.local/share/fnm
    /home/gp21012/.cargo/bin
    /home/gp21012/.local/bin
    /usr/local/sbin
    /usr/local/bin
    /usr/sbin
    /usr/bin
    /sbin
    /bin
    /usr/games
    /usr/local/games
    /snap/bin
    /usr/lib/jvm/bin
    /usr/lib/jvm/jre/bin
    /usr/local/stata
    /usr/local/MATLAB/R2024a/bin
    /usr/local/MATLAB/R2024a/bin/glnxa64
    /home/gp21012/.local/bin
    /home/gp21012/.local/bin
    /usr/lib/jvm/bin
    /usr/lib/jvm/jre/bin
    /usr/local/stata
    /usr/local/MATLAB/R2024a/bin
    /usr/local/MATLAB/R2024a/bin/glnxa64
    /home/gp21012/.local/bin
    /home/gp21012/.local/bin
    /home/gp21012/.local/bin



```python
!nvidia-smi
```

    Fri Mar 28 16:52:09 2025       
    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 570.124.06             Driver Version: 570.124.06     CUDA Version: 12.8     |
    |-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    |=========================================+========================+======================|
    |   0  Tesla V100-PCIE-16GB           Off |   00000001:00:00.0 Off |                    0 |
    | N/A   29C    P0             24W /  250W |       1MiB /  16384MiB |      0%      Default |
    |                                         |                        |                  N/A |
    +-----------------------------------------+------------------------+----------------------+
                                                                                             
    +-----------------------------------------------------------------------------------------+
    | Processes:                                                                              |
    |  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
    |        ID   ID                                                               Usage      |
    |=========================================================================================|
    |  No running processes found                                                             |
    +-----------------------------------------------------------------------------------------+



```python
!nvidia-smi --version
```

    NVIDIA-SMI version  : 570.124.06
    NVML version        : 570.124
    DRIVER version      : 570.124.06
    CUDA Version        : 12.8



```python
!nvidia-smi -L
```

    GPU 0: Tesla V100-PCIE-16GB (UUID: GPU-a2db1942-76d6-3572-10f1-3d0b0e1fbd72)



```python
!lspci
```

    0000:00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) (rev 03)
    0000:00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 01)
    0000:00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
    0000:00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
    0000:00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual VGA
    0001:00:00.0 3D controller: NVIDIA Corporation GV100GL [Tesla V100 PCIe 16GB] (rev a1)



```python
!lsmod | grep nv
```

    nvidia_uvm           2072576  0
    nvidia_drm            131072  0
    nvidia_modeset       1548288  1 nvidia_drm
    nvidia              89849856  2 nvidia_uvm,nvidia_modeset
    video                  73728  1 nvidia_modeset
    nvme_fabrics           36864  0



```python
!apt list --installed | grep -i -e nvidia -e cuda -e blas -e cudnn
```

    
    WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    


    cuda-cccl-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-command-line-tools-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-compiler-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-crt-12-8/unknown,now 12.8.93-1 amd64 [installed,automatic]
    cuda-cudart-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-cudart-dev-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-cuobjdump-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-cupti-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-cupti-dev-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-cuxxfilt-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-documentation-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-driver-dev-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-drivers-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    cuda-drivers/unknown,now 570.124.06-0ubuntu1 amd64 [installed]
    cuda-gdb-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-keyring/unknown,unknown,now 1.1-1 all [installed]
    cuda-libraries-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-libraries-dev-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-nsight-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-nsight-compute-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-nsight-systems-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-nvcc-12-8/unknown,now 12.8.93-1 amd64 [installed,automatic]
    cuda-nvdisasm-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-nvml-dev-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-nvprof-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-nvprune-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-nvrtc-12-8/unknown,now 12.8.93-1 amd64 [installed,automatic]
    cuda-nvrtc-dev-12-8/unknown,now 12.8.93-1 amd64 [installed,automatic]
    cuda-nvtx-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-nvvm-12-8/unknown,now 12.8.93-1 amd64 [installed,automatic]
    cuda-nvvp-12-8/unknown,now 12.8.93-1 amd64 [installed,automatic]
    cuda-opencl-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-opencl-dev-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-profiler-api-12-8/unknown,now 12.8.90-1 amd64 [installed,automatic]
    cuda-sanitizer-12-8/unknown,now 12.8.93-1 amd64 [installed,automatic]
    cuda-toolkit-12-8-config-common/unknown,now 12.8.90-1 all [installed,automatic]
    cuda-toolkit-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-toolkit-12-config-common/unknown,now 12.8.90-1 all [installed,automatic]
    cuda-toolkit-config-common/unknown,now 12.8.90-1 all [installed,automatic]
    cuda-toolkit/unknown,now 12.8.1-1 amd64 [installed]
    cuda-tools-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cuda-visual-tools-12-8/unknown,now 12.8.1-1 amd64 [installed,automatic]
    cudnn9-cuda-12-8/unknown,now 9.8.0.87-1 amd64 [installed,automatic]
    cudnn9-cuda-12/unknown,now 9.8.0.87-1 amd64 [installed,automatic]
    cudnn9/unknown,now 9.8.0-1 amd64 [installed,automatic]
    cudnn/unknown,now 9.8.0-1 amd64 [installed]
    libblas-dev/noble-updates,now 3.12.0-3build1.1 amd64 [installed,automatic]
    libblas3/noble-updates,now 3.12.0-3build1.1 amd64 [installed,automatic]
    libblas64-3/noble-updates,now 3.12.0-3build1.1 amd64 [installed]
    libblas64-dev/noble-updates,now 3.12.0-3build1.1 amd64 [installed]
    libcublas-12-8/unknown,now 12.8.4.1-1 amd64 [installed,automatic]
    libcublas-dev-12-8/unknown,now 12.8.4.1-1 amd64 [installed,automatic]
    libcudnn9-cuda-12/unknown,now 9.8.0.87-1 amd64 [installed,automatic]
    libcudnn9-dev-cuda-12/unknown,now 9.8.0.87-1 amd64 [installed,automatic]
    libcudnn9-samples/unknown,now 9.8.0.87-1 all [installed,automatic]
    libcudnn9-static-cuda-12/unknown,now 9.8.0.87-1 amd64 [installed,automatic]
    libgslcblas0/noble,now 2.7.1+dfsg-6ubuntu2 amd64 [installed]
    libnvidia-cfg1-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    libnvidia-common-570/unknown,now 570.124.06-0ubuntu1 all [installed,automatic]
    libnvidia-compute-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    libnvidia-container-tools/unknown,now 1.17.5-1 amd64 [installed,automatic]
    libnvidia-container1/unknown,now 1.17.5-1 amd64 [installed,automatic]
    libnvidia-decode-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    libnvidia-encode-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    libnvidia-extra-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    libnvidia-fbc1-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    libnvidia-gl-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    libnvinfer10/unknown,now 10.9.0.34-1+cuda12.8 amd64 [installed]
    libopenblas64-0-openmp/noble,now 0.3.26+ds-1 amd64 [installed]
    libopenblas64-0-pthread/noble,now 0.3.26+ds-1 amd64 [installed]
    libopenblas64-0-serial/noble,now 0.3.26+ds-1 amd64 [installed]
    libopenblas64-0/noble,now 0.3.26+ds-1 amd64 [installed]
    nvidia-compute-utils-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-container-toolkit-base/unknown,now 1.17.5-1 amd64 [installed,automatic]
    nvidia-container-toolkit/unknown,now 1.17.5-1 amd64 [installed]
    nvidia-dkms-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-driver-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-firmware-570-570.124.06/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-kernel-common-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-kernel-source-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-modprobe/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-settings/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    nvidia-utils-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]
    xserver-xorg-video-nvidia-570/unknown,now 570.124.06-0ubuntu1 amd64 [installed,automatic]



```python
!nvidia-smi -q
```

    
    ==============NVSMI LOG==============
    
    Timestamp                                 : Fri Mar 28 16:52:10 2025
    Driver Version                            : 570.124.06
    CUDA Version                              : 12.8
    
    Attached GPUs                             : 1
    GPU 00000001:00:00.0
        Product Name                          : Tesla V100-PCIE-16GB
        Product Brand                         : Tesla
        Product Architecture                  : Volta
        Display Mode                          : Enabled
        Display Active                        : Disabled
        Persistence Mode                      : Disabled
        Addressing Mode                       : N/A
        MIG Mode
            Current                           : N/A
            Pending                           : N/A
        Accounting Mode                       : Disabled
        Accounting Mode Buffer Size           : 4000
        Driver Model
            Current                           : N/A
            Pending                           : N/A
        Serial Number                         : 1424719040118
        GPU UUID                              : GPU-a2db1942-76d6-3572-10f1-3d0b0e1fbd72
        Minor Number                          : 0
        VBIOS Version                         : 88.00.4F.00.04
        MultiGPU Board                        : No
        Board ID                              : 0x10000
        Board Part Number                     : 900-2G500-0000-000
        GPU Part Number                       : 1DB4-893-A1
        FRU Part Number                       : N/A
        Platform Info
            Chassis Serial Number             : N/A
            Slot Number                       : N/A
            Tray Index                        : N/A
            Host ID                           : N/A
            Peer Type                         : N/A
            Module Id                         : 1
            GPU Fabric GUID                   : N/A
        Inforom Version
            Image Version                     : G500.0200.00.03
            OEM Object                        : 1.1
            ECC Object                        : 5.0
            Power Management Object           : N/A
        Inforom BBX Object Flush
            Latest Timestamp                  : N/A
            Latest Duration                   : N/A
        GPU Operation Mode
            Current                           : N/A
            Pending                           : N/A
        GPU C2C Mode                          : N/A
        GPU Virtualization Mode
            Virtualization Mode               : Pass-Through
            Host VGPU Mode                    : N/A
            vGPU Heterogeneous Mode           : N/A
        GPU Reset Status
            Reset Required                    : Requested functionality has been deprecated
            Drain and Reset Recommended       : Requested functionality has been deprecated
        GPU Recovery Action                   : None
        GSP Firmware Version                  : N/A
        IBMNPU
            Relaxed Ordering Mode             : N/A
        PCI
            Bus                               : 0x00
            Device                            : 0x00
            Domain                            : 0x0001
            Base Classcode                    : 0x3
            Sub Classcode                     : 0x2
            Device Id                         : 0x1DB410DE
            Bus Id                            : 00000001:00:00.0
            Sub System Id                     : 0x121410DE
            GPU Link Info
                PCIe Generation
                    Max                       : 3
                    Current                   : 3
                    Device Current            : 3
                    Device Max                : 3
                    Host Max                  : N/A
                Link Width
                    Max                       : 16x
                    Current                   : 16x
            Bridge Chip
                Type                          : N/A
                Firmware                      : N/A
            Replays Since Reset               : 0
            Replay Number Rollovers           : 0


            Tx Throughput                     : 50 KB/s


            Rx Throughput                     : 100 KB/s
            Atomic Caps Outbound              : N/A
            Atomic Caps Inbound               : N/A
        Fan Speed                             : N/A
        Performance State                     : P0
        Clocks Event Reasons
            Idle                              : Active
            Applications Clocks Setting       : Not Active
            SW Power Cap                      : Not Active
            HW Slowdown                       : Not Active
                HW Thermal Slowdown           : Not Active
                HW Power Brake Slowdown       : Not Active
            Sync Boost                        : Not Active
            SW Thermal Slowdown               : Not Active
            Display Clock Setting             : Not Active
        Sparse Operation Mode                 : N/A
        FB Memory Usage
            Total                             : 16384 MiB
            Reserved                          : 240 MiB
            Used                              : 1 MiB
            Free                              : 16145 MiB
        BAR1 Memory Usage
            Total                             : 16384 MiB
            Used                              : 2 MiB
            Free                              : 16382 MiB
        Conf Compute Protected Memory Usage
            Total                             : 0 MiB
            Used                              : 0 MiB
            Free                              : 0 MiB
        Compute Mode                          : Default
        Utilization
            GPU                               : 0 %
            Memory                            : 0 %
            Encoder                           : 0 %
            Decoder                           : 0 %
            JPEG                              : N/A
            OFA                               : N/A
        Encoder Stats
            Active Sessions                   : 0
            Average FPS                       : 0
            Average Latency                   : 0
        FBC Stats
            Active Sessions                   : 0
            Average FPS                       : 0
            Average Latency                   : 0
        DRAM Encryption Mode
            Current                           : N/A
            Pending                           : N/A
        ECC Mode
            Current                           : Enabled
            Pending                           : Enabled
        ECC Errors
            Volatile
                Single Bit            
                    Device Memory             : 0
                    Register File             : 0
                    L1 Cache                  : 0
                    L2 Cache                  : 0
                    Texture Memory            : N/A
                    Texture Shared            : N/A
                    CBU                       : N/A
                    Total                     : 0
                Double Bit            
                    Device Memory             : 0
                    Register File             : 0
                    L1 Cache                  : 0
                    L2 Cache                  : 0
                    Texture Memory            : N/A
                    Texture Shared            : N/A
                    CBU                       : 0
                    Total                     : 0
            Aggregate
                Single Bit            
                    Device Memory             : 0
                    Register File             : 0
                    L1 Cache                  : 0
                    L2 Cache                  : 0
                    Texture Memory            : N/A
                    Texture Shared            : N/A
                    CBU                       : N/A
                    Total                     : 0
                Double Bit            
                    Device Memory             : 0
                    Register File             : 0
                    L1 Cache                  : 0
                    L2 Cache                  : 0
                    Texture Memory            : N/A
                    Texture Shared            : N/A
                    CBU                       : 0
                    Total                     : 0
        Retired Pages
            Single Bit ECC                    : 0
            Double Bit ECC                    : 0
            Pending Page Blacklist            : No
        Remapped Rows                         : N/A
        Temperature
            GPU Current Temp                  : 29 C
            GPU T.Limit Temp                  : N/A
            GPU Shutdown Temp                 : 90 C
            GPU Slowdown Temp                 : 87 C
            GPU Max Operating Temp            : 83 C
            GPU Target Temperature            : N/A
            Memory Current Temp               : 27 C
            Memory Max Operating Temp         : 85 C
        GPU Power Readings
            Average Power Draw                : N/A
            Instantaneous Power Draw          : 24.07 W
            Current Power Limit               : 250.00 W
            Requested Power Limit             : 250.00 W
            Default Power Limit               : 250.00 W
            Min Power Limit                   : 100.00 W
            Max Power Limit                   : 250.00 W
        GPU Memory Power Readings 
            Average Power Draw                : N/A
            Instantaneous Power Draw          : N/A
        Module Power Readings
            Average Power Draw                : N/A
            Instantaneous Power Draw          : N/A
            Current Power Limit               : N/A
            Requested Power Limit             : N/A
            Default Power Limit               : N/A
            Min Power Limit                   : N/A
            Max Power Limit                   : N/A
        Power Smoothing                       : N/A
        Workload Power Profiles
            Requested Profiles                : N/A
            Enforced Profiles                 : N/A
        Clocks
            Graphics                          : 135 MHz
            SM                                : 135 MHz
            Memory                            : 877 MHz
            Video                             : 555 MHz
        Applications Clocks
            Graphics                          : 1245 MHz
            Memory                            : 877 MHz
        Default Applications Clocks
            Graphics                          : 1245 MHz
            Memory                            : 877 MHz
        Deferred Clocks
            Memory                            : N/A
        Max Clocks
            Graphics                          : 1380 MHz
            SM                                : 1380 MHz
            Memory                            : 877 MHz
            Video                             : 1237 MHz
        Max Customer Boost Clocks
            Graphics                          : 1380 MHz
        Clock Policy
            Auto Boost                        : N/A
            Auto Boost Default                : N/A
        Voltage
            Graphics                          : N/A
        Fabric
            State                             : N/A
            Status                            : N/A
            CliqueId                          : N/A
            ClusterUUID                       : N/A
            Health
                Bandwidth                     : N/A
                Route Recovery in progress    : N/A
                Route Unhealthy               : N/A
                Access Timeout Recovery       : N/A
        Processes                             : None
        Capabilities
            EGM                               : disabled
    



```python
!poetry show
```

    [36mabsl-py                      [39m [39;1m2.1.0         [39;22m Abseil Python Common Libraries...
    [36malabaster                    [39m [39;1m1.0.0         [39;22m A light, configurable Sphinx t...
    [36maltair                       [39m [39;1m5.5.0         [39;22m Vega-Altair: A declarative sta...
    [36manyio                        [39m [39;1m4.9.0         [39;22m High level compatibility layer...
    [36margon2-cffi                  [39m [39;1m23.1.0        [39;22m Argon2 for Python
    [36margon2-cffi-bindings         [39m [39;1m21.2.0        [39;22m Low-level CFFI bindings for Ar...
    [36margparse                     [39m [39;1m1.4.0         [39;22m Python command-line parsing li...
    [36marray-record                 [39m [39;1m0.7.1         [39;22m A file format that achieves a ...
    [36marrow                        [39m [39;1m1.3.0         [39;22m Better dates & times for Python
    [36mastroid                      [39m [39;1m3.3.9         [39;22m An abstract syntax tree for Py...
    [36masttokens                    [39m [39;1m3.0.0         [39;22m Annotate AST trees with source...
    [36mastunparse                   [39m [39;1m1.6.3         [39;22m An AST unparser for Python
    [36masync-lru                    [39m [39;1m2.0.5         [39;22m Simple LRU cache for asyncio
    [36mattrs                        [39m [39;1m25.3.0        [39;22m Classes Without Boilerplate
    [36mautopep8                     [39m [39;1m2.3.2         [39;22m A tool that automatically form...
    [36mbabel                        [39m [39;1m2.17.0        [39;22m Internationalization utilities
    [36mbeautifulsoup4               [39m [39;1m4.13.3        [39;22m Screen-scraping library
    [36mblack                        [39m [39;1m25.1.0        [39;22m The uncompromising code format...
    [36mbleach                       [39m [39;1m6.2.0         [39;22m An easy safelist-based HTML-sa...
    [36mblinker                      [39m [39;1m1.9.0         [39;22m Fast, simple object-to-object ...
    [36mbump2version                 [39m [39;1m1.0.1         [39;22m Version-bump your software wit...
    [36mbumpversion                  [39m [39;1m0.6.0         [39;22m Version-bump your software wit...
    [36mcertifi                      [39m [39;1m2025.1.31     [39;22m Python package for providing M...
    [36mcffi                         [39m [39;1m1.17.1        [39;22m Foreign Function Interface for...
    [36mcharset-normalizer           [39m [39;1m3.4.1         [39;22m The Real First Universal Chars...
    [36mclick                        [39m [39;1m8.1.8         [39;22m Composable command line interf...
    [36mcolorama                     [39m [39;1m0.4.6         [39;22m Cross-platform colored termina...
    [36mcomm                         [39m [39;1m0.2.2         [39;22m Jupyter Python Comm implementa...
    [36mcontourpy                    [39m [39;1m1.3.1         [39;22m Python library for calculating...
    [36mcoverage                     [39m [39;1m7.7.0         [39;22m Code coverage measurement for ...
    [36mcryptography                 [39m [39;1m44.0.2        [39;22m cryptography is a package whic...
    [36mcycler                       [39m [39;1m0.12.1        [39;22m Composable style cycles
    [36mdebugpy                      [39m [39;1m1.8.13        [39;22m An implementation of the Debug...
    [36mdecorator                    [39m [39;1m5.2.1         [39;22m Decorators for Humans
    [36mdefusedxml                   [39m [39;1m0.7.1         [39;22m XML bomb protection for Python...
    [36mdill                         [39m [39;1m0.3.9         [39;22m serialize all of Python
    [36mdm-tree                      [39m [39;1m0.1.9         [39;22m Tree is a library for working ...
    [36mdocopt                       [39m [39;1m0.6.2         [39;22m Pythonic argument parser, that...
    [36mdocstring-parser             [39m [39;1m0.16          [39;22m Parse Python docstrings in reS...
    [36mdocstring-to-markdown        [39m [39;1m0.15          [39;22m On the fly conversion of Pytho...
    [36mdocutils                     [39m [39;1m0.21.2        [39;22m Docutils -- Python Documentati...
    [36meinops                       [39m [39;1m0.8.1         [39;22m A new flavour of deep learning...
    [36met-xmlfile                   [39m [39;1m2.0.0         [39;22m An implementation of lxml.xmlf...
    [36metils                        [39m [39;1m1.12.2        [39;22m Collection of common python utils
    [36mexecuting                    [39m [39;1m2.2.0         [39;22m Get the currently executing AS...
    [36mfastjsonschema               [39m [39;1m2.21.1        [39;22m Fastest Python implementation ...
    [36mflake8                       [39m [39;1m7.1.2         [39;22m the modular source code checke...
    [36mflask                        [39m [39;1m3.1.0         [39;22m A simple framework for buildin...
    [36mflatbuffers                  [39m [39;1m25.2.10       [39;22m The FlatBuffers serialization ...
    [36mfonttools                    [39m [39;1m4.56.0        [39;22m Tools to manipulate font files
    [36mfqdn                         [39m [39;1m1.5.1         [39;22m Validates fully-qualified doma...
    [36mfsspec                       [39m [39;1m2025.3.0      [39;22m File-system specification
    [36mgast                         [39m [39;1m0.6.0         [39;22m Python AST that abstracts the ...
    [36mgoogle-pasta                 [39m [39;1m0.2.0         [39;22m pasta is an AST-based Python r...
    [36mgoogleapis-common-protos     [39m [39;1m1.69.2        [39;22m Common protobufs used in Googl...
    [36mgraphframes                  [39m [39;1m0.6           [39;22m GraphFrames: DataFrame-based G...
    [36mgraphviz                     [39m [39;1m0.20.3        [39;22m Simple Python interface for Gr...
    [36mgreenlet                     [39m [39;1m3.1.1         [39;22m Lightweight in-process concurr...
    [36mgrpcio                       [39m [39;1m1.71.0        [39;22m HTTP/2-based RPC framework
    [36mh11                          [39m [39;1m0.14.0        [39;22m A pure-Python, bring-your-own-...
    [36mh5py                         [39m [39;1m3.13.0        [39;22m Read and write HDF5 files from...
    [36mhttpcore                     [39m [39;1m1.0.7         [39;22m A minimal low-level HTTP client.
    [36mhttpx                        [39m [39;1m0.28.1        [39;22m The next generation HTTP client.
    [36micecream                     [39m [39;1m2.1.4         [39;22m Never use print() to debug aga...
    [36mid                           [39m [39;1m1.5.0         [39;22m A tool for generating OIDC ide...
    [36midna                         [39m [39;1m3.10          [39;22m Internationalized Domain Names...
    [36migraph                       [39m [39;1m0.11.8        [39;22m High performance graph data st...
    [36mimagesize                    [39m [39;1m1.4.1         [39;22m Getting image size from png/jp...
    [36mimmutabledict                [39m [39;1m4.2.1         [39;22m Immutable wrapper around dicti...
    [36mimportlib-resources          [39m [39;1m6.5.2         [39;22m Read resources from Python pac...
    [36miniconfig                    [39m [39;1m2.0.0         [39;22m brain-dead simple config-ini p...
    [36mipykernel                    [39m [39;1m6.29.5        [39;22m IPython Kernel for Jupyter
    [36mipython                      [39m [39;1m9.0.2         [39;22m IPython: Productive Interactiv...
    [36mipython-bg                   [39m [39;1m0.2           [39;22m IPython magic to run jobs in b...
    [36mipython-pygments-lexers      [39m [39;1m1.1.1         [39;22m Defines a variety of Pygments ...
    [36mipywidgets                   [39m [39;1m8.1.5         [39;22m Jupyter interactive widgets
    [36miso3166                      [39m [39;1m2.1.1         [39;22m Self-contained ISO 3166-1 coun...
    [36misoduration                  [39m [39;1m20.11.0       [39;22m Operations with ISO 8601 durat...
    [36misort                        [39m [39;1m6.0.1         [39;22m A Python utility / library to ...
    [36mitsdangerous                 [39m [39;1m2.2.0         [39;22m Safely pass data to untrusted ...
    [36mjaraco-classes               [39m [39;1m3.4.0         [39;22m Utility functions for Python c...
    [36mjaraco-context               [39m [39;1m6.0.1         [39;22m Useful decorators and context ...
    [36mjaraco-functools             [39m [39;1m4.1.0         [39;22m Functools like those found in ...
    [36mjedi                         [39m [39;1m0.19.2        [39;22m An autocompletion tool for Pyt...
    [36mjeepney                      [39m [39;1m0.9.0         [39;22m Low-level, pure Python DBus pr...
    [36mjinja2                       [39m [39;1m3.1.6         [39;22m A very fast and expressive tem...
    [36mjoblib                       [39m [39;1m1.4.2         [39;22m Lightweight pipelining with Py...
    [36mjson5                        [39m [39;1m0.10.0        [39;22m A Python implementation of the...
    [36mjsonpickle                   [39m [39;1m4.0.2         [39;22m jsonpickle encodes/decodes any...
    [36mjsonpointer                  [39m [39;1m3.0.0         [39;22m Identify specific nodes in a J...
    [36mjsonschema                   [39m [39;1m4.23.0        [39;22m An implementation of JSON Sche...
    [36mjsonschema-specifications    [39m [39;1m2024.10.1     [39;22m The JSON Schema meta-schemas a...
    [36mjupyter                      [39m [39;1m1.1.1         [39;22m Jupyter metapackage. Install a...
    [36mjupyter-client               [39m [39;1m8.6.3         [39;22m Jupyter protocol implementatio...
    [36mjupyter-console              [39m [39;1m6.6.3         [39;22m Jupyter terminal console
    [36mjupyter-core                 [39m [39;1m5.7.2         [39;22m Jupyter core package. A base p...
    [36mjupyter-events               [39m [39;1m0.12.0        [39;22m Jupyter Event System library
    [36mjupyter-lsp                  [39m [39;1m2.2.5         [39;22m Multi-Language Server WebSocke...
    [36mjupyter-server               [39m [39;1m2.15.0        [39;22m The backend—i.e. core services...
    [36mjupyter-server-terminals     [39m [39;1m0.5.3         [39;22m A Jupyter Server Extension Pro...
    [36mjupyterlab                   [39m [39;1m4.3.6         [39;22m JupyterLab computational envir...
    [36mjupyterlab-lsp               [39m [39;1m5.1.0         [39;22m Coding assistance for JupyterL...
    [36mjupyterlab-pygments          [39m [39;1m0.3.0         [39;22m Pygments theme using JupyterLa...
    [36mjupyterlab-server            [39m [39;1m2.27.3        [39;22m A set of server components for...
    [36mjupyterlab-widgets           [39m [39;1m3.0.13        [39;22m Jupyter interactive widgets fo...
    [36mjupytext                     [39m [39;1m1.16.7        [39;22m Jupyter notebooks as Markdown ...
    [36mkeras                        [39m [39;1m3.9.0         [39;22m Multi-backend Keras
    [36mkeyring                      [39m [39;1m25.6.0        [39;22m Store and access your password...
    [36mkiwisolver                   [39m [39;1m1.4.8         [39;22m A fast implementation of the C...
    [36mlibclang                     [39m [39;1m18.1.1        [39;22m Clang Python Bindings, mirrore...
    [36mlinecache2                   [39m [39;1m1.0.0         [39;22m Backports of the linecache module
    [36mlux-api                      [39m [39;1m0.5.1         [39;22m A Python API for Intelligent D...
    [36mlux-widget                   [39m [39;1m0.1.11        [39;22m A Custom Jupyter Widget Library
    [36mlxml                         [39m [39;1m5.3.1         [39;22m Powerful and Pythonic XML proc...
    [36mmarkdown                     [39m [39;1m3.7           [39;22m Python implementation of John ...
    [36mmarkdown-it-py               [39m [39;1m3.0.0         [39;22m Python port of markdown-it. Ma...
    [36mmarkupsafe                   [39m [39;1m3.0.2         [39;22m Safely add untrusted strings t...
    [36mmatplotlib                   [39m [39;1m3.10.1        [39;22m Python plotting package
    [36mmatplotlib-inline            [39m [39;1m0.1.7         [39;22m Inline Matplotlib backend for ...
    [36mmccabe                       [39m [39;1m0.7.0         [39;22m McCabe checker, plugin for flake8
    [36mmdit-py-plugins              [39m [39;1m0.4.2         [39;22m Collection of plugins for mark...
    [36mmdurl                        [39m [39;1m0.1.2         [39;22m Markdown URL utilities
    [36mmistune                      [39m [39;1m3.1.3         [39;22m A sane and fast Markdown parse...
    [36mml-dtypes                    [39m [39;1m0.5.1         [39;22m 
    [36mmock                         [39m [39;1m5.2.0         [39;22m Rolling backport of unittest.m...
    [36mmore-itertools               [39m [39;1m10.6.0        [39;22m More routines for operating on...
    [36mmpmath                       [39m [39;1m1.3.0         [39;22m Python library for arbitrary-p...
    [36mmypy                         [39m [39;1m1.15.0        [39;22m Optional static typing for Python
    [36mmypy-extensions              [39m [39;1m1.0.0         [39;22m Type system extensions for pro...
    [36mmysql-connector-python       [39m [39;1m9.2.0         [39;22m A self-contained Python driver...
    [36mmysqlclient                  [39m [39;1m2.2.7         [39;22m Python interface to MySQL
    [36mnamex                        [39m [39;1m0.0.8         [39;22m A simple utility to separate t...
    [36mnarwhals                     [39m [39;1m1.31.0        [39;22m Extremely lightweight compatib...
    [36mnbclient                     [39m [39;1m0.10.2        [39;22m A client library for executing...
    [36mnbconvert                    [39m [39;1m7.16.6        [39;22m Converting Jupyter Notebooks (...
    [36mnbformat                     [39m [39;1m5.10.4        [39;22m The Jupyter Notebook format
    [36mnbsphinx                     [39m [39;1m0.9.7         [39;22m Jupyter Notebook Tools for Sphinx
    [36mnest-asyncio                 [39m [39;1m1.6.0         [39;22m Patch asyncio to allow nested ...
    [36mnetworkx                     [39m [39;1m3.4.2         [39;22m Python package for creating an...
    [36mnh3                          [39m [39;1m0.2.21        [39;22m Python binding to Ammonia HTML...
    [36mnodeenv                      [39m [39;1m1.9.1         [39;22m Node.js virtual environment bu...
    [36mnodejs                       [39m [39;1m0.1.1         [39;22m Python bindings and utils for ...
    [36mnose                         [39m [39;1m1.3.7         [39;22m nose extends unittest to make ...
    [36mnotebook                     [39m [39;1m7.3.3         [39;22m Jupyter Notebook - A web-based...
    [36mnotebook-shim                [39m [39;1m0.2.4         [39;22m A shim layer for notebook trai...
    [36mnumpy                        [39m [39;1m2.1.3         [39;22m Fundamental package for array ...
    [36mnvidia-cublas-cu12           [39m [39;1m12.5.3.2      [39;22m CUBLAS native runtime libraries
    [36mnvidia-cuda-cupti-cu12       [39m [39;1m12.5.82       [39;22m CUDA profiling tools runtime l...
    [36mnvidia-cuda-nvcc-cu12        [39m [39;1m12.5.82       [39;22m CUDA nvcc
    [36mnvidia-cuda-nvrtc-cu12       [39m [39;1m12.5.82       [39;22m NVRTC native runtime libraries
    [36mnvidia-cuda-runtime-cu12     [39m [39;1m12.5.82       [39;22m CUDA Runtime native Libraries
    [36mnvidia-cudnn-cu12            [39m [39;1m9.3.0.75      [39;22m cuDNN runtime libraries
    [36mnvidia-cufft-cu12            [39m [39;1m11.2.3.61     [39;22m CUFFT native runtime libraries
    [36mnvidia-curand-cu12           [39m [39;1m10.3.6.82     [39;22m CURAND native runtime libraries
    [36mnvidia-cusolver-cu12         [39m [39;1m11.6.3.83     [39;22m CUDA solver native runtime lib...
    [36mnvidia-cusparse-cu12         [39m [39;1m12.5.1.3      [39;22m CUSPARSE native runtime libraries
    [36mnvidia-ml-py                 [39m [39;1m12.570.86     [39;22m Python Bindings for the NVIDIA...
    [36mnvidia-nccl-cu12             [39m [39;1m2.23.4        [39;22m NVIDIA Collective Communicatio...
    [36mnvidia-nvjitlink-cu12        [39m [39;1m12.5.82       [39;22m Nvidia JIT LTO Library
    [36moauthlib                     [39m [39;1m3.2.2         [39;22m A generic, spec-compliant, tho...
    [36mopenpyxl                     [39m [39;1m3.1.5         [39;22m A Python library to read/write...
    [36mopt-einsum                   [39m [39;1m3.4.0         [39;22m Path optimization of einsum fu...
    [36moptional-django              [39m [39;1m0.1.0         [39;22m Utils for apps to provide opti...
    [36moptree                       [39m [39;1m0.14.1        [39;22m Optimized PyTree Utilities.
    [36moverrides                    [39m [39;1m7.7.0         [39;22m A decorator to automatically d...
    [36mpackaging                    [39m [39;1m24.2          [39;22m Core utilities for Python pack...
    [36mpandas                       [39m [39;1m2.2.3         [39;22m Powerful data structures for d...
    [36mpandas-datareader            [39m [39;1m0.10.0        [39;22m Data readers extracted from th...
    [36mpandocfilters                [39m [39;1m1.5.1         [39;22m Utilities for writing pandoc f...
    [36mparso                        [39m [39;1m0.8.4         [39;22m A Python Parser
    [36mpathspec                     [39m [39;1m0.12.1        [39;22m Utility library for gitignore ...
    [36mpexpect                      [39m [39;1m4.9.0         [39;22m Pexpect allows easy control of...
    [36mpillow                       [39m [39;1m11.1.0        [39;22m Python Imaging Library (Fork)
    [36mpiny                         [39m [39;1m1.1.0         [39;22m Load YAML configs with environ...
    [36mpip                          [39m [39;1m25.0.1        [39;22m The PyPA recommended tool for ...
    [36mpipreqs                      [39m [39;1m0.4.13        [39;22m Pip requirements.txt generator...
    [36mplatformdirs                 [39m [39;1m4.3.6         [39;22m A small Python package for det...
    [36mplotly                       [39m [39;1m6.0.1         [39;22m An open-source interactive dat...
    [36mpluggy                       [39m [39;1m1.5.0         [39;22m plugin and hook calling mechan...
    [36mprometheus-client            [39m [39;1m0.21.1        [39;22m Python client for the Promethe...
    [36mpromise                      [39m [39;1m2.3           [39;22m Promises/A+ implementation for...
    [36mprompt-toolkit               [39m [39;1m3.0.50        [39;22m Library for building powerful ...
    [36mprotobuf                     [39m [39;1m5.29.3        [39;22m 
    [36mpsutil                       [39m [39;1m7.0.0         [39;22m Cross-platform lib for process...
    [36mpsycopg2-binary              [39m [39;1m2.9.10        [39;22m psycopg2 - Python-PostgreSQL D...
    [36mptyprocess                   [39m [39;1m0.7.0         [39;22m Run a subprocess in a pseudo t...
    [36mpure-eval                    [39m [39;1m0.2.3         [39;22m Safely evaluate AST nodes with...
    [36mpy                           [39m [39;1m1.11.0        [39;22m library with cross-python path...
    [36mpyarrow                      [39m [39;1m19.0.1        [39;22m Python library for Apache Arrow
    [36mpycodestyle                  [39m [39;1m2.12.1        [39;22m Python style guide checker
    [36mpycparser                    [39m [39;1m2.22          [39;22m C parser in Python
    [36mpydot                        [39m [39;1m3.0.4         [39;22m Python interface to Graphviz's...
    [36mpyflakes                     [39m [39;1m3.2.0         [39;22m passive checker of Python prog...
    [36mpygments                     [39m [39;1m2.19.1        [39;22m Pygments is a syntax highlight...
    [36mpylint                       [39m [39;1m3.3.5         [39;22m python code static checker
    [36mpynvml                       [39m [39;1m12.0.0        [39;22m Python utilities for the NVIDI...
    [36mpyparsing                    [39m [39;1m3.2.1         [39;22m pyparsing module - Classes and...
    [36mpyproject-flake8             [39m [39;1m0.0.1a4       [39;22m pyproject-flake8 (`pflake8`), ...
    [36mpyright                      [39m [39;1m1.1.397       [39;22m Command line wrapper for pyright
    [36mpytest                       [39m [39;1m8.3.5         [39;22m pytest: simple powerful testin...
    [36mpytest-cov                   [39m [39;1m6.0.0         [39;22m Pytest plugin for measuring co...
    [36mpytest-flask                 [39m [39;1m1.3.0         [39;22m A set of py.test fixtures to t...
    [36mpython-dateutil              [39m [39;1m2.9.0.post0   [39;22m Extensions to the standard Pyt...
    [36mpython-json-logger           [39m [39;1m3.3.0         [39;22m JSON Log Formatter for the Pyt...
    [36mpython-lsp-black             [39m [39;1m2.0.0         [39;22m Black plugin for the Python LS...
    [36mpython-lsp-jsonrpc           [39m [39;1m1.1.2         [39;22m JSON RPC 2.0 server library
    [36mpython-lsp-server            [39m [39;1m1.12.2        [39;22m Python Language Server for the...
    [36mpytoolconfig                 [39m [39;1m1.3.1         [39;22m Python tool configuration
    [36mpytz                         [39m [39;1m2025.1        [39;22m World timezone definitions, mo...
    [36mpyvis                        [39m [39;1m0.3.2         [39;22m A Python network graph visuali...
    [36mpyyaml                       [39m [39;1m6.0.2         [39;22m YAML parser and emitter for Py...
    [36mpyzmq                        [39m [39;1m26.3.0        [39;22m Python bindings for 0MQ
    [36mreadme-renderer              [39m [39;1m44.0          [39;22m readme_renderer is a library f...
    [36mreferencing                  [39m [39;1m0.36.2        [39;22m JSON Referencing + Python
    [36mrequests                     [39m [39;1m2.32.3        [39;22m Python HTTP for Humans.
    [36mrequests-oauthlib            [39m [39;1m2.0.0         [39;22m OAuthlib authentication suppor...
    [36mrequests-toolbelt            [39m [39;1m1.0.0         [39;22m A utility belt for advanced us...
    [36mrfc3339-validator            [39m [39;1m0.1.4         [39;22m A pure python RFC3339 validator
    [36mrfc3986                      [39m [39;1m2.0.0         [39;22m Validating URI References per ...
    [36mrfc3986-validator            [39m [39;1m0.1.1         [39;22m Pure python rfc3986 validator
    [36mrich                         [39m [39;1m13.9.4        [39;22m Render rich text, tables, prog...
    [36mrootpath                     [39m [39;1m0.2.1 813ccf0 [39;22m Python project/package root pa...
    [36mrope                         [39m [39;1m1.13.0        [39;22m a python refactoring library...
    [36mrpds-py                      [39m [39;1m0.23.1        [39;22m Python bindings to Rust's pers...
    [36mruff                         [39m [39;1m0.11.0        [39;22m An extremely fast Python linte...
    [36mscikit-learn                 [39m [39;1m1.6.1         [39;22m A set of python modules for ma...
    [36mscipy                        [39m [39;1m1.15.2        [39;22m Fundamental algorithms for sci...
    [36mseaborn                      [39m [39;1m0.13.2        [39;22m Statistical data visualization
    [36msecretstorage                [39m [39;1m3.3.3         [39;22m Python bindings to FreeDesktop...
    [36msend2trash                   [39m [39;1m1.8.3         [39;22m Send file to trash natively un...
    [36msetuptools                   [39m [39;1m76.1.0        [39;22m Easily download, build, instal...
    [36msh                           [39m [39;1m2.2.2         [39;22m Python subprocess replacement
    [36msimple-parsing               [39m [39;1m0.1.7         [39;22m A small utility for simplifyin...
    [36msix                          [39m [39;1m1.17.0        [39;22m Python 2 and 3 compatibility u...
    [36msniffio                      [39m [39;1m1.3.1         [39;22m Sniff out which async library ...
    [36msnowballstemmer              [39m [39;1m2.2.0         [39;22m This package provides 29 stemm...
    [36msoupsieve                    [39m [39;1m2.6           [39;22m A modern CSS selector implemen...
    [36msphinx                       [39m [39;1m8.1.3         [39;22m Python documentation generator
    [36msphinx-autoapi               [39m [39;1m3.6.0         [39;22m Sphinx API documentation gener...
    [36msphinx-rtd-theme             [39m [39;1m3.0.2         [39;22m Read the Docs theme for Sphinx
    [36msphinxcontrib-applehelp      [39m [39;1m2.0.0         [39;22m sphinxcontrib-applehelp is a S...
    [36msphinxcontrib-devhelp        [39m [39;1m2.0.0         [39;22m sphinxcontrib-devhelp is a sph...
    [36msphinxcontrib-htmlhelp       [39m [39;1m2.1.0         [39;22m sphinxcontrib-htmlhelp is a sp...
    [36msphinxcontrib-jquery         [39m [39;1m4.1           [39;22m Extension to include jQuery on...
    [36msphinxcontrib-jsmath         [39m [39;1m1.0.1         [39;22m A sphinx extension which rende...
    [36msphinxcontrib-qthelp         [39m [39;1m2.0.0         [39;22m sphinxcontrib-qthelp is a sphi...
    [36msphinxcontrib-serializinghtml[39m [39;1m2.0.0         [39;22m sphinxcontrib-serializinghtml ...
    [36msqlalchemy                   [39m [39;1m2.0.39        [39;22m Database Abstraction Library
    [36mstack-data                   [39m [39;1m0.6.3         [39;22m Extract data from python stack...
    [36msympy                        [39m [39;1m1.13.1        [39;22m Computer algebra system (CAS) ...
    [36mtensorboard                  [39m [39;1m2.19.0        [39;22m TensorBoard lets you watch Ten...
    [36mtensorboard-data-server      [39m [39;1m0.7.2         [39;22m Fast data loading for TensorBoard
    [36mtensorflow                   [39m [39;1m2.19.0        [39;22m TensorFlow is an open source m...
    [36mtensorflow-datasets          [39m [39;1m4.9.8         [39;22m tensorflow/datasets is a libra...
    [36mtensorflow-hub               [39m [39;1m0.16.1        [39;22m TensorFlow Hub is a library to...
    [36mtensorflow-metadata          [39m [39;1m1.16.1        [39;22m Library and standards for sche...
    [36mtermcolor                    [39m [39;1m2.5.0         [39;22m ANSI color formatting for outp...
    [36mterminado                    [39m [39;1m0.18.1        [39;22m Tornado websocket backend for ...
    [36mtexttable                    [39m [39;1m1.7.0         [39;22m module to create simple ASCII ...
    [36mtf-keras                     [39m [39;1m2.19.0        [39;22m Deep learning for humans.
    [36mthreadpoolctl                [39m [39;1m3.6.0         [39;22m threadpoolctl
    [36mtinycss2                     [39m [39;1m1.4.0         [39;22m A tiny CSS parser
    [36mtokenize-rt                  [39m [39;1m6.1.0         [39;22m A wrapper around the stdlib `t...
    [36mtoml                         [39m [39;1m0.10.2        [39;22m Python Library for Tom's Obvio...
    [36mtomlkit                      [39m [39;1m0.13.2        [39;22m Style preserving TOML library
    [36mtornado                      [39m [39;1m6.4.2         [39;22m Tornado is a Python web framew...
    [36mtqdm                         [39m [39;1m4.67.1        [39;22m Fast, Extensible Progress Meter
    [36mtraceback2                   [39m [39;1m1.4.0         [39;22m Backports of the traceback module
    [36mtraitlets                    [39m [39;1m5.14.3        [39;22m Traitlets Python configuration...
    [36mtwine                        [39m [39;1m6.1.0         [39;22m Collection of utilities for pu...
    [36mtypes-python-dateutil        [39m [39;1m2.9.0.20241206[39;22m Typing stubs for python-dateutil
    [36mtyping-extensions            [39m [39;1m4.12.2        [39;22m Backported and Experimental Ty...
    [36mtzdata                       [39m [39;1m2025.1        [39;22m Provider of IANA time zone data
    [36mujson                        [39m [39;1m5.10.0        [39;22m Ultra fast JSON encoder and de...
    [36munittest2                    [39m [39;1m1.1.0         [39;22m The new features in unittest b...
    [36muri-template                 [39m [39;1m1.3.0         [39;22m RFC 6570 URI Template Processor
    [36murllib3                      [39m [39;1m2.3.0         [39;22m HTTP library with thread-safe ...
    [36mwcwidth                      [39m [39;1m0.2.13        [39;22m Measures the displayed width o...
    [36mwebcolors                    [39m [39;1m24.11.1       [39;22m A library for working with the...
    [36mwebencodings                 [39m [39;1m0.5.1         [39;22m Character encoding aliases for...
    [36mwebsocket-client             [39m [39;1m1.8.0         [39;22m WebSocket client for Python wi...
    [36mwerkzeug                     [39m [39;1m3.1.3         [39;22m The comprehensive WSGI web app...
    [36mwhatthepatch                 [39m [39;1m1.0.7         [39;22m A patch parsing and applicatio...
    [36mwheel                        [39m [39;1m0.45.1        [39;22m A built-package format for Python
    [36mwidgetsnbextension           [39m [39;1m4.0.13        [39;22m Jupyter interactive widgets fo...
    [36mwrapt                        [39m [39;1m1.17.2        [39;22m Module for decorators, wrapper...
    [36myapf                         [39m [39;1m0.43.0        [39;22m A formatter for Python code
    [36myarg                         [39m [39;1m0.1.10        [39;22m A semi hard Cornish cheese, al...
    [36mzipp                         [39m [39;1m3.21.0        [39;22m Backport of pathlib-compatible...



```python
!poetry show --tree
```

    [36mautopep8[39m [39;1m2.3.2[39;22m A tool that automatically formats Python code to conform to the PEP 8 style guide
    └── [33mpycodestyle[39m >=2.12.0
    [36mblack[39m [39;1m25.1.0[39;22m The uncompromising code formatter.
    ├── [33mclick[39m >=8.0.0
    │   └── [32mcolorama[39m * 
    ├── [33mipython[39m >=7.8.0
    │   ├── [32mcolorama[39m * 
    │   ├── [32mdecorator[39m * 
    │   ├── [32mipython-pygments-lexers[39m * 
    │   │   └── [35mpygments[39m * 
    │   ├── [32mjedi[39m >=0.16 
    │   │   └── [35mparso[39m >=0.8.4,<0.9.0 
    │   ├── [32mmatplotlib-inline[39m * 
    │   │   └── [35mtraitlets[39m * 
    │   ├── [32mpexpect[39m >4.3 
    │   │   └── [35mptyprocess[39m >=0.5 
    │   ├── [32mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   └── [35mwcwidth[39m * 
    │   ├── [32mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   ├── [32mstack-data[39m * 
    │   │   ├── [35masttokens[39m >=2.1.0 
    │   │   ├── [35mexecuting[39m >=1.2.0 
    │   │   └── [35mpure-eval[39m * 
    │   └── [32mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    ├── [33mmypy-extensions[39m >=0.4.3
    ├── [33mpackaging[39m >=22.0
    ├── [33mpathspec[39m >=0.9.0
    ├── [33mplatformdirs[39m >=2
    └── [33mtokenize-rt[39m >=3.2.0
    [36mbumpversion[39m [39;1m0.6.0[39;22m Version-bump your software with a single command!
    └── [33mbump2version[39m *
    [36mclick[39m [39;1m8.1.8[39;22m Composable command line interface toolkit
    └── [33mcolorama[39m *
    [36mcolorama[39m [39;1m0.4.6[39;22m Cross-platform colored terminal text.
    [36mcoverage[39m [39;1m7.7.0[39;22m Code coverage measurement for Python
    [36mflake8[39m [39;1m7.1.2[39;22m the modular source code checker: pep8 pyflakes and co
    ├── [33mmccabe[39m >=0.7.0,<0.8.0
    ├── [33mpycodestyle[39m >=2.12.0,<2.13.0
    └── [33mpyflakes[39m >=3.2.0,<3.3.0
    [36mgraphframes[39m [39;1m0.6[39;22m GraphFrames: DataFrame-based Graphs
    ├── [33mnose[39m *
    └── [33mnumpy[39m *
    [36mgraphviz[39m [39;1m0.20.3[39;22m Simple Python interface for Graphviz
    [36mh5py[39m [39;1m3.13.0[39;22m Read and write HDF5 files from Python
    └── [33mnumpy[39m >=1.19.3
    [36micecream[39m [39;1m2.1.4[39;22m Never use print() to debug again; inspect variables, expressions, and program execution with a single, simple function call.
    ├── [33masttokens[39m >=2.0.1
    ├── [33mcolorama[39m >=0.3.9
    ├── [33mexecuting[39m >=2.1.0
    └── [33mpygments[39m >=2.2.0
    [36migraph[39m [39;1m0.11.8[39;22m High performance graph data structures and algorithms
    └── [33mtexttable[39m >=1.6.2
    [36mipykernel[39m [39;1m6.29.5[39;22m IPython Kernel for Jupyter
    ├── [33mappnope[39m *
    ├── [33mcomm[39m >=0.1.1
    │   └── [32mtraitlets[39m >=4 
    ├── [33mdebugpy[39m >=1.6.5
    ├── [33mipython[39m >=7.23.1
    │   ├── [32mcolorama[39m * 
    │   ├── [32mdecorator[39m * 
    │   ├── [32mipython-pygments-lexers[39m * 
    │   │   └── [35mpygments[39m * 
    │   ├── [32mjedi[39m >=0.16 
    │   │   └── [35mparso[39m >=0.8.4,<0.9.0 
    │   ├── [32mmatplotlib-inline[39m * 
    │   │   └── [35mtraitlets[39m * 
    │   ├── [32mpexpect[39m >4.3 
    │   │   └── [35mptyprocess[39m >=0.5 
    │   ├── [32mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   └── [35mwcwidth[39m * 
    │   ├── [32mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   ├── [32mstack-data[39m * 
    │   │   ├── [35masttokens[39m >=2.1.0 
    │   │   ├── [35mexecuting[39m >=1.2.0 
    │   │   └── [35mpure-eval[39m * 
    │   └── [32mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    ├── [33mjupyter-client[39m >=6.1.12
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   ├── [35mplatformdirs[39m >=2.5 
    │   │   ├── [35mpywin32[39m >=300 
    │   │   └── [35mtraitlets[39m >=5.3 
    │   ├── [32mpython-dateutil[39m >=2.8.2 
    │   │   └── [35msix[39m >=1.5 
    │   ├── [32mpyzmq[39m >=23.0 
    │   │   └── [35mcffi[39m * 
    │   │       └── [34mpycparser[39m * 
    │   ├── [32mtornado[39m >=6.2 
    │   └── [32mtraitlets[39m >=5.3 (circular dependency aborted here)
    ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0
    │   ├── [32mplatformdirs[39m >=2.5 
    │   ├── [32mpywin32[39m >=300 
    │   └── [32mtraitlets[39m >=5.3 
    ├── [33mmatplotlib-inline[39m >=0.1
    │   └── [32mtraitlets[39m * 
    ├── [33mnest-asyncio[39m *
    ├── [33mpackaging[39m *
    ├── [33mpsutil[39m *
    ├── [33mpyzmq[39m >=24
    │   └── [32mcffi[39m * 
    │       └── [35mpycparser[39m * 
    ├── [33mtornado[39m >=6.1
    └── [33mtraitlets[39m >=5.4.0
    [36mipython[39m [39;1m9.0.2[39;22m IPython: Productive Interactive Computing
    ├── [33mcolorama[39m *
    ├── [33mdecorator[39m *
    ├── [33mipython-pygments-lexers[39m *
    │   └── [32mpygments[39m * 
    ├── [33mjedi[39m >=0.16
    │   └── [32mparso[39m >=0.8.4,<0.9.0 
    ├── [33mmatplotlib-inline[39m *
    │   └── [32mtraitlets[39m * 
    ├── [33mpexpect[39m >4.3
    │   └── [32mptyprocess[39m >=0.5 
    ├── [33mprompt-toolkit[39m >=3.0.41,<3.1.0
    │   └── [32mwcwidth[39m * 
    ├── [33mpygments[39m >=2.4.0
    ├── [33mstack-data[39m *
    │   ├── [32masttokens[39m >=2.1.0 
    │   ├── [32mexecuting[39m >=1.2.0 
    │   └── [32mpure-eval[39m * 
    └── [33mtraitlets[39m >=5.13.0
    [36mipython-bg[39m [39;1m0.2[39;22m IPython magic to run jobs in background
    └── [33mipython[39m *
        ├── [32mcolorama[39m * 
        ├── [32mdecorator[39m * 
        ├── [32mipython-pygments-lexers[39m * 
        │   └── [35mpygments[39m * 
        ├── [32mjedi[39m >=0.16 
        │   └── [35mparso[39m >=0.8.4,<0.9.0 
        ├── [32mmatplotlib-inline[39m * 
        │   └── [35mtraitlets[39m * 
        ├── [32mpexpect[39m >4.3 
        │   └── [35mptyprocess[39m >=0.5 
        ├── [32mprompt-toolkit[39m >=3.0.41,<3.1.0 
        │   └── [35mwcwidth[39m * 
        ├── [32mpygments[39m >=2.4.0 (circular dependency aborted here)
        ├── [32mstack-data[39m * 
        │   ├── [35masttokens[39m >=2.1.0 
        │   ├── [35mexecuting[39m >=1.2.0 
        │   └── [35mpure-eval[39m * 
        └── [32mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    [36misort[39m [39;1m6.0.1[39;22m A Python utility / library to sort Python imports.
    [36mjedi[39m [39;1m0.19.2[39;22m An autocompletion tool for Python that can be used for text editors.
    └── [33mparso[39m >=0.8.4,<0.9.0
    [36mjupyter[39m [39;1m1.1.1[39;22m Jupyter metapackage. Install all the Jupyter components in one go.
    ├── [33mipykernel[39m *
    │   ├── [32mappnope[39m * 
    │   ├── [32mcomm[39m >=0.1.1 
    │   │   └── [35mtraitlets[39m >=4 
    │   ├── [32mdebugpy[39m >=1.6.5 
    │   ├── [32mipython[39m >=7.23.1 
    │   │   ├── [35mcolorama[39m * 
    │   │   ├── [35mdecorator[39m * 
    │   │   ├── [35mipython-pygments-lexers[39m * 
    │   │   │   └── [34mpygments[39m * 
    │   │   ├── [35mjedi[39m >=0.16 
    │   │   │   └── [34mparso[39m >=0.8.4,<0.9.0 
    │   │   ├── [35mmatplotlib-inline[39m * 
    │   │   │   └── [34mtraitlets[39m * (circular dependency aborted here)
    │   │   ├── [35mpexpect[39m >4.3 
    │   │   │   └── [34mptyprocess[39m >=0.5 
    │   │   ├── [35mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   └── [34mwcwidth[39m * 
    │   │   ├── [35mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   ├── [35mstack-data[39m * 
    │   │   │   ├── [34masttokens[39m >=2.1.0 
    │   │   │   ├── [34mexecuting[39m >=1.2.0 
    │   │   │   └── [34mpure-eval[39m * 
    │   │   └── [35mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   ├── [32mjupyter-client[39m >=6.1.12 
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   ├── [34mplatformdirs[39m >=2.5 
    │   │   │   ├── [34mpywin32[39m >=300 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mpython-dateutil[39m >=2.8.2 
    │   │   │   └── [34msix[39m >=1.5 
    │   │   ├── [35mpyzmq[39m >=23.0 
    │   │   │   └── [34mcffi[39m * 
    │   │   │       └── [36mpycparser[39m * 
    │   │   ├── [35mtornado[39m >=6.2 
    │   │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   ├── [32mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
    │   ├── [32mnest-asyncio[39m * 
    │   ├── [32mpackaging[39m * 
    │   ├── [32mpsutil[39m * 
    │   ├── [32mpyzmq[39m >=24 (circular dependency aborted here)
    │   ├── [32mtornado[39m >=6.1 (circular dependency aborted here)
    │   └── [32mtraitlets[39m >=5.4.0 (circular dependency aborted here)
    ├── [33mipywidgets[39m *
    │   ├── [32mcomm[39m >=0.1.3 
    │   │   └── [35mtraitlets[39m >=4 
    │   ├── [32mipython[39m >=6.1.0 
    │   │   ├── [35mcolorama[39m * 
    │   │   ├── [35mdecorator[39m * 
    │   │   ├── [35mipython-pygments-lexers[39m * 
    │   │   │   └── [34mpygments[39m * 
    │   │   ├── [35mjedi[39m >=0.16 
    │   │   │   └── [34mparso[39m >=0.8.4,<0.9.0 
    │   │   ├── [35mmatplotlib-inline[39m * 
    │   │   │   └── [34mtraitlets[39m * (circular dependency aborted here)
    │   │   ├── [35mpexpect[39m >4.3 
    │   │   │   └── [34mptyprocess[39m >=0.5 
    │   │   ├── [35mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   └── [34mwcwidth[39m * 
    │   │   ├── [35mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   ├── [35mstack-data[39m * 
    │   │   │   ├── [34masttokens[39m >=2.1.0 
    │   │   │   ├── [34mexecuting[39m >=1.2.0 
    │   │   │   └── [34mpure-eval[39m * 
    │   │   └── [35mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   ├── [32mjupyterlab-widgets[39m >=3.0.12,<3.1.0 
    │   ├── [32mtraitlets[39m >=4.3.1 (circular dependency aborted here)
    │   └── [32mwidgetsnbextension[39m >=4.0.12,<4.1.0 
    ├── [33mjupyter-console[39m *
    │   ├── [32mipykernel[39m >=6.14 
    │   │   ├── [35mappnope[39m * 
    │   │   ├── [35mcomm[39m >=0.1.1 
    │   │   │   └── [34mtraitlets[39m >=4 
    │   │   ├── [35mdebugpy[39m >=1.6.5 
    │   │   ├── [35mipython[39m >=7.23.1 
    │   │   │   ├── [34mcolorama[39m * 
    │   │   │   ├── [34mdecorator[39m * 
    │   │   │   ├── [34mipython-pygments-lexers[39m * 
    │   │   │   │   └── [36mpygments[39m * 
    │   │   │   ├── [34mjedi[39m >=0.16 
    │   │   │   │   └── [36mparso[39m >=0.8.4,<0.9.0 
    │   │   │   ├── [34mmatplotlib-inline[39m * 
    │   │   │   │   └── [36mtraitlets[39m * (circular dependency aborted here)
    │   │   │   ├── [34mpexpect[39m >4.3 
    │   │   │   │   └── [36mptyprocess[39m >=0.5 
    │   │   │   ├── [34mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   │   └── [36mwcwidth[39m * 
    │   │   │   ├── [34mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   │   ├── [34mstack-data[39m * 
    │   │   │   │   ├── [36masttokens[39m >=2.1.0 
    │   │   │   │   ├── [36mexecuting[39m >=1.2.0 
    │   │   │   │   └── [36mpure-eval[39m * 
    │   │   │   └── [34mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-client[39m >=6.1.12 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   │   ├── [36mplatformdirs[39m >=2.5 
    │   │   │   │   ├── [36mpywin32[39m >=300 
    │   │   │   │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   │   ├── [34mpython-dateutil[39m >=2.8.2 
    │   │   │   │   └── [36msix[39m >=1.5 
    │   │   │   ├── [34mpyzmq[39m >=23.0 
    │   │   │   │   └── [36mcffi[39m * 
    │   │   │   │       └── [33mpycparser[39m * 
    │   │   │   ├── [34mtornado[39m >=6.2 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   ├── [35mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
    │   │   ├── [35mnest-asyncio[39m * 
    │   │   ├── [35mpackaging[39m * 
    │   │   ├── [35mpsutil[39m * 
    │   │   ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │   │   ├── [35mtornado[39m >=6.1 (circular dependency aborted here)
    │   │   └── [35mtraitlets[39m >=5.4.0 (circular dependency aborted here)
    │   ├── [32mipython[39m * (circular dependency aborted here)
    │   ├── [32mjupyter-client[39m >=7.0.0 (circular dependency aborted here)
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   ├── [32mprompt-toolkit[39m >=3.0.30 (circular dependency aborted here)
    │   ├── [32mpygments[39m * (circular dependency aborted here)
    │   ├── [32mpyzmq[39m >=17 (circular dependency aborted here)
    │   └── [32mtraitlets[39m >=5.4 (circular dependency aborted here)
    ├── [33mjupyterlab[39m *
    │   ├── [32masync-lru[39m >=1.0.0 
    │   ├── [32mhttpx[39m >=0.25.0 
    │   │   ├── [35manyio[39m * 
    │   │   │   ├── [34midna[39m >=2.8 
    │   │   │   ├── [34msniffio[39m >=1.1 
    │   │   │   └── [34mtyping-extensions[39m >=4.5 
    │   │   ├── [35mcertifi[39m * 
    │   │   ├── [35mhttpcore[39m ==1.* 
    │   │   │   ├── [34mcertifi[39m * (circular dependency aborted here)
    │   │   │   └── [34mh11[39m >=0.13,<0.15 
    │   │   └── [35midna[39m * (circular dependency aborted here)
    │   ├── [32mipykernel[39m >=6.5.0 
    │   │   ├── [35mappnope[39m * 
    │   │   ├── [35mcomm[39m >=0.1.1 
    │   │   │   └── [34mtraitlets[39m >=4 
    │   │   ├── [35mdebugpy[39m >=1.6.5 
    │   │   ├── [35mipython[39m >=7.23.1 
    │   │   │   ├── [34mcolorama[39m * 
    │   │   │   ├── [34mdecorator[39m * 
    │   │   │   ├── [34mipython-pygments-lexers[39m * 
    │   │   │   │   └── [36mpygments[39m * 
    │   │   │   ├── [34mjedi[39m >=0.16 
    │   │   │   │   └── [36mparso[39m >=0.8.4,<0.9.0 
    │   │   │   ├── [34mmatplotlib-inline[39m * 
    │   │   │   │   └── [36mtraitlets[39m * (circular dependency aborted here)
    │   │   │   ├── [34mpexpect[39m >4.3 
    │   │   │   │   └── [36mptyprocess[39m >=0.5 
    │   │   │   ├── [34mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   │   └── [36mwcwidth[39m * 
    │   │   │   ├── [34mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   │   ├── [34mstack-data[39m * 
    │   │   │   │   ├── [36masttokens[39m >=2.1.0 
    │   │   │   │   ├── [36mexecuting[39m >=1.2.0 
    │   │   │   │   └── [36mpure-eval[39m * 
    │   │   │   └── [34mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-client[39m >=6.1.12 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   │   ├── [36mplatformdirs[39m >=2.5 
    │   │   │   │   ├── [36mpywin32[39m >=300 
    │   │   │   │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   │   ├── [34mpython-dateutil[39m >=2.8.2 
    │   │   │   │   └── [36msix[39m >=1.5 
    │   │   │   ├── [34mpyzmq[39m >=23.0 
    │   │   │   │   └── [36mcffi[39m * 
    │   │   │   │       └── [33mpycparser[39m * 
    │   │   │   ├── [34mtornado[39m >=6.2 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   ├── [35mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
    │   │   ├── [35mnest-asyncio[39m * 
    │   │   ├── [35mpackaging[39m * 
    │   │   ├── [35mpsutil[39m * 
    │   │   ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │   │   ├── [35mtornado[39m >=6.1 (circular dependency aborted here)
    │   │   └── [35mtraitlets[39m >=5.4.0 (circular dependency aborted here)
    │   ├── [32mjinja2[39m >=3.0.3 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjupyter-core[39m * (circular dependency aborted here)
    │   ├── [32mjupyter-lsp[39m >=2.0.0 
    │   │   └── [35mjupyter-server[39m >=1.1.2 
    │   │       ├── [34manyio[39m >=3.1.0 (circular dependency aborted here)
    │   │       ├── [34margon2-cffi[39m >=21.1 
    │   │       │   └── [36margon2-cffi-bindings[39m * 
    │   │       │       └── [33mcffi[39m >=1.0.1 (circular dependency aborted here)
    │   │       ├── [34mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │   │       ├── [34mjupyter-client[39m >=7.4.4 (circular dependency aborted here)
    │   │       ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │       ├── [34mjupyter-events[39m >=0.11.0 
    │   │       │   ├── [36mjsonschema[39m >=4.18.0 
    │   │       │   │   ├── [33mattrs[39m >=22.2.0 
    │   │       │   │   ├── [33mfqdn[39m * 
    │   │       │   │   ├── [33midna[39m * (circular dependency aborted here)
    │   │       │   │   ├── [33misoduration[39m * 
    │   │       │   │   │   └── [32marrow[39m >=0.15.0 
    │   │       │   │   │       ├── [35mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │   │       │   │   │       └── [35mtypes-python-dateutil[39m >=2.8.10 
    │   │       │   │   ├── [33mjsonpointer[39m >1.13 
    │   │       │   │   ├── [33mjsonschema-specifications[39m >=2023.03.6 
    │   │       │   │   │   └── [32mreferencing[39m >=0.31.0 
    │   │       │   │   │       ├── [35mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │       │   │   │       ├── [35mrpds-py[39m >=0.7.0 
    │   │       │   │   │       └── [35mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │   │       │   │   ├── [33mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │       │   │   ├── [33mrfc3339-validator[39m * 
    │   │       │   │   │   └── [32msix[39m * (circular dependency aborted here)
    │   │       │   │   ├── [33mrfc3986-validator[39m >0.1.0 
    │   │       │   │   ├── [33mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │       │   │   ├── [33muri-template[39m * 
    │   │       │   │   └── [33mwebcolors[39m >=24.6.0 
    │   │       │   ├── [36mpackaging[39m * (circular dependency aborted here)
    │   │       │   ├── [36mpython-json-logger[39m >=2.0.4 
    │   │       │   ├── [36mpyyaml[39m >=5.3 
    │   │       │   ├── [36mreferencing[39m * (circular dependency aborted here)
    │   │       │   ├── [36mrfc3339-validator[39m * (circular dependency aborted here)
    │   │       │   ├── [36mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │   │       │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │       ├── [34mjupyter-server-terminals[39m >=0.4.4 
    │   │       │   ├── [36mpywinpty[39m >=2.0.3 
    │   │       │   └── [36mterminado[39m >=0.8.3 
    │   │       │       ├── [33mptyprocess[39m * (circular dependency aborted here)
    │   │       │       ├── [33mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │   │       │       └── [33mtornado[39m >=6.1.0 (circular dependency aborted here)
    │   │       ├── [34mnbconvert[39m >=6.4.4 
    │   │       │   ├── [36mbeautifulsoup4[39m * 
    │   │       │   │   ├── [33msoupsieve[39m >1.2 
    │   │       │   │   └── [33mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │   │       │   ├── [36mbleach[39m !=5.0.0 
    │   │       │   │   ├── [33mtinycss2[39m >=1.1.0,<1.5 
    │   │       │   │   │   └── [32mwebencodings[39m >=0.4 
    │   │       │   │   └── [33mwebencodings[39m * (circular dependency aborted here)
    │   │       │   ├── [36mdefusedxml[39m * 
    │   │       │   ├── [36mjinja2[39m >=3.0 (circular dependency aborted here)
    │   │       │   ├── [36mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │   │       │   ├── [36mjupyterlab-pygments[39m * 
    │   │       │   ├── [36mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   │       │   ├── [36mmistune[39m >=2.0.3,<4 
    │   │       │   ├── [36mnbclient[39m >=0.5.0 
    │   │       │   │   ├── [33mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │   │       │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │       │   │   ├── [33mnbformat[39m >=5.1 
    │   │       │   │   │   ├── [32mfastjsonschema[39m >=2.15 
    │   │       │   │   │   ├── [32mjsonschema[39m >=2.6 (circular dependency aborted here)
    │   │       │   │   │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │       │   │   │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │       │   │   └── [33mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   │       │   ├── [36mnbformat[39m >=5.7 (circular dependency aborted here)
    │   │       │   ├── [36mpackaging[39m * (circular dependency aborted here)
    │   │       │   ├── [36mpandocfilters[39m >=1.4.1 
    │   │       │   ├── [36mpygments[39m >=2.4.1 (circular dependency aborted here)
    │   │       │   └── [36mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │       ├── [34mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │   │       ├── [34moverrides[39m >=5.0 
    │   │       ├── [34mpackaging[39m >=22.0 (circular dependency aborted here)
    │   │       ├── [34mprometheus-client[39m >=0.9 
    │   │       ├── [34mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │   │       ├── [34mpyzmq[39m >=24 (circular dependency aborted here)
    │   │       ├── [34msend2trash[39m >=1.8.2 
    │   │       ├── [34mterminado[39m >=0.8.3 (circular dependency aborted here)
    │   │       ├── [34mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   │       ├── [34mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │   │       └── [34mwebsocket-client[39m >=1.7 
    │   ├── [32mjupyter-server[39m >=2.4.0,<3 (circular dependency aborted here)
    │   ├── [32mjupyterlab-server[39m >=2.27.1,<3 
    │   │   ├── [35mbabel[39m >=2.10 
    │   │   ├── [35mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │   │   ├── [35mjson5[39m >=0.9.0 
    │   │   ├── [35mjsonschema[39m >=4.18.0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-server[39m >=1.21,<3 (circular dependency aborted here)
    │   │   ├── [35mpackaging[39m >=21.3 (circular dependency aborted here)
    │   │   └── [35mrequests[39m >=2.31 
    │   │       ├── [34mcertifi[39m >=2017.4.17 (circular dependency aborted here)
    │   │       ├── [34mcharset-normalizer[39m >=2,<4 
    │   │       ├── [34midna[39m >=2.5,<4 (circular dependency aborted here)
    │   │       └── [34murllib3[39m >=1.21.1,<3 
    │   ├── [32mnotebook-shim[39m >=0.2 
    │   │   └── [35mjupyter-server[39m >=1.8,<3 (circular dependency aborted here)
    │   ├── [32mpackaging[39m * (circular dependency aborted here)
    │   ├── [32msetuptools[39m >=40.8.0 
    │   ├── [32mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   └── [32mtraitlets[39m * (circular dependency aborted here)
    ├── [33mnbconvert[39m *
    │   ├── [32mbeautifulsoup4[39m * 
    │   │   ├── [35msoupsieve[39m >1.2 
    │   │   └── [35mtyping-extensions[39m >=4.0.0 
    │   ├── [32mbleach[39m !=5.0.0 
    │   │   ├── [35mtinycss2[39m >=1.1.0,<1.5 
    │   │   │   └── [34mwebencodings[39m >=0.4 
    │   │   └── [35mwebencodings[39m * (circular dependency aborted here)
    │   ├── [32mdefusedxml[39m * 
    │   ├── [32mjinja2[39m >=3.0 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjupyter-core[39m >=4.7 
    │   │   ├── [35mplatformdirs[39m >=2.5 
    │   │   ├── [35mpywin32[39m >=300 
    │   │   └── [35mtraitlets[39m >=5.3 
    │   ├── [32mjupyterlab-pygments[39m * 
    │   ├── [32mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   ├── [32mmistune[39m >=2.0.3,<4 
    │   ├── [32mnbclient[39m >=0.5.0 
    │   │   ├── [35mjupyter-client[39m >=6.1.12 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   ├── [34mpython-dateutil[39m >=2.8.2 
    │   │   │   │   └── [36msix[39m >=1.5 
    │   │   │   ├── [34mpyzmq[39m >=23.0 
    │   │   │   │   └── [36mcffi[39m * 
    │   │   │   │       └── [33mpycparser[39m * 
    │   │   │   ├── [34mtornado[39m >=6.2 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   ├── [35mnbformat[39m >=5.1 
    │   │   │   ├── [34mfastjsonschema[39m >=2.15 
    │   │   │   ├── [34mjsonschema[39m >=2.6 
    │   │   │   │   ├── [36mattrs[39m >=22.2.0 
    │   │   │   │   ├── [36mfqdn[39m * 
    │   │   │   │   ├── [36midna[39m * 
    │   │   │   │   ├── [36misoduration[39m * 
    │   │   │   │   │   └── [33marrow[39m >=0.15.0 
    │   │   │   │   │       ├── [32mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │   │   │   │   │       └── [32mtypes-python-dateutil[39m >=2.8.10 
    │   │   │   │   ├── [36mjsonpointer[39m >1.13 
    │   │   │   │   ├── [36mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   │   │   └── [33mreferencing[39m >=0.31.0 
    │   │   │   │   │       ├── [32mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │   │   │       ├── [32mrpds-py[39m >=0.7.0 
    │   │   │   │   │       └── [32mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │   │   │   │   ├── [36mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   │   │   ├── [36mrfc3339-validator[39m * 
    │   │   │   │   │   └── [33msix[39m * (circular dependency aborted here)
    │   │   │   │   ├── [36mrfc3986-validator[39m >0.1.0 
    │   │   │   │   ├── [36mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   │   │   ├── [36muri-template[39m * 
    │   │   │   │   └── [36mwebcolors[39m >=24.6.0 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   └── [35mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   ├── [32mnbformat[39m >=5.7 (circular dependency aborted here)
    │   ├── [32mpackaging[39m * 
    │   ├── [32mpandocfilters[39m >=1.4.1 
    │   ├── [32mpygments[39m >=2.4.1 
    │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
    └── [33mnotebook[39m *
        ├── [32mjupyter-server[39m >=2.4.0,<3 
        │   ├── [35manyio[39m >=3.1.0 
        │   │   ├── [34midna[39m >=2.8 
        │   │   ├── [34msniffio[39m >=1.1 
        │   │   └── [34mtyping-extensions[39m >=4.5 
        │   ├── [35margon2-cffi[39m >=21.1 
        │   │   └── [34margon2-cffi-bindings[39m * 
        │   │       └── [36mcffi[39m >=1.0.1 
        │   │           └── [33mpycparser[39m * 
        │   ├── [35mjinja2[39m >=3.0.3 
        │   │   └── [34mmarkupsafe[39m >=2.0 
        │   ├── [35mjupyter-client[39m >=7.4.4 
        │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
        │   │   │   ├── [36mplatformdirs[39m >=2.5 
        │   │   │   ├── [36mpywin32[39m >=300 
        │   │   │   └── [36mtraitlets[39m >=5.3 
        │   │   ├── [34mpython-dateutil[39m >=2.8.2 
        │   │   │   └── [36msix[39m >=1.5 
        │   │   ├── [34mpyzmq[39m >=23.0 
        │   │   │   └── [36mcffi[39m * (circular dependency aborted here)
        │   │   ├── [34mtornado[39m >=6.2 
        │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
        │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │   ├── [35mjupyter-events[39m >=0.11.0 
        │   │   ├── [34mjsonschema[39m >=4.18.0 
        │   │   │   ├── [36mattrs[39m >=22.2.0 
        │   │   │   ├── [36mfqdn[39m * 
        │   │   │   ├── [36midna[39m * (circular dependency aborted here)
        │   │   │   ├── [36misoduration[39m * 
        │   │   │   │   └── [33marrow[39m >=0.15.0 
        │   │   │   │       ├── [32mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
        │   │   │   │       └── [32mtypes-python-dateutil[39m >=2.8.10 
        │   │   │   ├── [36mjsonpointer[39m >1.13 
        │   │   │   ├── [36mjsonschema-specifications[39m >=2023.03.6 
        │   │   │   │   └── [33mreferencing[39m >=0.31.0 
        │   │   │   │       ├── [32mattrs[39m >=22.2.0 (circular dependency aborted here)
        │   │   │   │       ├── [32mrpds-py[39m >=0.7.0 
        │   │   │   │       └── [32mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
        │   │   │   ├── [36mreferencing[39m >=0.28.4 (circular dependency aborted here)
        │   │   │   ├── [36mrfc3339-validator[39m * 
        │   │   │   │   └── [33msix[39m * (circular dependency aborted here)
        │   │   │   ├── [36mrfc3986-validator[39m >0.1.0 
        │   │   │   ├── [36mrpds-py[39m >=0.7.1 (circular dependency aborted here)
        │   │   │   ├── [36muri-template[39m * 
        │   │   │   └── [36mwebcolors[39m >=24.6.0 
        │   │   ├── [34mpackaging[39m * 
        │   │   ├── [34mpython-json-logger[39m >=2.0.4 
        │   │   ├── [34mpyyaml[39m >=5.3 
        │   │   ├── [34mreferencing[39m * (circular dependency aborted here)
        │   │   ├── [34mrfc3339-validator[39m * (circular dependency aborted here)
        │   │   ├── [34mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
        │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
        │   ├── [35mjupyter-server-terminals[39m >=0.4.4 
        │   │   ├── [34mpywinpty[39m >=2.0.3 
        │   │   └── [34mterminado[39m >=0.8.3 
        │   │       ├── [36mptyprocess[39m * 
        │   │       ├── [36mpywinpty[39m >=1.1.0 (circular dependency aborted here)
        │   │       └── [36mtornado[39m >=6.1.0 (circular dependency aborted here)
        │   ├── [35mnbconvert[39m >=6.4.4 
        │   │   ├── [34mbeautifulsoup4[39m * 
        │   │   │   ├── [36msoupsieve[39m >1.2 
        │   │   │   └── [36mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
        │   │   ├── [34mbleach[39m !=5.0.0 
        │   │   │   ├── [36mtinycss2[39m >=1.1.0,<1.5 
        │   │   │   │   └── [33mwebencodings[39m >=0.4 
        │   │   │   └── [36mwebencodings[39m * (circular dependency aborted here)
        │   │   ├── [34mdefusedxml[39m * 
        │   │   ├── [34mjinja2[39m >=3.0 (circular dependency aborted here)
        │   │   ├── [34mjupyter-core[39m >=4.7 (circular dependency aborted here)
        │   │   ├── [34mjupyterlab-pygments[39m * 
        │   │   ├── [34mmarkupsafe[39m >=2.0 (circular dependency aborted here)
        │   │   ├── [34mmistune[39m >=2.0.3,<4 
        │   │   ├── [34mnbclient[39m >=0.5.0 
        │   │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
        │   │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │   │   │   ├── [36mnbformat[39m >=5.1 
        │   │   │   │   ├── [33mfastjsonschema[39m >=2.15 
        │   │   │   │   ├── [33mjsonschema[39m >=2.6 (circular dependency aborted here)
        │   │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │   │   │   │   └── [33mtraitlets[39m >=5.1 (circular dependency aborted here)
        │   │   │   └── [36mtraitlets[39m >=5.4 (circular dependency aborted here)
        │   │   ├── [34mnbformat[39m >=5.7 (circular dependency aborted here)
        │   │   ├── [34mpackaging[39m * (circular dependency aborted here)
        │   │   ├── [34mpandocfilters[39m >=1.4.1 
        │   │   ├── [34mpygments[39m >=2.4.1 
        │   │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
        │   ├── [35mnbformat[39m >=5.3.0 (circular dependency aborted here)
        │   ├── [35moverrides[39m >=5.0 
        │   ├── [35mpackaging[39m >=22.0 (circular dependency aborted here)
        │   ├── [35mprometheus-client[39m >=0.9 
        │   ├── [35mpywinpty[39m >=2.0.1 (circular dependency aborted here)
        │   ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
        │   ├── [35msend2trash[39m >=1.8.2 
        │   ├── [35mterminado[39m >=0.8.3 (circular dependency aborted here)
        │   ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
        │   ├── [35mtraitlets[39m >=5.6.0 (circular dependency aborted here)
        │   └── [35mwebsocket-client[39m >=1.7 
        ├── [32mjupyterlab[39m >=4.3.6,<4.4 
        │   ├── [35masync-lru[39m >=1.0.0 
        │   ├── [35mhttpx[39m >=0.25.0 
        │   │   ├── [34manyio[39m * (circular dependency aborted here)
        │   │   ├── [34mcertifi[39m * 
        │   │   ├── [34mhttpcore[39m ==1.* 
        │   │   │   ├── [36mcertifi[39m * (circular dependency aborted here)
        │   │   │   └── [36mh11[39m >=0.13,<0.15 
        │   │   └── [34midna[39m * (circular dependency aborted here)
        │   ├── [35mipykernel[39m >=6.5.0 
        │   │   ├── [34mappnope[39m * 
        │   │   ├── [34mcomm[39m >=0.1.1 
        │   │   │   └── [36mtraitlets[39m >=4 (circular dependency aborted here)
        │   │   ├── [34mdebugpy[39m >=1.6.5 
        │   │   ├── [34mipython[39m >=7.23.1 
        │   │   │   ├── [36mcolorama[39m * 
        │   │   │   ├── [36mdecorator[39m * 
        │   │   │   ├── [36mipython-pygments-lexers[39m * 
        │   │   │   │   └── [33mpygments[39m * (circular dependency aborted here)
        │   │   │   ├── [36mjedi[39m >=0.16 
        │   │   │   │   └── [33mparso[39m >=0.8.4,<0.9.0 
        │   │   │   ├── [36mmatplotlib-inline[39m * 
        │   │   │   │   └── [33mtraitlets[39m * (circular dependency aborted here)
        │   │   │   ├── [36mpexpect[39m >4.3 
        │   │   │   │   └── [33mptyprocess[39m >=0.5 (circular dependency aborted here)
        │   │   │   ├── [36mprompt-toolkit[39m >=3.0.41,<3.1.0 
        │   │   │   │   └── [33mwcwidth[39m * 
        │   │   │   ├── [36mpygments[39m >=2.4.0 (circular dependency aborted here)
        │   │   │   ├── [36mstack-data[39m * 
        │   │   │   │   ├── [33masttokens[39m >=2.1.0 
        │   │   │   │   ├── [33mexecuting[39m >=1.2.0 
        │   │   │   │   └── [33mpure-eval[39m * 
        │   │   │   └── [36mtraitlets[39m >=5.13.0 (circular dependency aborted here)
        │   │   ├── [34mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
        │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │   │   ├── [34mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
        │   │   ├── [34mnest-asyncio[39m * 
        │   │   ├── [34mpackaging[39m * (circular dependency aborted here)
        │   │   ├── [34mpsutil[39m * 
        │   │   ├── [34mpyzmq[39m >=24 (circular dependency aborted here)
        │   │   ├── [34mtornado[39m >=6.1 (circular dependency aborted here)
        │   │   └── [34mtraitlets[39m >=5.4.0 (circular dependency aborted here)
        │   ├── [35mjinja2[39m >=3.0.3 (circular dependency aborted here)
        │   ├── [35mjupyter-core[39m * (circular dependency aborted here)
        │   ├── [35mjupyter-lsp[39m >=2.0.0 
        │   │   └── [34mjupyter-server[39m >=1.1.2 (circular dependency aborted here)
        │   ├── [35mjupyter-server[39m >=2.4.0,<3 (circular dependency aborted here)
        │   ├── [35mjupyterlab-server[39m >=2.27.1,<3 
        │   │   ├── [34mbabel[39m >=2.10 
        │   │   ├── [34mjinja2[39m >=3.0.3 (circular dependency aborted here)
        │   │   ├── [34mjson5[39m >=0.9.0 
        │   │   ├── [34mjsonschema[39m >=4.18.0 (circular dependency aborted here)
        │   │   ├── [34mjupyter-server[39m >=1.21,<3 (circular dependency aborted here)
        │   │   ├── [34mpackaging[39m >=21.3 (circular dependency aborted here)
        │   │   └── [34mrequests[39m >=2.31 
        │   │       ├── [36mcertifi[39m >=2017.4.17 (circular dependency aborted here)
        │   │       ├── [36mcharset-normalizer[39m >=2,<4 
        │   │       ├── [36midna[39m >=2.5,<4 (circular dependency aborted here)
        │   │       └── [36murllib3[39m >=1.21.1,<3 
        │   ├── [35mnotebook-shim[39m >=0.2 
        │   │   └── [34mjupyter-server[39m >=1.8,<3 (circular dependency aborted here)
        │   ├── [35mpackaging[39m * (circular dependency aborted here)
        │   ├── [35msetuptools[39m >=40.8.0 
        │   ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
        │   └── [35mtraitlets[39m * (circular dependency aborted here)
        ├── [32mjupyterlab-server[39m >=2.27.1,<3 (circular dependency aborted here)
        ├── [32mnotebook-shim[39m >=0.2,<0.3 (circular dependency aborted here)
        └── [32mtornado[39m >=6.2.0 (circular dependency aborted here)
    [36mjupyter-console[39m [39;1m6.6.3[39;22m Jupyter terminal console
    ├── [33mipykernel[39m >=6.14
    │   ├── [32mappnope[39m * 
    │   ├── [32mcomm[39m >=0.1.1 
    │   │   └── [35mtraitlets[39m >=4 
    │   ├── [32mdebugpy[39m >=1.6.5 
    │   ├── [32mipython[39m >=7.23.1 
    │   │   ├── [35mcolorama[39m * 
    │   │   ├── [35mdecorator[39m * 
    │   │   ├── [35mipython-pygments-lexers[39m * 
    │   │   │   └── [34mpygments[39m * 
    │   │   ├── [35mjedi[39m >=0.16 
    │   │   │   └── [34mparso[39m >=0.8.4,<0.9.0 
    │   │   ├── [35mmatplotlib-inline[39m * 
    │   │   │   └── [34mtraitlets[39m * (circular dependency aborted here)
    │   │   ├── [35mpexpect[39m >4.3 
    │   │   │   └── [34mptyprocess[39m >=0.5 
    │   │   ├── [35mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   └── [34mwcwidth[39m * 
    │   │   ├── [35mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   ├── [35mstack-data[39m * 
    │   │   │   ├── [34masttokens[39m >=2.1.0 
    │   │   │   ├── [34mexecuting[39m >=1.2.0 
    │   │   │   └── [34mpure-eval[39m * 
    │   │   └── [35mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   ├── [32mjupyter-client[39m >=6.1.12 
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   ├── [34mplatformdirs[39m >=2.5 
    │   │   │   ├── [34mpywin32[39m >=300 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mpython-dateutil[39m >=2.8.2 
    │   │   │   └── [34msix[39m >=1.5 
    │   │   ├── [35mpyzmq[39m >=23.0 
    │   │   │   └── [34mcffi[39m * 
    │   │   │       └── [36mpycparser[39m * 
    │   │   ├── [35mtornado[39m >=6.2 
    │   │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   ├── [32mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
    │   ├── [32mnest-asyncio[39m * 
    │   ├── [32mpackaging[39m * 
    │   ├── [32mpsutil[39m * 
    │   ├── [32mpyzmq[39m >=24 (circular dependency aborted here)
    │   ├── [32mtornado[39m >=6.1 (circular dependency aborted here)
    │   └── [32mtraitlets[39m >=5.4.0 (circular dependency aborted here)
    ├── [33mipython[39m *
    │   ├── [32mcolorama[39m * 
    │   ├── [32mdecorator[39m * 
    │   ├── [32mipython-pygments-lexers[39m * 
    │   │   └── [35mpygments[39m * 
    │   ├── [32mjedi[39m >=0.16 
    │   │   └── [35mparso[39m >=0.8.4,<0.9.0 
    │   ├── [32mmatplotlib-inline[39m * 
    │   │   └── [35mtraitlets[39m * 
    │   ├── [32mpexpect[39m >4.3 
    │   │   └── [35mptyprocess[39m >=0.5 
    │   ├── [32mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   └── [35mwcwidth[39m * 
    │   ├── [32mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   ├── [32mstack-data[39m * 
    │   │   ├── [35masttokens[39m >=2.1.0 
    │   │   ├── [35mexecuting[39m >=1.2.0 
    │   │   └── [35mpure-eval[39m * 
    │   └── [32mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    ├── [33mjupyter-client[39m >=7.0.0
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   ├── [35mplatformdirs[39m >=2.5 
    │   │   ├── [35mpywin32[39m >=300 
    │   │   └── [35mtraitlets[39m >=5.3 
    │   ├── [32mpython-dateutil[39m >=2.8.2 
    │   │   └── [35msix[39m >=1.5 
    │   ├── [32mpyzmq[39m >=23.0 
    │   │   └── [35mcffi[39m * 
    │   │       └── [34mpycparser[39m * 
    │   ├── [32mtornado[39m >=6.2 
    │   └── [32mtraitlets[39m >=5.3 (circular dependency aborted here)
    ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0
    │   ├── [32mplatformdirs[39m >=2.5 
    │   ├── [32mpywin32[39m >=300 
    │   └── [32mtraitlets[39m >=5.3 
    ├── [33mprompt-toolkit[39m >=3.0.30
    │   └── [32mwcwidth[39m * 
    ├── [33mpygments[39m *
    ├── [33mpyzmq[39m >=17
    │   └── [32mcffi[39m * 
    │       └── [35mpycparser[39m * 
    └── [33mtraitlets[39m >=5.4
    [36mjupyter-core[39m [39;1m5.7.2[39;22m Jupyter core package. A base package on which Jupyter projects rely.
    ├── [33mplatformdirs[39m >=2.5
    ├── [33mpywin32[39m >=300
    └── [33mtraitlets[39m >=5.3
    [36mjupyter-lsp[39m [39;1m2.2.5[39;22m Multi-Language Server WebSocket proxy for Jupyter Notebook/Lab server
    └── [33mjupyter-server[39m >=1.1.2
        ├── [32manyio[39m >=3.1.0 
        │   ├── [35midna[39m >=2.8 
        │   ├── [35msniffio[39m >=1.1 
        │   └── [35mtyping-extensions[39m >=4.5 
        ├── [32margon2-cffi[39m >=21.1 
        │   └── [35margon2-cffi-bindings[39m * 
        │       └── [34mcffi[39m >=1.0.1 
        │           └── [36mpycparser[39m * 
        ├── [32mjinja2[39m >=3.0.3 
        │   └── [35mmarkupsafe[39m >=2.0 
        ├── [32mjupyter-client[39m >=7.4.4 
        │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
        │   │   ├── [34mplatformdirs[39m >=2.5 
        │   │   ├── [34mpywin32[39m >=300 
        │   │   └── [34mtraitlets[39m >=5.3 
        │   ├── [35mpython-dateutil[39m >=2.8.2 
        │   │   └── [34msix[39m >=1.5 
        │   ├── [35mpyzmq[39m >=23.0 
        │   │   └── [34mcffi[39m * (circular dependency aborted here)
        │   ├── [35mtornado[39m >=6.2 
        │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
        ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        ├── [32mjupyter-events[39m >=0.11.0 
        │   ├── [35mjsonschema[39m >=4.18.0 
        │   │   ├── [34mattrs[39m >=22.2.0 
        │   │   ├── [34mfqdn[39m * 
        │   │   ├── [34midna[39m * (circular dependency aborted here)
        │   │   ├── [34misoduration[39m * 
        │   │   │   └── [36marrow[39m >=0.15.0 
        │   │   │       ├── [33mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
        │   │   │       └── [33mtypes-python-dateutil[39m >=2.8.10 
        │   │   ├── [34mjsonpointer[39m >1.13 
        │   │   ├── [34mjsonschema-specifications[39m >=2023.03.6 
        │   │   │   └── [36mreferencing[39m >=0.31.0 
        │   │   │       ├── [33mattrs[39m >=22.2.0 (circular dependency aborted here)
        │   │   │       ├── [33mrpds-py[39m >=0.7.0 
        │   │   │       └── [33mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
        │   │   ├── [34mreferencing[39m >=0.28.4 (circular dependency aborted here)
        │   │   ├── [34mrfc3339-validator[39m * 
        │   │   │   └── [36msix[39m * (circular dependency aborted here)
        │   │   ├── [34mrfc3986-validator[39m >0.1.0 
        │   │   ├── [34mrpds-py[39m >=0.7.1 (circular dependency aborted here)
        │   │   ├── [34muri-template[39m * 
        │   │   └── [34mwebcolors[39m >=24.6.0 
        │   ├── [35mpackaging[39m * 
        │   ├── [35mpython-json-logger[39m >=2.0.4 
        │   ├── [35mpyyaml[39m >=5.3 
        │   ├── [35mreferencing[39m * (circular dependency aborted here)
        │   ├── [35mrfc3339-validator[39m * (circular dependency aborted here)
        │   ├── [35mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
        │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
        ├── [32mjupyter-server-terminals[39m >=0.4.4 
        │   ├── [35mpywinpty[39m >=2.0.3 
        │   └── [35mterminado[39m >=0.8.3 
        │       ├── [34mptyprocess[39m * 
        │       ├── [34mpywinpty[39m >=1.1.0 (circular dependency aborted here)
        │       └── [34mtornado[39m >=6.1.0 (circular dependency aborted here)
        ├── [32mnbconvert[39m >=6.4.4 
        │   ├── [35mbeautifulsoup4[39m * 
        │   │   ├── [34msoupsieve[39m >1.2 
        │   │   └── [34mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
        │   ├── [35mbleach[39m !=5.0.0 
        │   │   ├── [34mtinycss2[39m >=1.1.0,<1.5 
        │   │   │   └── [36mwebencodings[39m >=0.4 
        │   │   └── [34mwebencodings[39m * (circular dependency aborted here)
        │   ├── [35mdefusedxml[39m * 
        │   ├── [35mjinja2[39m >=3.0 (circular dependency aborted here)
        │   ├── [35mjupyter-core[39m >=4.7 (circular dependency aborted here)
        │   ├── [35mjupyterlab-pygments[39m * 
        │   ├── [35mmarkupsafe[39m >=2.0 (circular dependency aborted here)
        │   ├── [35mmistune[39m >=2.0.3,<4 
        │   ├── [35mnbclient[39m >=0.5.0 
        │   │   ├── [34mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
        │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │   │   ├── [34mnbformat[39m >=5.1 
        │   │   │   ├── [36mfastjsonschema[39m >=2.15 
        │   │   │   ├── [36mjsonschema[39m >=2.6 (circular dependency aborted here)
        │   │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │   │   │   └── [36mtraitlets[39m >=5.1 (circular dependency aborted here)
        │   │   └── [34mtraitlets[39m >=5.4 (circular dependency aborted here)
        │   ├── [35mnbformat[39m >=5.7 (circular dependency aborted here)
        │   ├── [35mpackaging[39m * (circular dependency aborted here)
        │   ├── [35mpandocfilters[39m >=1.4.1 
        │   ├── [35mpygments[39m >=2.4.1 
        │   └── [35mtraitlets[39m >=5.1 (circular dependency aborted here)
        ├── [32mnbformat[39m >=5.3.0 (circular dependency aborted here)
        ├── [32moverrides[39m >=5.0 
        ├── [32mpackaging[39m >=22.0 (circular dependency aborted here)
        ├── [32mprometheus-client[39m >=0.9 
        ├── [32mpywinpty[39m >=2.0.1 (circular dependency aborted here)
        ├── [32mpyzmq[39m >=24 (circular dependency aborted here)
        ├── [32msend2trash[39m >=1.8.2 
        ├── [32mterminado[39m >=0.8.3 (circular dependency aborted here)
        ├── [32mtornado[39m >=6.2.0 (circular dependency aborted here)
        ├── [32mtraitlets[39m >=5.6.0 (circular dependency aborted here)
        └── [32mwebsocket-client[39m >=1.7 
    [36mjupyterlab[39m [39;1m4.3.6[39;22m JupyterLab computational environment
    ├── [33masync-lru[39m >=1.0.0
    ├── [33mhttpx[39m >=0.25.0
    │   ├── [32manyio[39m * 
    │   │   ├── [35midna[39m >=2.8 
    │   │   ├── [35msniffio[39m >=1.1 
    │   │   └── [35mtyping-extensions[39m >=4.5 
    │   ├── [32mcertifi[39m * 
    │   ├── [32mhttpcore[39m ==1.* 
    │   │   ├── [35mcertifi[39m * (circular dependency aborted here)
    │   │   └── [35mh11[39m >=0.13,<0.15 
    │   └── [32midna[39m * (circular dependency aborted here)
    ├── [33mipykernel[39m >=6.5.0
    │   ├── [32mappnope[39m * 
    │   ├── [32mcomm[39m >=0.1.1 
    │   │   └── [35mtraitlets[39m >=4 
    │   ├── [32mdebugpy[39m >=1.6.5 
    │   ├── [32mipython[39m >=7.23.1 
    │   │   ├── [35mcolorama[39m * 
    │   │   ├── [35mdecorator[39m * 
    │   │   ├── [35mipython-pygments-lexers[39m * 
    │   │   │   └── [34mpygments[39m * 
    │   │   ├── [35mjedi[39m >=0.16 
    │   │   │   └── [34mparso[39m >=0.8.4,<0.9.0 
    │   │   ├── [35mmatplotlib-inline[39m * 
    │   │   │   └── [34mtraitlets[39m * (circular dependency aborted here)
    │   │   ├── [35mpexpect[39m >4.3 
    │   │   │   └── [34mptyprocess[39m >=0.5 
    │   │   ├── [35mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   └── [34mwcwidth[39m * 
    │   │   ├── [35mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   ├── [35mstack-data[39m * 
    │   │   │   ├── [34masttokens[39m >=2.1.0 
    │   │   │   ├── [34mexecuting[39m >=1.2.0 
    │   │   │   └── [34mpure-eval[39m * 
    │   │   └── [35mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   ├── [32mjupyter-client[39m >=6.1.12 
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   ├── [34mplatformdirs[39m >=2.5 
    │   │   │   ├── [34mpywin32[39m >=300 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mpython-dateutil[39m >=2.8.2 
    │   │   │   └── [34msix[39m >=1.5 
    │   │   ├── [35mpyzmq[39m >=23.0 
    │   │   │   └── [34mcffi[39m * 
    │   │   │       └── [36mpycparser[39m * 
    │   │   ├── [35mtornado[39m >=6.2 
    │   │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   ├── [32mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
    │   ├── [32mnest-asyncio[39m * 
    │   ├── [32mpackaging[39m * 
    │   ├── [32mpsutil[39m * 
    │   ├── [32mpyzmq[39m >=24 (circular dependency aborted here)
    │   ├── [32mtornado[39m >=6.1 (circular dependency aborted here)
    │   └── [32mtraitlets[39m >=5.4.0 (circular dependency aborted here)
    ├── [33mjinja2[39m >=3.0.3
    │   └── [32mmarkupsafe[39m >=2.0 
    ├── [33mjupyter-core[39m *
    │   ├── [32mplatformdirs[39m >=2.5 
    │   ├── [32mpywin32[39m >=300 
    │   └── [32mtraitlets[39m >=5.3 
    ├── [33mjupyter-lsp[39m >=2.0.0
    │   └── [32mjupyter-server[39m >=1.1.2 
    │       ├── [35manyio[39m >=3.1.0 
    │       │   ├── [34midna[39m >=2.8 
    │       │   ├── [34msniffio[39m >=1.1 
    │       │   └── [34mtyping-extensions[39m >=4.5 
    │       ├── [35margon2-cffi[39m >=21.1 
    │       │   └── [34margon2-cffi-bindings[39m * 
    │       │       └── [36mcffi[39m >=1.0.1 
    │       │           └── [33mpycparser[39m * 
    │       ├── [35mjinja2[39m >=3.0.3 
    │       │   └── [34mmarkupsafe[39m >=2.0 
    │       ├── [35mjupyter-client[39m >=7.4.4 
    │       │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │       │   │   ├── [36mplatformdirs[39m >=2.5 
    │       │   │   ├── [36mpywin32[39m >=300 
    │       │   │   └── [36mtraitlets[39m >=5.3 
    │       │   ├── [34mpython-dateutil[39m >=2.8.2 
    │       │   │   └── [36msix[39m >=1.5 
    │       │   ├── [34mpyzmq[39m >=23.0 
    │       │   │   └── [36mcffi[39m * (circular dependency aborted here)
    │       │   ├── [34mtornado[39m >=6.2 
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       ├── [35mjupyter-events[39m >=0.11.0 
    │       │   ├── [34mjsonschema[39m >=4.18.0 
    │       │   │   ├── [36mattrs[39m >=22.2.0 
    │       │   │   ├── [36mfqdn[39m * 
    │       │   │   ├── [36midna[39m * (circular dependency aborted here)
    │       │   │   ├── [36misoduration[39m * 
    │       │   │   │   └── [33marrow[39m >=0.15.0 
    │       │   │   │       ├── [32mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │       │   │   │       └── [32mtypes-python-dateutil[39m >=2.8.10 
    │       │   │   ├── [36mjsonpointer[39m >1.13 
    │       │   │   ├── [36mjsonschema-specifications[39m >=2023.03.6 
    │       │   │   │   └── [33mreferencing[39m >=0.31.0 
    │       │   │   │       ├── [32mattrs[39m >=22.2.0 (circular dependency aborted here)
    │       │   │   │       ├── [32mrpds-py[39m >=0.7.0 
    │       │   │   │       └── [32mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │       │   │   ├── [36mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │       │   │   ├── [36mrfc3339-validator[39m * 
    │       │   │   │   └── [33msix[39m * (circular dependency aborted here)
    │       │   │   ├── [36mrfc3986-validator[39m >0.1.0 
    │       │   │   ├── [36mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │       │   │   ├── [36muri-template[39m * 
    │       │   │   └── [36mwebcolors[39m >=24.6.0 
    │       │   ├── [34mpackaging[39m * 
    │       │   ├── [34mpython-json-logger[39m >=2.0.4 
    │       │   ├── [34mpyyaml[39m >=5.3 
    │       │   ├── [34mreferencing[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3339-validator[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-server-terminals[39m >=0.4.4 
    │       │   ├── [34mpywinpty[39m >=2.0.3 
    │       │   └── [34mterminado[39m >=0.8.3 
    │       │       ├── [36mptyprocess[39m * 
    │       │       ├── [36mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │       │       └── [36mtornado[39m >=6.1.0 (circular dependency aborted here)
    │       ├── [35mnbconvert[39m >=6.4.4 
    │       │   ├── [34mbeautifulsoup4[39m * 
    │       │   │   ├── [36msoupsieve[39m >1.2 
    │       │   │   └── [36mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │       │   ├── [34mbleach[39m !=5.0.0 
    │       │   │   ├── [36mtinycss2[39m >=1.1.0,<1.5 
    │       │   │   │   └── [33mwebencodings[39m >=0.4 
    │       │   │   └── [36mwebencodings[39m * (circular dependency aborted here)
    │       │   ├── [34mdefusedxml[39m * 
    │       │   ├── [34mjinja2[39m >=3.0 (circular dependency aborted here)
    │       │   ├── [34mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │       │   ├── [34mjupyterlab-pygments[39m * 
    │       │   ├── [34mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │       │   ├── [34mmistune[39m >=2.0.3,<4 
    │       │   ├── [34mnbclient[39m >=0.5.0 
    │       │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   ├── [36mnbformat[39m >=5.1 
    │       │   │   │   ├── [33mfastjsonschema[39m >=2.15 
    │       │   │   │   ├── [33mjsonschema[39m >=2.6 (circular dependency aborted here)
    │       │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   │   └── [33mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       │   │   └── [36mtraitlets[39m >=5.4 (circular dependency aborted here)
    │       │   ├── [34mnbformat[39m >=5.7 (circular dependency aborted here)
    │       │   ├── [34mpackaging[39m * (circular dependency aborted here)
    │       │   ├── [34mpandocfilters[39m >=1.4.1 
    │       │   ├── [34mpygments[39m >=2.4.1 
    │       │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       ├── [35mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │       ├── [35moverrides[39m >=5.0 
    │       ├── [35mpackaging[39m >=22.0 (circular dependency aborted here)
    │       ├── [35mprometheus-client[39m >=0.9 
    │       ├── [35mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │       ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │       ├── [35msend2trash[39m >=1.8.2 
    │       ├── [35mterminado[39m >=0.8.3 (circular dependency aborted here)
    │       ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
    │       ├── [35mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │       └── [35mwebsocket-client[39m >=1.7 
    ├── [33mjupyter-server[39m >=2.4.0,<3
    │   ├── [32manyio[39m >=3.1.0 
    │   │   ├── [35midna[39m >=2.8 
    │   │   ├── [35msniffio[39m >=1.1 
    │   │   └── [35mtyping-extensions[39m >=4.5 
    │   ├── [32margon2-cffi[39m >=21.1 
    │   │   └── [35margon2-cffi-bindings[39m * 
    │   │       └── [34mcffi[39m >=1.0.1 
    │   │           └── [36mpycparser[39m * 
    │   ├── [32mjinja2[39m >=3.0.3 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjupyter-client[39m >=7.4.4 
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   ├── [34mplatformdirs[39m >=2.5 
    │   │   │   ├── [34mpywin32[39m >=300 
    │   │   │   └── [34mtraitlets[39m >=5.3 
    │   │   ├── [35mpython-dateutil[39m >=2.8.2 
    │   │   │   └── [34msix[39m >=1.5 
    │   │   ├── [35mpyzmq[39m >=23.0 
    │   │   │   └── [34mcffi[39m * (circular dependency aborted here)
    │   │   ├── [35mtornado[39m >=6.2 
    │   │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   ├── [32mjupyter-events[39m >=0.11.0 
    │   │   ├── [35mjsonschema[39m >=4.18.0 
    │   │   │   ├── [34mattrs[39m >=22.2.0 
    │   │   │   ├── [34mfqdn[39m * 
    │   │   │   ├── [34midna[39m * (circular dependency aborted here)
    │   │   │   ├── [34misoduration[39m * 
    │   │   │   │   └── [36marrow[39m >=0.15.0 
    │   │   │   │       ├── [33mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │   │   │   │       └── [33mtypes-python-dateutil[39m >=2.8.10 
    │   │   │   ├── [34mjsonpointer[39m >1.13 
    │   │   │   ├── [34mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   │   └── [36mreferencing[39m >=0.31.0 
    │   │   │   │       ├── [33mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │   │       ├── [33mrpds-py[39m >=0.7.0 
    │   │   │   │       └── [33mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │   │   │   ├── [34mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   │   ├── [34mrfc3339-validator[39m * 
    │   │   │   │   └── [36msix[39m * (circular dependency aborted here)
    │   │   │   ├── [34mrfc3986-validator[39m >0.1.0 
    │   │   │   ├── [34mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   │   ├── [34muri-template[39m * 
    │   │   │   └── [34mwebcolors[39m >=24.6.0 
    │   │   ├── [35mpackaging[39m * 
    │   │   ├── [35mpython-json-logger[39m >=2.0.4 
    │   │   ├── [35mpyyaml[39m >=5.3 
    │   │   ├── [35mreferencing[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3339-validator[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │   │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   ├── [32mjupyter-server-terminals[39m >=0.4.4 
    │   │   ├── [35mpywinpty[39m >=2.0.3 
    │   │   └── [35mterminado[39m >=0.8.3 
    │   │       ├── [34mptyprocess[39m * 
    │   │       ├── [34mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │   │       └── [34mtornado[39m >=6.1.0 (circular dependency aborted here)
    │   ├── [32mnbconvert[39m >=6.4.4 
    │   │   ├── [35mbeautifulsoup4[39m * 
    │   │   │   ├── [34msoupsieve[39m >1.2 
    │   │   │   └── [34mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │   │   ├── [35mbleach[39m !=5.0.0 
    │   │   │   ├── [34mtinycss2[39m >=1.1.0,<1.5 
    │   │   │   │   └── [36mwebencodings[39m >=0.4 
    │   │   │   └── [34mwebencodings[39m * (circular dependency aborted here)
    │   │   ├── [35mdefusedxml[39m * 
    │   │   ├── [35mjinja2[39m >=3.0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │   │   ├── [35mjupyterlab-pygments[39m * 
    │   │   ├── [35mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   │   ├── [35mmistune[39m >=2.0.3,<4 
    │   │   ├── [35mnbclient[39m >=0.5.0 
    │   │   │   ├── [34mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   ├── [34mnbformat[39m >=5.1 
    │   │   │   │   ├── [36mfastjsonschema[39m >=2.15 
    │   │   │   │   ├── [36mjsonschema[39m >=2.6 (circular dependency aborted here)
    │   │   │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   │   └── [36mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   │   └── [34mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   │   ├── [35mnbformat[39m >=5.7 (circular dependency aborted here)
    │   │   ├── [35mpackaging[39m * (circular dependency aborted here)
    │   │   ├── [35mpandocfilters[39m >=1.4.1 
    │   │   ├── [35mpygments[39m >=2.4.1 
    │   │   └── [35mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   ├── [32mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │   ├── [32moverrides[39m >=5.0 
    │   ├── [32mpackaging[39m >=22.0 (circular dependency aborted here)
    │   ├── [32mprometheus-client[39m >=0.9 
    │   ├── [32mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │   ├── [32mpyzmq[39m >=24 (circular dependency aborted here)
    │   ├── [32msend2trash[39m >=1.8.2 
    │   ├── [32mterminado[39m >=0.8.3 (circular dependency aborted here)
    │   ├── [32mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   ├── [32mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │   └── [32mwebsocket-client[39m >=1.7 
    ├── [33mjupyterlab-server[39m >=2.27.1,<3
    │   ├── [32mbabel[39m >=2.10 
    │   ├── [32mjinja2[39m >=3.0.3 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjson5[39m >=0.9.0 
    │   ├── [32mjsonschema[39m >=4.18.0 
    │   │   ├── [35mattrs[39m >=22.2.0 
    │   │   ├── [35mfqdn[39m * 
    │   │   ├── [35midna[39m * 
    │   │   ├── [35misoduration[39m * 
    │   │   │   └── [34marrow[39m >=0.15.0 
    │   │   │       ├── [36mpython-dateutil[39m >=2.7.0 
    │   │   │       │   └── [33msix[39m >=1.5 
    │   │   │       └── [36mtypes-python-dateutil[39m >=2.8.10 
    │   │   ├── [35mjsonpointer[39m >1.13 
    │   │   ├── [35mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   └── [34mreferencing[39m >=0.31.0 
    │   │   │       ├── [36mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │       ├── [36mrpds-py[39m >=0.7.0 
    │   │   │       └── [36mtyping-extensions[39m >=4.4.0 
    │   │   ├── [35mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   ├── [35mrfc3339-validator[39m * 
    │   │   │   └── [34msix[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3986-validator[39m >0.1.0 
    │   │   ├── [35mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   ├── [35muri-template[39m * 
    │   │   └── [35mwebcolors[39m >=24.6.0 
    │   ├── [32mjupyter-server[39m >=1.21,<3 
    │   │   ├── [35manyio[39m >=3.1.0 
    │   │   │   ├── [34midna[39m >=2.8 (circular dependency aborted here)
    │   │   │   ├── [34msniffio[39m >=1.1 
    │   │   │   └── [34mtyping-extensions[39m >=4.5 (circular dependency aborted here)
    │   │   ├── [35margon2-cffi[39m >=21.1 
    │   │   │   └── [34margon2-cffi-bindings[39m * 
    │   │   │       └── [36mcffi[39m >=1.0.1 
    │   │   │           └── [33mpycparser[39m * 
    │   │   ├── [35mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-client[39m >=7.4.4 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   │   ├── [36mplatformdirs[39m >=2.5 
    │   │   │   │   ├── [36mpywin32[39m >=300 
    │   │   │   │   └── [36mtraitlets[39m >=5.3 
    │   │   │   ├── [34mpython-dateutil[39m >=2.8.2 (circular dependency aborted here)
    │   │   │   ├── [34mpyzmq[39m >=23.0 


    │   │   │   │   └── [36mcffi[39m * (circular dependency aborted here)
    │   │   │   ├── [34mtornado[39m >=6.2 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-events[39m >=0.11.0 
    │   │   │   ├── [34mjsonschema[39m >=4.18.0 (circular dependency aborted here)
    │   │   │   ├── [34mpackaging[39m * 
    │   │   │   ├── [34mpython-json-logger[39m >=2.0.4 
    │   │   │   ├── [34mpyyaml[39m >=5.3 
    │   │   │   ├── [34mreferencing[39m * (circular dependency aborted here)
    │   │   │   ├── [34mrfc3339-validator[39m * (circular dependency aborted here)
    │   │   │   ├── [34mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-server-terminals[39m >=0.4.4 
    │   │   │   ├── [34mpywinpty[39m >=2.0.3 
    │   │   │   └── [34mterminado[39m >=0.8.3 
    │   │   │       ├── [36mptyprocess[39m * 
    │   │   │       ├── [36mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │   │   │       └── [36mtornado[39m >=6.1.0 (circular dependency aborted here)
    │   │   ├── [35mnbconvert[39m >=6.4.4 
    │   │   │   ├── [34mbeautifulsoup4[39m * 
    │   │   │   │   ├── [36msoupsieve[39m >1.2 
    │   │   │   │   └── [36mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │   │   │   ├── [34mbleach[39m !=5.0.0 
    │   │   │   │   ├── [36mtinycss2[39m >=1.1.0,<1.5 
    │   │   │   │   │   └── [33mwebencodings[39m >=0.4 
    │   │   │   │   └── [36mwebencodings[39m * (circular dependency aborted here)
    │   │   │   ├── [34mdefusedxml[39m * 
    │   │   │   ├── [34mjinja2[39m >=3.0 (circular dependency aborted here)
    │   │   │   ├── [34mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │   │   │   ├── [34mjupyterlab-pygments[39m * 
    │   │   │   ├── [34mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   │   │   ├── [34mmistune[39m >=2.0.3,<4 
    │   │   │   ├── [34mnbclient[39m >=0.5.0 
    │   │   │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │   │   │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   │   ├── [36mnbformat[39m >=5.1 
    │   │   │   │   │   ├── [33mfastjsonschema[39m >=2.15 
    │   │   │   │   │   ├── [33mjsonschema[39m >=2.6 (circular dependency aborted here)
    │   │   │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   │   │   └── [33mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   │   │   └── [36mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   │   │   ├── [34mnbformat[39m >=5.7 (circular dependency aborted here)
    │   │   │   ├── [34mpackaging[39m * (circular dependency aborted here)
    │   │   │   ├── [34mpandocfilters[39m >=1.4.1 
    │   │   │   ├── [34mpygments[39m >=2.4.1 
    │   │   │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   ├── [35mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │   │   ├── [35moverrides[39m >=5.0 
    │   │   ├── [35mpackaging[39m >=22.0 (circular dependency aborted here)
    │   │   ├── [35mprometheus-client[39m >=0.9 
    │   │   ├── [35mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │   │   ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │   │   ├── [35msend2trash[39m >=1.8.2 
    │   │   ├── [35mterminado[39m >=0.8.3 (circular dependency aborted here)
    │   │   ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   │   ├── [35mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │   │   └── [35mwebsocket-client[39m >=1.7 
    │   ├── [32mpackaging[39m >=21.3 (circular dependency aborted here)
    │   └── [32mrequests[39m >=2.31 
    │       ├── [35mcertifi[39m >=2017.4.17 
    │       ├── [35mcharset-normalizer[39m >=2,<4 
    │       ├── [35midna[39m >=2.5,<4 (circular dependency aborted here)
    │       └── [35murllib3[39m >=1.21.1,<3 
    ├── [33mnotebook-shim[39m >=0.2
    │   └── [32mjupyter-server[39m >=1.8,<3 
    │       ├── [35manyio[39m >=3.1.0 
    │       │   ├── [34midna[39m >=2.8 
    │       │   ├── [34msniffio[39m >=1.1 
    │       │   └── [34mtyping-extensions[39m >=4.5 
    │       ├── [35margon2-cffi[39m >=21.1 
    │       │   └── [34margon2-cffi-bindings[39m * 
    │       │       └── [36mcffi[39m >=1.0.1 
    │       │           └── [33mpycparser[39m * 
    │       ├── [35mjinja2[39m >=3.0.3 
    │       │   └── [34mmarkupsafe[39m >=2.0 
    │       ├── [35mjupyter-client[39m >=7.4.4 
    │       │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │       │   │   ├── [36mplatformdirs[39m >=2.5 
    │       │   │   ├── [36mpywin32[39m >=300 
    │       │   │   └── [36mtraitlets[39m >=5.3 
    │       │   ├── [34mpython-dateutil[39m >=2.8.2 
    │       │   │   └── [36msix[39m >=1.5 
    │       │   ├── [34mpyzmq[39m >=23.0 
    │       │   │   └── [36mcffi[39m * (circular dependency aborted here)
    │       │   ├── [34mtornado[39m >=6.2 
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       ├── [35mjupyter-events[39m >=0.11.0 
    │       │   ├── [34mjsonschema[39m >=4.18.0 
    │       │   │   ├── [36mattrs[39m >=22.2.0 
    │       │   │   ├── [36mfqdn[39m * 
    │       │   │   ├── [36midna[39m * (circular dependency aborted here)
    │       │   │   ├── [36misoduration[39m * 
    │       │   │   │   └── [33marrow[39m >=0.15.0 
    │       │   │   │       ├── [32mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │       │   │   │       └── [32mtypes-python-dateutil[39m >=2.8.10 
    │       │   │   ├── [36mjsonpointer[39m >1.13 
    │       │   │   ├── [36mjsonschema-specifications[39m >=2023.03.6 
    │       │   │   │   └── [33mreferencing[39m >=0.31.0 
    │       │   │   │       ├── [32mattrs[39m >=22.2.0 (circular dependency aborted here)
    │       │   │   │       ├── [32mrpds-py[39m >=0.7.0 
    │       │   │   │       └── [32mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │       │   │   ├── [36mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │       │   │   ├── [36mrfc3339-validator[39m * 
    │       │   │   │   └── [33msix[39m * (circular dependency aborted here)
    │       │   │   ├── [36mrfc3986-validator[39m >0.1.0 
    │       │   │   ├── [36mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │       │   │   ├── [36muri-template[39m * 
    │       │   │   └── [36mwebcolors[39m >=24.6.0 
    │       │   ├── [34mpackaging[39m * 
    │       │   ├── [34mpython-json-logger[39m >=2.0.4 
    │       │   ├── [34mpyyaml[39m >=5.3 
    │       │   ├── [34mreferencing[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3339-validator[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-server-terminals[39m >=0.4.4 
    │       │   ├── [34mpywinpty[39m >=2.0.3 
    │       │   └── [34mterminado[39m >=0.8.3 
    │       │       ├── [36mptyprocess[39m * 
    │       │       ├── [36mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │       │       └── [36mtornado[39m >=6.1.0 (circular dependency aborted here)
    │       ├── [35mnbconvert[39m >=6.4.4 
    │       │   ├── [34mbeautifulsoup4[39m * 
    │       │   │   ├── [36msoupsieve[39m >1.2 
    │       │   │   └── [36mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │       │   ├── [34mbleach[39m !=5.0.0 
    │       │   │   ├── [36mtinycss2[39m >=1.1.0,<1.5 
    │       │   │   │   └── [33mwebencodings[39m >=0.4 
    │       │   │   └── [36mwebencodings[39m * (circular dependency aborted here)
    │       │   ├── [34mdefusedxml[39m * 
    │       │   ├── [34mjinja2[39m >=3.0 (circular dependency aborted here)
    │       │   ├── [34mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │       │   ├── [34mjupyterlab-pygments[39m * 
    │       │   ├── [34mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │       │   ├── [34mmistune[39m >=2.0.3,<4 
    │       │   ├── [34mnbclient[39m >=0.5.0 
    │       │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   ├── [36mnbformat[39m >=5.1 
    │       │   │   │   ├── [33mfastjsonschema[39m >=2.15 
    │       │   │   │   ├── [33mjsonschema[39m >=2.6 (circular dependency aborted here)
    │       │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   │   └── [33mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       │   │   └── [36mtraitlets[39m >=5.4 (circular dependency aborted here)
    │       │   ├── [34mnbformat[39m >=5.7 (circular dependency aborted here)
    │       │   ├── [34mpackaging[39m * (circular dependency aborted here)
    │       │   ├── [34mpandocfilters[39m >=1.4.1 
    │       │   ├── [34mpygments[39m >=2.4.1 
    │       │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       ├── [35mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │       ├── [35moverrides[39m >=5.0 
    │       ├── [35mpackaging[39m >=22.0 (circular dependency aborted here)
    │       ├── [35mprometheus-client[39m >=0.9 
    │       ├── [35mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │       ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │       ├── [35msend2trash[39m >=1.8.2 
    │       ├── [35mterminado[39m >=0.8.3 (circular dependency aborted here)
    │       ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
    │       ├── [35mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │       └── [35mwebsocket-client[39m >=1.7 
    ├── [33mpackaging[39m *
    ├── [33msetuptools[39m >=40.8.0
    ├── [33mtornado[39m >=6.2.0
    └── [33mtraitlets[39m *
    [36mjupyterlab-lsp[39m [39;1m5.1.0[39;22m Coding assistance for JupyterLab with Language Server Protocol
    ├── [33mjupyter-lsp[39m >=2.0.0
    │   └── [32mjupyter-server[39m >=1.1.2 
    │       ├── [35manyio[39m >=3.1.0 
    │       │   ├── [34midna[39m >=2.8 
    │       │   ├── [34msniffio[39m >=1.1 
    │       │   └── [34mtyping-extensions[39m >=4.5 
    │       ├── [35margon2-cffi[39m >=21.1 
    │       │   └── [34margon2-cffi-bindings[39m * 
    │       │       └── [36mcffi[39m >=1.0.1 
    │       │           └── [33mpycparser[39m * 
    │       ├── [35mjinja2[39m >=3.0.3 
    │       │   └── [34mmarkupsafe[39m >=2.0 
    │       ├── [35mjupyter-client[39m >=7.4.4 
    │       │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │       │   │   ├── [36mplatformdirs[39m >=2.5 
    │       │   │   ├── [36mpywin32[39m >=300 
    │       │   │   └── [36mtraitlets[39m >=5.3 
    │       │   ├── [34mpython-dateutil[39m >=2.8.2 
    │       │   │   └── [36msix[39m >=1.5 
    │       │   ├── [34mpyzmq[39m >=23.0 
    │       │   │   └── [36mcffi[39m * (circular dependency aborted here)
    │       │   ├── [34mtornado[39m >=6.2 
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       ├── [35mjupyter-events[39m >=0.11.0 
    │       │   ├── [34mjsonschema[39m >=4.18.0 
    │       │   │   ├── [36mattrs[39m >=22.2.0 
    │       │   │   ├── [36mfqdn[39m * 
    │       │   │   ├── [36midna[39m * (circular dependency aborted here)
    │       │   │   ├── [36misoduration[39m * 
    │       │   │   │   └── [33marrow[39m >=0.15.0 
    │       │   │   │       ├── [32mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │       │   │   │       └── [32mtypes-python-dateutil[39m >=2.8.10 
    │       │   │   ├── [36mjsonpointer[39m >1.13 
    │       │   │   ├── [36mjsonschema-specifications[39m >=2023.03.6 
    │       │   │   │   └── [33mreferencing[39m >=0.31.0 
    │       │   │   │       ├── [32mattrs[39m >=22.2.0 (circular dependency aborted here)
    │       │   │   │       ├── [32mrpds-py[39m >=0.7.0 
    │       │   │   │       └── [32mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │       │   │   ├── [36mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │       │   │   ├── [36mrfc3339-validator[39m * 
    │       │   │   │   └── [33msix[39m * (circular dependency aborted here)
    │       │   │   ├── [36mrfc3986-validator[39m >0.1.0 
    │       │   │   ├── [36mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │       │   │   ├── [36muri-template[39m * 
    │       │   │   └── [36mwebcolors[39m >=24.6.0 
    │       │   ├── [34mpackaging[39m * 
    │       │   ├── [34mpython-json-logger[39m >=2.0.4 
    │       │   ├── [34mpyyaml[39m >=5.3 
    │       │   ├── [34mreferencing[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3339-validator[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-server-terminals[39m >=0.4.4 
    │       │   ├── [34mpywinpty[39m >=2.0.3 
    │       │   └── [34mterminado[39m >=0.8.3 
    │       │       ├── [36mptyprocess[39m * 
    │       │       ├── [36mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │       │       └── [36mtornado[39m >=6.1.0 (circular dependency aborted here)
    │       ├── [35mnbconvert[39m >=6.4.4 
    │       │   ├── [34mbeautifulsoup4[39m * 
    │       │   │   ├── [36msoupsieve[39m >1.2 
    │       │   │   └── [36mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │       │   ├── [34mbleach[39m !=5.0.0 
    │       │   │   ├── [36mtinycss2[39m >=1.1.0,<1.5 
    │       │   │   │   └── [33mwebencodings[39m >=0.4 
    │       │   │   └── [36mwebencodings[39m * (circular dependency aborted here)
    │       │   ├── [34mdefusedxml[39m * 
    │       │   ├── [34mjinja2[39m >=3.0 (circular dependency aborted here)
    │       │   ├── [34mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │       │   ├── [34mjupyterlab-pygments[39m * 
    │       │   ├── [34mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │       │   ├── [34mmistune[39m >=2.0.3,<4 
    │       │   ├── [34mnbclient[39m >=0.5.0 
    │       │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   ├── [36mnbformat[39m >=5.1 
    │       │   │   │   ├── [33mfastjsonschema[39m >=2.15 
    │       │   │   │   ├── [33mjsonschema[39m >=2.6 (circular dependency aborted here)
    │       │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   │   └── [33mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       │   │   └── [36mtraitlets[39m >=5.4 (circular dependency aborted here)
    │       │   ├── [34mnbformat[39m >=5.7 (circular dependency aborted here)
    │       │   ├── [34mpackaging[39m * (circular dependency aborted here)
    │       │   ├── [34mpandocfilters[39m >=1.4.1 
    │       │   ├── [34mpygments[39m >=2.4.1 
    │       │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       ├── [35mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │       ├── [35moverrides[39m >=5.0 
    │       ├── [35mpackaging[39m >=22.0 (circular dependency aborted here)
    │       ├── [35mprometheus-client[39m >=0.9 
    │       ├── [35mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │       ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │       ├── [35msend2trash[39m >=1.8.2 
    │       ├── [35mterminado[39m >=0.8.3 (circular dependency aborted here)
    │       ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
    │       ├── [35mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │       └── [35mwebsocket-client[39m >=1.7 
    └── [33mjupyterlab[39m >=4.1.0,<5.0.0a0
        ├── [32masync-lru[39m >=1.0.0 
        ├── [32mhttpx[39m >=0.25.0 
        │   ├── [35manyio[39m * 
        │   │   ├── [34midna[39m >=2.8 
        │   │   ├── [34msniffio[39m >=1.1 
        │   │   └── [34mtyping-extensions[39m >=4.5 
        │   ├── [35mcertifi[39m * 
        │   ├── [35mhttpcore[39m ==1.* 
        │   │   ├── [34mcertifi[39m * (circular dependency aborted here)
        │   │   └── [34mh11[39m >=0.13,<0.15 
        │   └── [35midna[39m * (circular dependency aborted here)
        ├── [32mipykernel[39m >=6.5.0 
        │   ├── [35mappnope[39m * 
        │   ├── [35mcomm[39m >=0.1.1 
        │   │   └── [34mtraitlets[39m >=4 
        │   ├── [35mdebugpy[39m >=1.6.5 
        │   ├── [35mipython[39m >=7.23.1 
        │   │   ├── [34mcolorama[39m * 
        │   │   ├── [34mdecorator[39m * 
        │   │   ├── [34mipython-pygments-lexers[39m * 
        │   │   │   └── [36mpygments[39m * 
        │   │   ├── [34mjedi[39m >=0.16 
        │   │   │   └── [36mparso[39m >=0.8.4,<0.9.0 
        │   │   ├── [34mmatplotlib-inline[39m * 
        │   │   │   └── [36mtraitlets[39m * (circular dependency aborted here)
        │   │   ├── [34mpexpect[39m >4.3 
        │   │   │   └── [36mptyprocess[39m >=0.5 
        │   │   ├── [34mprompt-toolkit[39m >=3.0.41,<3.1.0 
        │   │   │   └── [36mwcwidth[39m * 
        │   │   ├── [34mpygments[39m >=2.4.0 (circular dependency aborted here)
        │   │   ├── [34mstack-data[39m * 
        │   │   │   ├── [36masttokens[39m >=2.1.0 
        │   │   │   ├── [36mexecuting[39m >=1.2.0 
        │   │   │   └── [36mpure-eval[39m * 
        │   │   └── [34mtraitlets[39m >=5.13.0 (circular dependency aborted here)
        │   ├── [35mjupyter-client[39m >=6.1.12 
        │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
        │   │   │   ├── [36mplatformdirs[39m >=2.5 
        │   │   │   ├── [36mpywin32[39m >=300 
        │   │   │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
        │   │   ├── [34mpython-dateutil[39m >=2.8.2 
        │   │   │   └── [36msix[39m >=1.5 
        │   │   ├── [34mpyzmq[39m >=23.0 
        │   │   │   └── [36mcffi[39m * 
        │   │   │       └── [33mpycparser[39m * 
        │   │   ├── [34mtornado[39m >=6.2 
        │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
        │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │   ├── [35mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
        │   ├── [35mnest-asyncio[39m * 
        │   ├── [35mpackaging[39m * 
        │   ├── [35mpsutil[39m * 
        │   ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
        │   ├── [35mtornado[39m >=6.1 (circular dependency aborted here)
        │   └── [35mtraitlets[39m >=5.4.0 (circular dependency aborted here)
        ├── [32mjinja2[39m >=3.0.3 
        │   └── [35mmarkupsafe[39m >=2.0 
        ├── [32mjupyter-core[39m * (circular dependency aborted here)
        ├── [32mjupyter-lsp[39m >=2.0.0 
        │   └── [35mjupyter-server[39m >=1.1.2 
        │       ├── [34manyio[39m >=3.1.0 (circular dependency aborted here)
        │       ├── [34margon2-cffi[39m >=21.1 
        │       │   └── [36margon2-cffi-bindings[39m * 
        │       │       └── [33mcffi[39m >=1.0.1 (circular dependency aborted here)
        │       ├── [34mjinja2[39m >=3.0.3 (circular dependency aborted here)
        │       ├── [34mjupyter-client[39m >=7.4.4 (circular dependency aborted here)
        │       ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │       ├── [34mjupyter-events[39m >=0.11.0 
        │       │   ├── [36mjsonschema[39m >=4.18.0 
        │       │   │   ├── [33mattrs[39m >=22.2.0 
        │       │   │   ├── [33mfqdn[39m * 
        │       │   │   ├── [33midna[39m * (circular dependency aborted here)
        │       │   │   ├── [33misoduration[39m * 
        │       │   │   │   └── [32marrow[39m >=0.15.0 
        │       │   │   │       ├── [35mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
        │       │   │   │       └── [35mtypes-python-dateutil[39m >=2.8.10 
        │       │   │   ├── [33mjsonpointer[39m >1.13 
        │       │   │   ├── [33mjsonschema-specifications[39m >=2023.03.6 
        │       │   │   │   └── [32mreferencing[39m >=0.31.0 
        │       │   │   │       ├── [35mattrs[39m >=22.2.0 (circular dependency aborted here)
        │       │   │   │       ├── [35mrpds-py[39m >=0.7.0 
        │       │   │   │       └── [35mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
        │       │   │   ├── [33mreferencing[39m >=0.28.4 (circular dependency aborted here)
        │       │   │   ├── [33mrfc3339-validator[39m * 
        │       │   │   │   └── [32msix[39m * (circular dependency aborted here)
        │       │   │   ├── [33mrfc3986-validator[39m >0.1.0 
        │       │   │   ├── [33mrpds-py[39m >=0.7.1 (circular dependency aborted here)
        │       │   │   ├── [33muri-template[39m * 
        │       │   │   └── [33mwebcolors[39m >=24.6.0 
        │       │   ├── [36mpackaging[39m * (circular dependency aborted here)
        │       │   ├── [36mpython-json-logger[39m >=2.0.4 
        │       │   ├── [36mpyyaml[39m >=5.3 
        │       │   ├── [36mreferencing[39m * (circular dependency aborted here)
        │       │   ├── [36mrfc3339-validator[39m * (circular dependency aborted here)
        │       │   ├── [36mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
        │       │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
        │       ├── [34mjupyter-server-terminals[39m >=0.4.4 
        │       │   ├── [36mpywinpty[39m >=2.0.3 
        │       │   └── [36mterminado[39m >=0.8.3 
        │       │       ├── [33mptyprocess[39m * (circular dependency aborted here)
        │       │       ├── [33mpywinpty[39m >=1.1.0 (circular dependency aborted here)
        │       │       └── [33mtornado[39m >=6.1.0 (circular dependency aborted here)
        │       ├── [34mnbconvert[39m >=6.4.4 
        │       │   ├── [36mbeautifulsoup4[39m * 
        │       │   │   ├── [33msoupsieve[39m >1.2 
        │       │   │   └── [33mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
        │       │   ├── [36mbleach[39m !=5.0.0 
        │       │   │   ├── [33mtinycss2[39m >=1.1.0,<1.5 
        │       │   │   │   └── [32mwebencodings[39m >=0.4 
        │       │   │   └── [33mwebencodings[39m * (circular dependency aborted here)
        │       │   ├── [36mdefusedxml[39m * 
        │       │   ├── [36mjinja2[39m >=3.0 (circular dependency aborted here)
        │       │   ├── [36mjupyter-core[39m >=4.7 (circular dependency aborted here)
        │       │   ├── [36mjupyterlab-pygments[39m * 
        │       │   ├── [36mmarkupsafe[39m >=2.0 (circular dependency aborted here)
        │       │   ├── [36mmistune[39m >=2.0.3,<4 
        │       │   ├── [36mnbclient[39m >=0.5.0 
        │       │   │   ├── [33mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
        │       │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │       │   │   ├── [33mnbformat[39m >=5.1 
        │       │   │   │   ├── [32mfastjsonschema[39m >=2.15 
        │       │   │   │   ├── [32mjsonschema[39m >=2.6 (circular dependency aborted here)
        │       │   │   │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
        │       │   │   │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
        │       │   │   └── [33mtraitlets[39m >=5.4 (circular dependency aborted here)
        │       │   ├── [36mnbformat[39m >=5.7 (circular dependency aborted here)
        │       │   ├── [36mpackaging[39m * (circular dependency aborted here)
        │       │   ├── [36mpandocfilters[39m >=1.4.1 
        │       │   ├── [36mpygments[39m >=2.4.1 (circular dependency aborted here)
        │       │   └── [36mtraitlets[39m >=5.1 (circular dependency aborted here)
        │       ├── [34mnbformat[39m >=5.3.0 (circular dependency aborted here)
        │       ├── [34moverrides[39m >=5.0 
        │       ├── [34mpackaging[39m >=22.0 (circular dependency aborted here)
        │       ├── [34mprometheus-client[39m >=0.9 
        │       ├── [34mpywinpty[39m >=2.0.1 (circular dependency aborted here)
        │       ├── [34mpyzmq[39m >=24 (circular dependency aborted here)
        │       ├── [34msend2trash[39m >=1.8.2 
        │       ├── [34mterminado[39m >=0.8.3 (circular dependency aborted here)
        │       ├── [34mtornado[39m >=6.2.0 (circular dependency aborted here)
        │       ├── [34mtraitlets[39m >=5.6.0 (circular dependency aborted here)
        │       └── [34mwebsocket-client[39m >=1.7 
        ├── [32mjupyter-server[39m >=2.4.0,<3 (circular dependency aborted here)
        ├── [32mjupyterlab-server[39m >=2.27.1,<3 
        │   ├── [35mbabel[39m >=2.10 
        │   ├── [35mjinja2[39m >=3.0.3 (circular dependency aborted here)
        │   ├── [35mjson5[39m >=0.9.0 
        │   ├── [35mjsonschema[39m >=4.18.0 (circular dependency aborted here)
        │   ├── [35mjupyter-server[39m >=1.21,<3 (circular dependency aborted here)
        │   ├── [35mpackaging[39m >=21.3 (circular dependency aborted here)
        │   └── [35mrequests[39m >=2.31 
        │       ├── [34mcertifi[39m >=2017.4.17 (circular dependency aborted here)
        │       ├── [34mcharset-normalizer[39m >=2,<4 
        │       ├── [34midna[39m >=2.5,<4 (circular dependency aborted here)
        │       └── [34murllib3[39m >=1.21.1,<3 
        ├── [32mnotebook-shim[39m >=0.2 
        │   └── [35mjupyter-server[39m >=1.8,<3 (circular dependency aborted here)
        ├── [32mpackaging[39m * (circular dependency aborted here)
        ├── [32msetuptools[39m >=40.8.0 
        ├── [32mtornado[39m >=6.2.0 (circular dependency aborted here)
        └── [32mtraitlets[39m * (circular dependency aborted here)
    [36mjupytext[39m [39;1m1.16.7[39;22m Jupyter notebooks as Markdown documents, Julia, Python or R scripts
    ├── [33mmarkdown-it-py[39m >=1.0
    │   └── [32mmdurl[39m >=0.1,<1.0 
    ├── [33mmdit-py-plugins[39m *
    │   └── [32mmarkdown-it-py[39m >=1.0.0,<4.0.0 
    │       └── [35mmdurl[39m >=0.1,<1.0 
    ├── [33mnbformat[39m *
    │   ├── [32mfastjsonschema[39m >=2.15 
    │   ├── [32mjsonschema[39m >=2.6 
    │   │   ├── [35mattrs[39m >=22.2.0 
    │   │   ├── [35mfqdn[39m * 
    │   │   ├── [35midna[39m * 
    │   │   ├── [35misoduration[39m * 
    │   │   │   └── [34marrow[39m >=0.15.0 
    │   │   │       ├── [36mpython-dateutil[39m >=2.7.0 
    │   │   │       │   └── [33msix[39m >=1.5 
    │   │   │       └── [36mtypes-python-dateutil[39m >=2.8.10 
    │   │   ├── [35mjsonpointer[39m >1.13 
    │   │   ├── [35mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   └── [34mreferencing[39m >=0.31.0 
    │   │   │       ├── [36mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │       ├── [36mrpds-py[39m >=0.7.0 
    │   │   │       └── [36mtyping-extensions[39m >=4.4.0 
    │   │   ├── [35mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   ├── [35mrfc3339-validator[39m * 
    │   │   │   └── [34msix[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3986-validator[39m >0.1.0 
    │   │   ├── [35mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   ├── [35muri-template[39m * 
    │   │   └── [35mwebcolors[39m >=24.6.0 
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   ├── [35mplatformdirs[39m >=2.5 
    │   │   ├── [35mpywin32[39m >=300 
    │   │   └── [35mtraitlets[39m >=5.3 
    │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
    ├── [33mpackaging[39m *
    └── [33mpyyaml[39m *
    [36mlux-api[39m [39;1m0.5.1[39;22m A Python API for Intelligent Data Discovery
    ├── [33maltair[39m >=4.0.0
    │   ├── [32mjinja2[39m * 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjsonschema[39m >=3.0 
    │   │   ├── [35mattrs[39m >=22.2.0 
    │   │   ├── [35mfqdn[39m * 
    │   │   ├── [35midna[39m * 
    │   │   ├── [35misoduration[39m * 
    │   │   │   └── [34marrow[39m >=0.15.0 
    │   │   │       ├── [36mpython-dateutil[39m >=2.7.0 
    │   │   │       │   └── [33msix[39m >=1.5 
    │   │   │       └── [36mtypes-python-dateutil[39m >=2.8.10 
    │   │   ├── [35mjsonpointer[39m >1.13 
    │   │   ├── [35mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   └── [34mreferencing[39m >=0.31.0 
    │   │   │       ├── [36mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │       ├── [36mrpds-py[39m >=0.7.0 
    │   │   │       └── [36mtyping-extensions[39m >=4.4.0 
    │   │   ├── [35mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   ├── [35mrfc3339-validator[39m * 
    │   │   │   └── [34msix[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3986-validator[39m >0.1.0 
    │   │   ├── [35mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   ├── [35muri-template[39m * 
    │   │   └── [35mwebcolors[39m >=24.6.0 
    │   ├── [32mnarwhals[39m >=1.14.2 
    │   ├── [32mpackaging[39m * 
    │   └── [32mtyping-extensions[39m >=4.10.0 (circular dependency aborted here)
    ├── [33mautopep8[39m >=1.5
    │   └── [32mpycodestyle[39m >=2.12.0 
    ├── [33miso3166[39m *
    ├── [33mlux-widget[39m >=0.1.4
    │   ├── [32mipywidgets[39m >=7.5.0 
    │   │   ├── [35mcomm[39m >=0.1.3 
    │   │   │   └── [34mtraitlets[39m >=4 
    │   │   ├── [35mipython[39m >=6.1.0 
    │   │   │   ├── [34mcolorama[39m * 
    │   │   │   ├── [34mdecorator[39m * 
    │   │   │   ├── [34mipython-pygments-lexers[39m * 
    │   │   │   │   └── [36mpygments[39m * 
    │   │   │   ├── [34mjedi[39m >=0.16 
    │   │   │   │   └── [36mparso[39m >=0.8.4,<0.9.0 
    │   │   │   ├── [34mmatplotlib-inline[39m * 
    │   │   │   │   └── [36mtraitlets[39m * (circular dependency aborted here)
    │   │   │   ├── [34mpexpect[39m >4.3 
    │   │   │   │   └── [36mptyprocess[39m >=0.5 
    │   │   │   ├── [34mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   │   └── [36mwcwidth[39m * 
    │   │   │   ├── [34mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   │   ├── [34mstack-data[39m * 
    │   │   │   │   ├── [36masttokens[39m >=2.1.0 
    │   │   │   │   ├── [36mexecuting[39m >=1.2.0 
    │   │   │   │   └── [36mpure-eval[39m * 
    │   │   │   └── [34mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   │   ├── [35mjupyterlab-widgets[39m >=3.0.12,<3.1.0 
    │   │   ├── [35mtraitlets[39m >=4.3.1 (circular dependency aborted here)
    │   │   └── [35mwidgetsnbextension[39m >=4.0.12,<4.1.0 
    │   └── [32mnotebook[39m >=4.0.0 
    │       ├── [35mjupyter-server[39m >=2.4.0,<3 
    │       │   ├── [34manyio[39m >=3.1.0 
    │       │   │   ├── [36midna[39m >=2.8 
    │       │   │   ├── [36msniffio[39m >=1.1 
    │       │   │   └── [36mtyping-extensions[39m >=4.5 
    │       │   ├── [34margon2-cffi[39m >=21.1 
    │       │   │   └── [36margon2-cffi-bindings[39m * 
    │       │   │       └── [33mcffi[39m >=1.0.1 
    │       │   │           └── [32mpycparser[39m * 
    │       │   ├── [34mjinja2[39m >=3.0.3 
    │       │   │   └── [36mmarkupsafe[39m >=2.0 
    │       │   ├── [34mjupyter-client[39m >=7.4.4 
    │       │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │       │   │   │   ├── [33mplatformdirs[39m >=2.5 
    │       │   │   │   ├── [33mpywin32[39m >=300 
    │       │   │   │   └── [33mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       │   │   ├── [36mpython-dateutil[39m >=2.8.2 
    │       │   │   │   └── [33msix[39m >=1.5 
    │       │   │   ├── [36mpyzmq[39m >=23.0 
    │       │   │   │   └── [33mcffi[39m * (circular dependency aborted here)
    │       │   │   ├── [36mtornado[39m >=6.2 
    │       │   │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   ├── [34mjupyter-events[39m >=0.11.0 
    │       │   │   ├── [36mjsonschema[39m >=4.18.0 
    │       │   │   │   ├── [33mattrs[39m >=22.2.0 
    │       │   │   │   ├── [33mfqdn[39m * 
    │       │   │   │   ├── [33midna[39m * (circular dependency aborted here)
    │       │   │   │   ├── [33misoduration[39m * 
    │       │   │   │   │   └── [32marrow[39m >=0.15.0 
    │       │   │   │   │       ├── [35mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │       │   │   │   │       └── [35mtypes-python-dateutil[39m >=2.8.10 
    │       │   │   │   ├── [33mjsonpointer[39m >1.13 
    │       │   │   │   ├── [33mjsonschema-specifications[39m >=2023.03.6 
    │       │   │   │   │   └── [32mreferencing[39m >=0.31.0 
    │       │   │   │   │       ├── [35mattrs[39m >=22.2.0 (circular dependency aborted here)
    │       │   │   │   │       ├── [35mrpds-py[39m >=0.7.0 
    │       │   │   │   │       └── [35mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │       │   │   │   ├── [33mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │       │   │   │   ├── [33mrfc3339-validator[39m * 
    │       │   │   │   │   └── [32msix[39m * (circular dependency aborted here)
    │       │   │   │   ├── [33mrfc3986-validator[39m >0.1.0 
    │       │   │   │   ├── [33mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │       │   │   │   ├── [33muri-template[39m * 
    │       │   │   │   └── [33mwebcolors[39m >=24.6.0 
    │       │   │   ├── [36mpackaging[39m * 
    │       │   │   ├── [36mpython-json-logger[39m >=2.0.4 
    │       │   │   ├── [36mpyyaml[39m >=5.3 
    │       │   │   ├── [36mreferencing[39m * (circular dependency aborted here)
    │       │   │   ├── [36mrfc3339-validator[39m * (circular dependency aborted here)
    │       │   │   ├── [36mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │       │   │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       │   ├── [34mjupyter-server-terminals[39m >=0.4.4 
    │       │   │   ├── [36mpywinpty[39m >=2.0.3 
    │       │   │   └── [36mterminado[39m >=0.8.3 
    │       │   │       ├── [33mptyprocess[39m * (circular dependency aborted here)
    │       │   │       ├── [33mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │       │   │       └── [33mtornado[39m >=6.1.0 (circular dependency aborted here)
    │       │   ├── [34mnbconvert[39m >=6.4.4 
    │       │   │   ├── [36mbeautifulsoup4[39m * 
    │       │   │   │   ├── [33msoupsieve[39m >1.2 
    │       │   │   │   └── [33mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │       │   │   ├── [36mbleach[39m !=5.0.0 
    │       │   │   │   ├── [33mtinycss2[39m >=1.1.0,<1.5 
    │       │   │   │   │   └── [32mwebencodings[39m >=0.4 
    │       │   │   │   └── [33mwebencodings[39m * (circular dependency aborted here)
    │       │   │   ├── [36mdefusedxml[39m * 
    │       │   │   ├── [36mjinja2[39m >=3.0 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │       │   │   ├── [36mjupyterlab-pygments[39m * 
    │       │   │   ├── [36mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │       │   │   ├── [36mmistune[39m >=2.0.3,<4 
    │       │   │   ├── [36mnbclient[39m >=0.5.0 
    │       │   │   │   ├── [33mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │       │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   │   ├── [33mnbformat[39m >=5.1 
    │       │   │   │   │   ├── [32mfastjsonschema[39m >=2.15 
    │       │   │   │   │   ├── [32mjsonschema[39m >=2.6 (circular dependency aborted here)
    │       │   │   │   │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   │   │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       │   │   │   └── [33mtraitlets[39m >=5.4 (circular dependency aborted here)
    │       │   │   ├── [36mnbformat[39m >=5.7 (circular dependency aborted here)
    │       │   │   ├── [36mpackaging[39m * (circular dependency aborted here)
    │       │   │   ├── [36mpandocfilters[39m >=1.4.1 
    │       │   │   ├── [36mpygments[39m >=2.4.1 (circular dependency aborted here)
    │       │   │   └── [36mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       │   ├── [34mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │       │   ├── [34moverrides[39m >=5.0 
    │       │   ├── [34mpackaging[39m >=22.0 (circular dependency aborted here)
    │       │   ├── [34mprometheus-client[39m >=0.9 
    │       │   ├── [34mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │       │   ├── [34mpyzmq[39m >=24 (circular dependency aborted here)
    │       │   ├── [34msend2trash[39m >=1.8.2 
    │       │   ├── [34mterminado[39m >=0.8.3 (circular dependency aborted here)
    │       │   ├── [34mtornado[39m >=6.2.0 (circular dependency aborted here)
    │       │   ├── [34mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │       │   └── [34mwebsocket-client[39m >=1.7 
    │       ├── [35mjupyterlab[39m >=4.3.6,<4.4 
    │       │   ├── [34masync-lru[39m >=1.0.0 
    │       │   ├── [34mhttpx[39m >=0.25.0 
    │       │   │   ├── [36manyio[39m * (circular dependency aborted here)
    │       │   │   ├── [36mcertifi[39m * 
    │       │   │   ├── [36mhttpcore[39m ==1.* 
    │       │   │   │   ├── [33mcertifi[39m * (circular dependency aborted here)
    │       │   │   │   └── [33mh11[39m >=0.13,<0.15 
    │       │   │   └── [36midna[39m * (circular dependency aborted here)
    │       │   ├── [34mipykernel[39m >=6.5.0 
    │       │   │   ├── [36mappnope[39m * 
    │       │   │   ├── [36mcomm[39m >=0.1.1 (circular dependency aborted here)
    │       │   │   ├── [36mdebugpy[39m >=1.6.5 
    │       │   │   ├── [36mipython[39m >=7.23.1 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   ├── [36mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
    │       │   │   ├── [36mnest-asyncio[39m * 
    │       │   │   ├── [36mpackaging[39m * (circular dependency aborted here)
    │       │   │   ├── [36mpsutil[39m * 
    │       │   │   ├── [36mpyzmq[39m >=24 (circular dependency aborted here)
    │       │   │   ├── [36mtornado[39m >=6.1 (circular dependency aborted here)
    │       │   │   └── [36mtraitlets[39m >=5.4.0 (circular dependency aborted here)
    │       │   ├── [34mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │       │   ├── [34mjupyter-core[39m * (circular dependency aborted here)
    │       │   ├── [34mjupyter-lsp[39m >=2.0.0 
    │       │   │   └── [36mjupyter-server[39m >=1.1.2 (circular dependency aborted here)
    │       │   ├── [34mjupyter-server[39m >=2.4.0,<3 (circular dependency aborted here)
    │       │   ├── [34mjupyterlab-server[39m >=2.27.1,<3 
    │       │   │   ├── [36mbabel[39m >=2.10 
    │       │   │   ├── [36mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │       │   │   ├── [36mjson5[39m >=0.9.0 
    │       │   │   ├── [36mjsonschema[39m >=4.18.0 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-server[39m >=1.21,<3 (circular dependency aborted here)
    │       │   │   ├── [36mpackaging[39m >=21.3 (circular dependency aborted here)
    │       │   │   └── [36mrequests[39m >=2.31 
    │       │   │       ├── [33mcertifi[39m >=2017.4.17 (circular dependency aborted here)
    │       │   │       ├── [33mcharset-normalizer[39m >=2,<4 
    │       │   │       ├── [33midna[39m >=2.5,<4 (circular dependency aborted here)
    │       │   │       └── [33murllib3[39m >=1.21.1,<3 
    │       │   ├── [34mnotebook-shim[39m >=0.2 
    │       │   │   └── [36mjupyter-server[39m >=1.8,<3 (circular dependency aborted here)
    │       │   ├── [34mpackaging[39m * (circular dependency aborted here)
    │       │   ├── [34msetuptools[39m >=40.8.0 
    │       │   ├── [34mtornado[39m >=6.2.0 (circular dependency aborted here)
    │       │   └── [34mtraitlets[39m * (circular dependency aborted here)
    │       ├── [35mjupyterlab-server[39m >=2.27.1,<3 (circular dependency aborted here)
    │       ├── [35mnotebook-shim[39m >=0.2,<0.3 (circular dependency aborted here)
    │       └── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
    ├── [33mmatplotlib[39m >=3.0.0
    │   ├── [32mcontourpy[39m >=1.0.1 
    │   │   └── [35mnumpy[39m >=1.23 
    │   ├── [32mcycler[39m >=0.10 
    │   ├── [32mfonttools[39m >=4.22.0 
    │   ├── [32mkiwisolver[39m >=1.3.1 
    │   ├── [32mnumpy[39m >=1.23 (circular dependency aborted here)
    │   ├── [32mpackaging[39m >=20.0 
    │   ├── [32mpillow[39m >=8 
    │   ├── [32mpyparsing[39m >=2.3.1 
    │   └── [32mpython-dateutil[39m >=2.7 
    │       └── [35msix[39m >=1.5 
    ├── [33mnumpy[39m >=1.16.5
    ├── [33mpandas[39m *
    │   ├── [32mnumpy[39m >=1.26.0 
    │   ├── [32mpython-dateutil[39m >=2.8.2 
    │   │   └── [35msix[39m >=1.5 
    │   ├── [32mpytz[39m >=2020.1 
    │   └── [32mtzdata[39m >=2022.7 
    ├── [33mpsutil[39m >=5.9.0
    ├── [33mscikit-learn[39m >=0.22
    │   ├── [32mjoblib[39m >=1.2.0 
    │   ├── [32mnumpy[39m >=1.19.5 
    │   ├── [32mscipy[39m >=1.6.0 
    │   │   └── [35mnumpy[39m >=1.23.5,<2.5 (circular dependency aborted here)
    │   └── [32mthreadpoolctl[39m >=3.1.0 
    ├── [33mscipy[39m >=1.3.3
    │   └── [32mnumpy[39m >=1.23.5,<2.5 
    └── [33msh[39m *
    [36mmatplotlib[39m [39;1m3.10.1[39;22m Python plotting package
    ├── [33mcontourpy[39m >=1.0.1
    │   └── [32mnumpy[39m >=1.23 
    ├── [33mcycler[39m >=0.10
    ├── [33mfonttools[39m >=4.22.0
    ├── [33mkiwisolver[39m >=1.3.1
    ├── [33mnumpy[39m >=1.23
    ├── [33mpackaging[39m >=20.0
    ├── [33mpillow[39m >=8
    ├── [33mpyparsing[39m >=2.3.1
    └── [33mpython-dateutil[39m >=2.7
        └── [32msix[39m >=1.5 
    [36mmock[39m [39;1m5.2.0[39;22m Rolling backport of unittest.mock for all Pythons
    [36mmore-itertools[39m [39;1m10.6.0[39;22m More routines for operating on iterables, beyond itertools
    [36mmypy[39m [39;1m1.15.0[39;22m Optional static typing for Python
    ├── [33mmypy-extensions[39m >=1.0.0
    └── [33mtyping-extensions[39m >=4.6.0
    [36mmysql-connector-python[39m [39;1m9.2.0[39;22m A self-contained Python driver for communicating with MySQL servers, using an API that is compliant with the Python Database API Specification v2.0 (PEP 249).
    [36mmysqlclient[39m [39;1m2.2.7[39;22m Python interface to MySQL
    [36mnbsphinx[39m [39;1m0.9.7[39;22m Jupyter Notebook Tools for Sphinx
    ├── [33mdocutils[39m >=0.18.1
    ├── [33mjinja2[39m *
    │   └── [32mmarkupsafe[39m >=2.0 
    ├── [33mnbconvert[39m >=5.3,<5.4 || >5.4
    │   ├── [32mbeautifulsoup4[39m * 
    │   │   ├── [35msoupsieve[39m >1.2 
    │   │   └── [35mtyping-extensions[39m >=4.0.0 
    │   ├── [32mbleach[39m !=5.0.0 
    │   │   ├── [35mtinycss2[39m >=1.1.0,<1.5 
    │   │   │   └── [34mwebencodings[39m >=0.4 
    │   │   └── [35mwebencodings[39m * (circular dependency aborted here)
    │   ├── [32mdefusedxml[39m * 
    │   ├── [32mjinja2[39m >=3.0 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjupyter-core[39m >=4.7 
    │   │   ├── [35mplatformdirs[39m >=2.5 
    │   │   ├── [35mpywin32[39m >=300 
    │   │   └── [35mtraitlets[39m >=5.3 
    │   ├── [32mjupyterlab-pygments[39m * 
    │   ├── [32mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   ├── [32mmistune[39m >=2.0.3,<4 
    │   ├── [32mnbclient[39m >=0.5.0 
    │   │   ├── [35mjupyter-client[39m >=6.1.12 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   ├── [34mpython-dateutil[39m >=2.8.2 
    │   │   │   │   └── [36msix[39m >=1.5 
    │   │   │   ├── [34mpyzmq[39m >=23.0 
    │   │   │   │   └── [36mcffi[39m * 
    │   │   │   │       └── [33mpycparser[39m * 
    │   │   │   ├── [34mtornado[39m >=6.2 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   ├── [35mnbformat[39m >=5.1 
    │   │   │   ├── [34mfastjsonschema[39m >=2.15 
    │   │   │   ├── [34mjsonschema[39m >=2.6 
    │   │   │   │   ├── [36mattrs[39m >=22.2.0 
    │   │   │   │   ├── [36mfqdn[39m * 
    │   │   │   │   ├── [36midna[39m * 
    │   │   │   │   ├── [36misoduration[39m * 
    │   │   │   │   │   └── [33marrow[39m >=0.15.0 
    │   │   │   │   │       ├── [32mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │   │   │   │   │       └── [32mtypes-python-dateutil[39m >=2.8.10 
    │   │   │   │   ├── [36mjsonpointer[39m >1.13 
    │   │   │   │   ├── [36mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   │   │   └── [33mreferencing[39m >=0.31.0 
    │   │   │   │   │       ├── [32mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │   │   │       ├── [32mrpds-py[39m >=0.7.0 
    │   │   │   │   │       └── [32mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │   │   │   │   ├── [36mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   │   │   ├── [36mrfc3339-validator[39m * 
    │   │   │   │   │   └── [33msix[39m * (circular dependency aborted here)
    │   │   │   │   ├── [36mrfc3986-validator[39m >0.1.0 
    │   │   │   │   ├── [36mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   │   │   ├── [36muri-template[39m * 
    │   │   │   │   └── [36mwebcolors[39m >=24.6.0 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   └── [35mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   ├── [32mnbformat[39m >=5.7 (circular dependency aborted here)
    │   ├── [32mpackaging[39m * 
    │   ├── [32mpandocfilters[39m >=1.4.1 
    │   ├── [32mpygments[39m >=2.4.1 
    │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
    ├── [33mnbformat[39m *
    │   ├── [32mfastjsonschema[39m >=2.15 
    │   ├── [32mjsonschema[39m >=2.6 
    │   │   ├── [35mattrs[39m >=22.2.0 
    │   │   ├── [35mfqdn[39m * 
    │   │   ├── [35midna[39m * 
    │   │   ├── [35misoduration[39m * 
    │   │   │   └── [34marrow[39m >=0.15.0 
    │   │   │       ├── [36mpython-dateutil[39m >=2.7.0 
    │   │   │       │   └── [33msix[39m >=1.5 
    │   │   │       └── [36mtypes-python-dateutil[39m >=2.8.10 
    │   │   ├── [35mjsonpointer[39m >1.13 
    │   │   ├── [35mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   └── [34mreferencing[39m >=0.31.0 
    │   │   │       ├── [36mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │       ├── [36mrpds-py[39m >=0.7.0 
    │   │   │       └── [36mtyping-extensions[39m >=4.4.0 
    │   │   ├── [35mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   ├── [35mrfc3339-validator[39m * 
    │   │   │   └── [34msix[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3986-validator[39m >0.1.0 
    │   │   ├── [35mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   ├── [35muri-template[39m * 
    │   │   └── [35mwebcolors[39m >=24.6.0 
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   ├── [35mplatformdirs[39m >=2.5 
    │   │   ├── [35mpywin32[39m >=300 
    │   │   └── [35mtraitlets[39m >=5.3 
    │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
    ├── [33msphinx[39m >=1.8,<8.2
    │   ├── [32malabaster[39m >=0.7.14 
    │   ├── [32mbabel[39m >=2.13 
    │   ├── [32mcolorama[39m >=0.4.6 
    │   ├── [32mdocutils[39m >=0.20,<0.22 
    │   ├── [32mimagesize[39m >=1.3 
    │   ├── [32mjinja2[39m >=3.1 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mpackaging[39m >=23.0 
    │   ├── [32mpygments[39m >=2.17 
    │   ├── [32mrequests[39m >=2.30.0 
    │   │   ├── [35mcertifi[39m >=2017.4.17 
    │   │   ├── [35mcharset-normalizer[39m >=2,<4 
    │   │   ├── [35midna[39m >=2.5,<4 
    │   │   └── [35murllib3[39m >=1.21.1,<3 
    │   ├── [32msnowballstemmer[39m >=2.2 
    │   ├── [32msphinxcontrib-applehelp[39m >=1.0.7 
    │   ├── [32msphinxcontrib-devhelp[39m >=1.0.6 
    │   ├── [32msphinxcontrib-htmlhelp[39m >=2.0.6 
    │   ├── [32msphinxcontrib-jsmath[39m >=1.0.1 
    │   ├── [32msphinxcontrib-qthelp[39m >=1.0.6 
    │   └── [32msphinxcontrib-serializinghtml[39m >=1.1.9 
    └── [33mtraitlets[39m >=5
    [36mnetworkx[39m [39;1m3.4.2[39;22m Python package for creating and manipulating graphs and networks
    [36mnodeenv[39m [39;1m1.9.1[39;22m Node.js virtual environment builder
    [36mnodejs[39m [39;1m0.1.1[39;22m Python bindings and utils for Node.js and io.js
    └── [33moptional-django[39m 0.1.0
    [36mnose[39m [39;1m1.3.7[39;22m nose extends unittest to make testing easier
    [36mnotebook[39m [39;1m7.3.3[39;22m Jupyter Notebook - A web-based notebook environment for interactive computing
    ├── [33mjupyter-server[39m >=2.4.0,<3
    │   ├── [32manyio[39m >=3.1.0 
    │   │   ├── [35midna[39m >=2.8 
    │   │   ├── [35msniffio[39m >=1.1 
    │   │   └── [35mtyping-extensions[39m >=4.5 
    │   ├── [32margon2-cffi[39m >=21.1 
    │   │   └── [35margon2-cffi-bindings[39m * 
    │   │       └── [34mcffi[39m >=1.0.1 
    │   │           └── [36mpycparser[39m * 
    │   ├── [32mjinja2[39m >=3.0.3 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjupyter-client[39m >=7.4.4 
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   ├── [34mplatformdirs[39m >=2.5 
    │   │   │   ├── [34mpywin32[39m >=300 
    │   │   │   └── [34mtraitlets[39m >=5.3 
    │   │   ├── [35mpython-dateutil[39m >=2.8.2 
    │   │   │   └── [34msix[39m >=1.5 
    │   │   ├── [35mpyzmq[39m >=23.0 
    │   │   │   └── [34mcffi[39m * (circular dependency aborted here)
    │   │   ├── [35mtornado[39m >=6.2 
    │   │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   ├── [32mjupyter-events[39m >=0.11.0 
    │   │   ├── [35mjsonschema[39m >=4.18.0 
    │   │   │   ├── [34mattrs[39m >=22.2.0 
    │   │   │   ├── [34mfqdn[39m * 
    │   │   │   ├── [34midna[39m * (circular dependency aborted here)
    │   │   │   ├── [34misoduration[39m * 
    │   │   │   │   └── [36marrow[39m >=0.15.0 
    │   │   │   │       ├── [33mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │   │   │   │       └── [33mtypes-python-dateutil[39m >=2.8.10 
    │   │   │   ├── [34mjsonpointer[39m >1.13 
    │   │   │   ├── [34mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   │   └── [36mreferencing[39m >=0.31.0 
    │   │   │   │       ├── [33mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │   │       ├── [33mrpds-py[39m >=0.7.0 
    │   │   │   │       └── [33mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │   │   │   ├── [34mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   │   ├── [34mrfc3339-validator[39m * 
    │   │   │   │   └── [36msix[39m * (circular dependency aborted here)
    │   │   │   ├── [34mrfc3986-validator[39m >0.1.0 
    │   │   │   ├── [34mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   │   ├── [34muri-template[39m * 
    │   │   │   └── [34mwebcolors[39m >=24.6.0 
    │   │   ├── [35mpackaging[39m * 
    │   │   ├── [35mpython-json-logger[39m >=2.0.4 
    │   │   ├── [35mpyyaml[39m >=5.3 
    │   │   ├── [35mreferencing[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3339-validator[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │   │   └── [35mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   ├── [32mjupyter-server-terminals[39m >=0.4.4 
    │   │   ├── [35mpywinpty[39m >=2.0.3 
    │   │   └── [35mterminado[39m >=0.8.3 
    │   │       ├── [34mptyprocess[39m * 
    │   │       ├── [34mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │   │       └── [34mtornado[39m >=6.1.0 (circular dependency aborted here)
    │   ├── [32mnbconvert[39m >=6.4.4 
    │   │   ├── [35mbeautifulsoup4[39m * 
    │   │   │   ├── [34msoupsieve[39m >1.2 
    │   │   │   └── [34mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │   │   ├── [35mbleach[39m !=5.0.0 
    │   │   │   ├── [34mtinycss2[39m >=1.1.0,<1.5 
    │   │   │   │   └── [36mwebencodings[39m >=0.4 
    │   │   │   └── [34mwebencodings[39m * (circular dependency aborted here)
    │   │   ├── [35mdefusedxml[39m * 
    │   │   ├── [35mjinja2[39m >=3.0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │   │   ├── [35mjupyterlab-pygments[39m * 
    │   │   ├── [35mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   │   ├── [35mmistune[39m >=2.0.3,<4 
    │   │   ├── [35mnbclient[39m >=0.5.0 
    │   │   │   ├── [34mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   ├── [34mnbformat[39m >=5.1 
    │   │   │   │   ├── [36mfastjsonschema[39m >=2.15 
    │   │   │   │   ├── [36mjsonschema[39m >=2.6 (circular dependency aborted here)
    │   │   │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   │   └── [36mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   │   └── [34mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   │   ├── [35mnbformat[39m >=5.7 (circular dependency aborted here)
    │   │   ├── [35mpackaging[39m * (circular dependency aborted here)
    │   │   ├── [35mpandocfilters[39m >=1.4.1 
    │   │   ├── [35mpygments[39m >=2.4.1 
    │   │   └── [35mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   ├── [32mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │   ├── [32moverrides[39m >=5.0 
    │   ├── [32mpackaging[39m >=22.0 (circular dependency aborted here)
    │   ├── [32mprometheus-client[39m >=0.9 
    │   ├── [32mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │   ├── [32mpyzmq[39m >=24 (circular dependency aborted here)
    │   ├── [32msend2trash[39m >=1.8.2 
    │   ├── [32mterminado[39m >=0.8.3 (circular dependency aborted here)
    │   ├── [32mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   ├── [32mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │   └── [32mwebsocket-client[39m >=1.7 
    ├── [33mjupyterlab[39m >=4.3.6,<4.4
    │   ├── [32masync-lru[39m >=1.0.0 
    │   ├── [32mhttpx[39m >=0.25.0 
    │   │   ├── [35manyio[39m * 
    │   │   │   ├── [34midna[39m >=2.8 
    │   │   │   ├── [34msniffio[39m >=1.1 
    │   │   │   └── [34mtyping-extensions[39m >=4.5 
    │   │   ├── [35mcertifi[39m * 
    │   │   ├── [35mhttpcore[39m ==1.* 
    │   │   │   ├── [34mcertifi[39m * (circular dependency aborted here)
    │   │   │   └── [34mh11[39m >=0.13,<0.15 
    │   │   └── [35midna[39m * (circular dependency aborted here)
    │   ├── [32mipykernel[39m >=6.5.0 
    │   │   ├── [35mappnope[39m * 
    │   │   ├── [35mcomm[39m >=0.1.1 
    │   │   │   └── [34mtraitlets[39m >=4 
    │   │   ├── [35mdebugpy[39m >=1.6.5 
    │   │   ├── [35mipython[39m >=7.23.1 
    │   │   │   ├── [34mcolorama[39m * 
    │   │   │   ├── [34mdecorator[39m * 
    │   │   │   ├── [34mipython-pygments-lexers[39m * 
    │   │   │   │   └── [36mpygments[39m * 
    │   │   │   ├── [34mjedi[39m >=0.16 
    │   │   │   │   └── [36mparso[39m >=0.8.4,<0.9.0 
    │   │   │   ├── [34mmatplotlib-inline[39m * 
    │   │   │   │   └── [36mtraitlets[39m * (circular dependency aborted here)
    │   │   │   ├── [34mpexpect[39m >4.3 
    │   │   │   │   └── [36mptyprocess[39m >=0.5 
    │   │   │   ├── [34mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   │   └── [36mwcwidth[39m * 
    │   │   │   ├── [34mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   │   ├── [34mstack-data[39m * 
    │   │   │   │   ├── [36masttokens[39m >=2.1.0 
    │   │   │   │   ├── [36mexecuting[39m >=1.2.0 
    │   │   │   │   └── [36mpure-eval[39m * 
    │   │   │   └── [34mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-client[39m >=6.1.12 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   │   ├── [36mplatformdirs[39m >=2.5 
    │   │   │   │   ├── [36mpywin32[39m >=300 
    │   │   │   │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   │   ├── [34mpython-dateutil[39m >=2.8.2 
    │   │   │   │   └── [36msix[39m >=1.5 
    │   │   │   ├── [34mpyzmq[39m >=23.0 
    │   │   │   │   └── [36mcffi[39m * 
    │   │   │   │       └── [33mpycparser[39m * 
    │   │   │   ├── [34mtornado[39m >=6.2 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   ├── [35mmatplotlib-inline[39m >=0.1 (circular dependency aborted here)
    │   │   ├── [35mnest-asyncio[39m * 
    │   │   ├── [35mpackaging[39m * 
    │   │   ├── [35mpsutil[39m * 
    │   │   ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │   │   ├── [35mtornado[39m >=6.1 (circular dependency aborted here)
    │   │   └── [35mtraitlets[39m >=5.4.0 (circular dependency aborted here)
    │   ├── [32mjinja2[39m >=3.0.3 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjupyter-core[39m * (circular dependency aborted here)
    │   ├── [32mjupyter-lsp[39m >=2.0.0 
    │   │   └── [35mjupyter-server[39m >=1.1.2 
    │   │       ├── [34manyio[39m >=3.1.0 (circular dependency aborted here)
    │   │       ├── [34margon2-cffi[39m >=21.1 
    │   │       │   └── [36margon2-cffi-bindings[39m * 
    │   │       │       └── [33mcffi[39m >=1.0.1 (circular dependency aborted here)
    │   │       ├── [34mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │   │       ├── [34mjupyter-client[39m >=7.4.4 (circular dependency aborted here)
    │   │       ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │       ├── [34mjupyter-events[39m >=0.11.0 
    │   │       │   ├── [36mjsonschema[39m >=4.18.0 
    │   │       │   │   ├── [33mattrs[39m >=22.2.0 
    │   │       │   │   ├── [33mfqdn[39m * 
    │   │       │   │   ├── [33midna[39m * (circular dependency aborted here)
    │   │       │   │   ├── [33misoduration[39m * 
    │   │       │   │   │   └── [32marrow[39m >=0.15.0 
    │   │       │   │   │       ├── [35mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │   │       │   │   │       └── [35mtypes-python-dateutil[39m >=2.8.10 
    │   │       │   │   ├── [33mjsonpointer[39m >1.13 
    │   │       │   │   ├── [33mjsonschema-specifications[39m >=2023.03.6 
    │   │       │   │   │   └── [32mreferencing[39m >=0.31.0 
    │   │       │   │   │       ├── [35mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │       │   │   │       ├── [35mrpds-py[39m >=0.7.0 
    │   │       │   │   │       └── [35mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │   │       │   │   ├── [33mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │       │   │   ├── [33mrfc3339-validator[39m * 
    │   │       │   │   │   └── [32msix[39m * (circular dependency aborted here)
    │   │       │   │   ├── [33mrfc3986-validator[39m >0.1.0 
    │   │       │   │   ├── [33mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │       │   │   ├── [33muri-template[39m * 
    │   │       │   │   └── [33mwebcolors[39m >=24.6.0 
    │   │       │   ├── [36mpackaging[39m * (circular dependency aborted here)
    │   │       │   ├── [36mpython-json-logger[39m >=2.0.4 
    │   │       │   ├── [36mpyyaml[39m >=5.3 
    │   │       │   ├── [36mreferencing[39m * (circular dependency aborted here)
    │   │       │   ├── [36mrfc3339-validator[39m * (circular dependency aborted here)
    │   │       │   ├── [36mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │   │       │   └── [36mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │       ├── [34mjupyter-server-terminals[39m >=0.4.4 
    │   │       │   ├── [36mpywinpty[39m >=2.0.3 
    │   │       │   └── [36mterminado[39m >=0.8.3 
    │   │       │       ├── [33mptyprocess[39m * (circular dependency aborted here)
    │   │       │       ├── [33mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │   │       │       └── [33mtornado[39m >=6.1.0 (circular dependency aborted here)
    │   │       ├── [34mnbconvert[39m >=6.4.4 
    │   │       │   ├── [36mbeautifulsoup4[39m * 
    │   │       │   │   ├── [33msoupsieve[39m >1.2 
    │   │       │   │   └── [33mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │   │       │   ├── [36mbleach[39m !=5.0.0 
    │   │       │   │   ├── [33mtinycss2[39m >=1.1.0,<1.5 
    │   │       │   │   │   └── [32mwebencodings[39m >=0.4 
    │   │       │   │   └── [33mwebencodings[39m * (circular dependency aborted here)
    │   │       │   ├── [36mdefusedxml[39m * 
    │   │       │   ├── [36mjinja2[39m >=3.0 (circular dependency aborted here)
    │   │       │   ├── [36mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │   │       │   ├── [36mjupyterlab-pygments[39m * 
    │   │       │   ├── [36mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   │       │   ├── [36mmistune[39m >=2.0.3,<4 
    │   │       │   ├── [36mnbclient[39m >=0.5.0 
    │   │       │   │   ├── [33mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │   │       │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │       │   │   ├── [33mnbformat[39m >=5.1 
    │   │       │   │   │   ├── [32mfastjsonschema[39m >=2.15 
    │   │       │   │   │   ├── [32mjsonschema[39m >=2.6 (circular dependency aborted here)
    │   │       │   │   │   ├── [32mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │       │   │   │   └── [32mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │       │   │   └── [33mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   │       │   ├── [36mnbformat[39m >=5.7 (circular dependency aborted here)
    │   │       │   ├── [36mpackaging[39m * (circular dependency aborted here)
    │   │       │   ├── [36mpandocfilters[39m >=1.4.1 
    │   │       │   ├── [36mpygments[39m >=2.4.1 (circular dependency aborted here)
    │   │       │   └── [36mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │       ├── [34mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │   │       ├── [34moverrides[39m >=5.0 
    │   │       ├── [34mpackaging[39m >=22.0 (circular dependency aborted here)
    │   │       ├── [34mprometheus-client[39m >=0.9 
    │   │       ├── [34mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │   │       ├── [34mpyzmq[39m >=24 (circular dependency aborted here)
    │   │       ├── [34msend2trash[39m >=1.8.2 
    │   │       ├── [34mterminado[39m >=0.8.3 (circular dependency aborted here)
    │   │       ├── [34mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   │       ├── [34mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │   │       └── [34mwebsocket-client[39m >=1.7 
    │   ├── [32mjupyter-server[39m >=2.4.0,<3 (circular dependency aborted here)
    │   ├── [32mjupyterlab-server[39m >=2.27.1,<3 
    │   │   ├── [35mbabel[39m >=2.10 
    │   │   ├── [35mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │   │   ├── [35mjson5[39m >=0.9.0 
    │   │   ├── [35mjsonschema[39m >=4.18.0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-server[39m >=1.21,<3 (circular dependency aborted here)
    │   │   ├── [35mpackaging[39m >=21.3 (circular dependency aborted here)
    │   │   └── [35mrequests[39m >=2.31 
    │   │       ├── [34mcertifi[39m >=2017.4.17 (circular dependency aborted here)
    │   │       ├── [34mcharset-normalizer[39m >=2,<4 
    │   │       ├── [34midna[39m >=2.5,<4 (circular dependency aborted here)
    │   │       └── [34murllib3[39m >=1.21.1,<3 
    │   ├── [32mnotebook-shim[39m >=0.2 
    │   │   └── [35mjupyter-server[39m >=1.8,<3 (circular dependency aborted here)
    │   ├── [32mpackaging[39m * (circular dependency aborted here)
    │   ├── [32msetuptools[39m >=40.8.0 
    │   ├── [32mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   └── [32mtraitlets[39m * (circular dependency aborted here)
    ├── [33mjupyterlab-server[39m >=2.27.1,<3
    │   ├── [32mbabel[39m >=2.10 
    │   ├── [32mjinja2[39m >=3.0.3 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mjson5[39m >=0.9.0 
    │   ├── [32mjsonschema[39m >=4.18.0 
    │   │   ├── [35mattrs[39m >=22.2.0 
    │   │   ├── [35mfqdn[39m * 
    │   │   ├── [35midna[39m * 
    │   │   ├── [35misoduration[39m * 
    │   │   │   └── [34marrow[39m >=0.15.0 
    │   │   │       ├── [36mpython-dateutil[39m >=2.7.0 
    │   │   │       │   └── [33msix[39m >=1.5 
    │   │   │       └── [36mtypes-python-dateutil[39m >=2.8.10 
    │   │   ├── [35mjsonpointer[39m >1.13 
    │   │   ├── [35mjsonschema-specifications[39m >=2023.03.6 
    │   │   │   └── [34mreferencing[39m >=0.31.0 
    │   │   │       ├── [36mattrs[39m >=22.2.0 (circular dependency aborted here)
    │   │   │       ├── [36mrpds-py[39m >=0.7.0 
    │   │   │       └── [36mtyping-extensions[39m >=4.4.0 
    │   │   ├── [35mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │   │   ├── [35mrfc3339-validator[39m * 
    │   │   │   └── [34msix[39m * (circular dependency aborted here)
    │   │   ├── [35mrfc3986-validator[39m >0.1.0 
    │   │   ├── [35mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │   │   ├── [35muri-template[39m * 
    │   │   └── [35mwebcolors[39m >=24.6.0 
    │   ├── [32mjupyter-server[39m >=1.21,<3 
    │   │   ├── [35manyio[39m >=3.1.0 
    │   │   │   ├── [34midna[39m >=2.8 (circular dependency aborted here)
    │   │   │   ├── [34msniffio[39m >=1.1 
    │   │   │   └── [34mtyping-extensions[39m >=4.5 (circular dependency aborted here)
    │   │   ├── [35margon2-cffi[39m >=21.1 
    │   │   │   └── [34margon2-cffi-bindings[39m * 
    │   │   │       └── [36mcffi[39m >=1.0.1 
    │   │   │           └── [33mpycparser[39m * 
    │   │   ├── [35mjinja2[39m >=3.0.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-client[39m >=7.4.4 
    │   │   │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │   │   │   │   ├── [36mplatformdirs[39m >=2.5 
    │   │   │   │   ├── [36mpywin32[39m >=300 
    │   │   │   │   └── [36mtraitlets[39m >=5.3 
    │   │   │   ├── [34mpython-dateutil[39m >=2.8.2 (circular dependency aborted here)
    │   │   │   ├── [34mpyzmq[39m >=23.0 
    │   │   │   │   └── [36mcffi[39m * (circular dependency aborted here)
    │   │   │   ├── [34mtornado[39m >=6.2 
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   ├── [35mjupyter-events[39m >=0.11.0 
    │   │   │   ├── [34mjsonschema[39m >=4.18.0 (circular dependency aborted here)
    │   │   │   ├── [34mpackaging[39m * 
    │   │   │   ├── [34mpython-json-logger[39m >=2.0.4 
    │   │   │   ├── [34mpyyaml[39m >=5.3 
    │   │   │   ├── [34mreferencing[39m * (circular dependency aborted here)
    │   │   │   ├── [34mrfc3339-validator[39m * (circular dependency aborted here)
    │   │   │   ├── [34mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │   │   │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │   │   ├── [35mjupyter-server-terminals[39m >=0.4.4 
    │   │   │   ├── [34mpywinpty[39m >=2.0.3 
    │   │   │   └── [34mterminado[39m >=0.8.3 
    │   │   │       ├── [36mptyprocess[39m * 
    │   │   │       ├── [36mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │   │   │       └── [36mtornado[39m >=6.1.0 (circular dependency aborted here)
    │   │   ├── [35mnbconvert[39m >=6.4.4 
    │   │   │   ├── [34mbeautifulsoup4[39m * 
    │   │   │   │   ├── [36msoupsieve[39m >1.2 
    │   │   │   │   └── [36mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │   │   │   ├── [34mbleach[39m !=5.0.0 
    │   │   │   │   ├── [36mtinycss2[39m >=1.1.0,<1.5 
    │   │   │   │   │   └── [33mwebencodings[39m >=0.4 
    │   │   │   │   └── [36mwebencodings[39m * (circular dependency aborted here)
    │   │   │   ├── [34mdefusedxml[39m * 
    │   │   │   ├── [34mjinja2[39m >=3.0 (circular dependency aborted here)
    │   │   │   ├── [34mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │   │   │   ├── [34mjupyterlab-pygments[39m * 
    │   │   │   ├── [34mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │   │   │   ├── [34mmistune[39m >=2.0.3,<4 
    │   │   │   ├── [34mnbclient[39m >=0.5.0 
    │   │   │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │   │   │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   │   ├── [36mnbformat[39m >=5.1 
    │   │   │   │   │   ├── [33mfastjsonschema[39m >=2.15 
    │   │   │   │   │   ├── [33mjsonschema[39m >=2.6 (circular dependency aborted here)
    │   │   │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │   │   │   │   │   └── [33mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   │   │   └── [36mtraitlets[39m >=5.4 (circular dependency aborted here)
    │   │   │   ├── [34mnbformat[39m >=5.7 (circular dependency aborted here)
    │   │   │   ├── [34mpackaging[39m * (circular dependency aborted here)
    │   │   │   ├── [34mpandocfilters[39m >=1.4.1 
    │   │   │   ├── [34mpygments[39m >=2.4.1 
    │   │   │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │   │   ├── [35mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │   │   ├── [35moverrides[39m >=5.0 
    │   │   ├── [35mpackaging[39m >=22.0 (circular dependency aborted here)
    │   │   ├── [35mprometheus-client[39m >=0.9 
    │   │   ├── [35mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │   │   ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │   │   ├── [35msend2trash[39m >=1.8.2 
    │   │   ├── [35mterminado[39m >=0.8.3 (circular dependency aborted here)
    │   │   ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
    │   │   ├── [35mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │   │   └── [35mwebsocket-client[39m >=1.7 
    │   ├── [32mpackaging[39m >=21.3 (circular dependency aborted here)
    │   └── [32mrequests[39m >=2.31 
    │       ├── [35mcertifi[39m >=2017.4.17 
    │       ├── [35mcharset-normalizer[39m >=2,<4 
    │       ├── [35midna[39m >=2.5,<4 (circular dependency aborted here)
    │       └── [35murllib3[39m >=1.21.1,<3 
    ├── [33mnotebook-shim[39m >=0.2,<0.3
    │   └── [32mjupyter-server[39m >=1.8,<3 
    │       ├── [35manyio[39m >=3.1.0 
    │       │   ├── [34midna[39m >=2.8 
    │       │   ├── [34msniffio[39m >=1.1 
    │       │   └── [34mtyping-extensions[39m >=4.5 
    │       ├── [35margon2-cffi[39m >=21.1 
    │       │   └── [34margon2-cffi-bindings[39m * 
    │       │       └── [36mcffi[39m >=1.0.1 
    │       │           └── [33mpycparser[39m * 
    │       ├── [35mjinja2[39m >=3.0.3 
    │       │   └── [34mmarkupsafe[39m >=2.0 
    │       ├── [35mjupyter-client[39m >=7.4.4 
    │       │   ├── [34mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 
    │       │   │   ├── [36mplatformdirs[39m >=2.5 
    │       │   │   ├── [36mpywin32[39m >=300 
    │       │   │   └── [36mtraitlets[39m >=5.3 
    │       │   ├── [34mpython-dateutil[39m >=2.8.2 
    │       │   │   └── [36msix[39m >=1.5 
    │       │   ├── [34mpyzmq[39m >=23.0 
    │       │   │   └── [36mcffi[39m * (circular dependency aborted here)
    │       │   ├── [34mtornado[39m >=6.2 
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       ├── [35mjupyter-events[39m >=0.11.0 
    │       │   ├── [34mjsonschema[39m >=4.18.0 
    │       │   │   ├── [36mattrs[39m >=22.2.0 
    │       │   │   ├── [36mfqdn[39m * 
    │       │   │   ├── [36midna[39m * (circular dependency aborted here)
    │       │   │   ├── [36misoduration[39m * 


    │       │   │   │   └── [33marrow[39m >=0.15.0 
    │       │   │   │       ├── [32mpython-dateutil[39m >=2.7.0 (circular dependency aborted here)
    │       │   │   │       └── [32mtypes-python-dateutil[39m >=2.8.10 
    │       │   │   ├── [36mjsonpointer[39m >1.13 
    │       │   │   ├── [36mjsonschema-specifications[39m >=2023.03.6 
    │       │   │   │   └── [33mreferencing[39m >=0.31.0 
    │       │   │   │       ├── [32mattrs[39m >=22.2.0 (circular dependency aborted here)
    │       │   │   │       ├── [32mrpds-py[39m >=0.7.0 
    │       │   │   │       └── [32mtyping-extensions[39m >=4.4.0 (circular dependency aborted here)
    │       │   │   ├── [36mreferencing[39m >=0.28.4 (circular dependency aborted here)
    │       │   │   ├── [36mrfc3339-validator[39m * 
    │       │   │   │   └── [33msix[39m * (circular dependency aborted here)
    │       │   │   ├── [36mrfc3986-validator[39m >0.1.0 
    │       │   │   ├── [36mrpds-py[39m >=0.7.1 (circular dependency aborted here)
    │       │   │   ├── [36muri-template[39m * 
    │       │   │   └── [36mwebcolors[39m >=24.6.0 
    │       │   ├── [34mpackaging[39m * 
    │       │   ├── [34mpython-json-logger[39m >=2.0.4 
    │       │   ├── [34mpyyaml[39m >=5.3 
    │       │   ├── [34mreferencing[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3339-validator[39m * (circular dependency aborted here)
    │       │   ├── [34mrfc3986-validator[39m >=0.1.1 (circular dependency aborted here)
    │       │   └── [34mtraitlets[39m >=5.3 (circular dependency aborted here)
    │       ├── [35mjupyter-server-terminals[39m >=0.4.4 
    │       │   ├── [34mpywinpty[39m >=2.0.3 
    │       │   └── [34mterminado[39m >=0.8.3 
    │       │       ├── [36mptyprocess[39m * 
    │       │       ├── [36mpywinpty[39m >=1.1.0 (circular dependency aborted here)
    │       │       └── [36mtornado[39m >=6.1.0 (circular dependency aborted here)
    │       ├── [35mnbconvert[39m >=6.4.4 
    │       │   ├── [34mbeautifulsoup4[39m * 
    │       │   │   ├── [36msoupsieve[39m >1.2 
    │       │   │   └── [36mtyping-extensions[39m >=4.0.0 (circular dependency aborted here)
    │       │   ├── [34mbleach[39m !=5.0.0 
    │       │   │   ├── [36mtinycss2[39m >=1.1.0,<1.5 
    │       │   │   │   └── [33mwebencodings[39m >=0.4 
    │       │   │   └── [36mwebencodings[39m * (circular dependency aborted here)
    │       │   ├── [34mdefusedxml[39m * 
    │       │   ├── [34mjinja2[39m >=3.0 (circular dependency aborted here)
    │       │   ├── [34mjupyter-core[39m >=4.7 (circular dependency aborted here)
    │       │   ├── [34mjupyterlab-pygments[39m * 
    │       │   ├── [34mmarkupsafe[39m >=2.0 (circular dependency aborted here)
    │       │   ├── [34mmistune[39m >=2.0.3,<4 
    │       │   ├── [34mnbclient[39m >=0.5.0 
    │       │   │   ├── [36mjupyter-client[39m >=6.1.12 (circular dependency aborted here)
    │       │   │   ├── [36mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   ├── [36mnbformat[39m >=5.1 
    │       │   │   │   ├── [33mfastjsonschema[39m >=2.15 
    │       │   │   │   ├── [33mjsonschema[39m >=2.6 (circular dependency aborted here)
    │       │   │   │   ├── [33mjupyter-core[39m >=4.12,<5.0.dev0 || >=5.1.dev0 (circular dependency aborted here)
    │       │   │   │   └── [33mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       │   │   └── [36mtraitlets[39m >=5.4 (circular dependency aborted here)
    │       │   ├── [34mnbformat[39m >=5.7 (circular dependency aborted here)
    │       │   ├── [34mpackaging[39m * (circular dependency aborted here)
    │       │   ├── [34mpandocfilters[39m >=1.4.1 
    │       │   ├── [34mpygments[39m >=2.4.1 
    │       │   └── [34mtraitlets[39m >=5.1 (circular dependency aborted here)
    │       ├── [35mnbformat[39m >=5.3.0 (circular dependency aborted here)
    │       ├── [35moverrides[39m >=5.0 
    │       ├── [35mpackaging[39m >=22.0 (circular dependency aborted here)
    │       ├── [35mprometheus-client[39m >=0.9 
    │       ├── [35mpywinpty[39m >=2.0.1 (circular dependency aborted here)
    │       ├── [35mpyzmq[39m >=24 (circular dependency aborted here)
    │       ├── [35msend2trash[39m >=1.8.2 
    │       ├── [35mterminado[39m >=0.8.3 (circular dependency aborted here)
    │       ├── [35mtornado[39m >=6.2.0 (circular dependency aborted here)
    │       ├── [35mtraitlets[39m >=5.6.0 (circular dependency aborted here)
    │       └── [35mwebsocket-client[39m >=1.7 
    └── [33mtornado[39m >=6.2.0
    [36mnumpy[39m [39;1m2.1.3[39;22m Fundamental package for array computing in Python
    [36mnvidia-cublas-cu12[39m [39;1m12.5.3.2[39;22m CUBLAS native runtime libraries
    [36mnvidia-cuda-cupti-cu12[39m [39;1m12.5.82[39;22m CUDA profiling tools runtime libs.
    [36mnvidia-cuda-nvcc-cu12[39m [39;1m12.5.82[39;22m CUDA nvcc
    [36mnvidia-cuda-nvrtc-cu12[39m [39;1m12.5.82[39;22m NVRTC native runtime libraries
    [36mnvidia-cuda-runtime-cu12[39m [39;1m12.5.82[39;22m CUDA Runtime native Libraries
    [36mnvidia-cudnn-cu12[39m [39;1m9.3.0.75[39;22m cuDNN runtime libraries
    └── [33mnvidia-cublas-cu12[39m *
    [36mnvidia-cufft-cu12[39m [39;1m11.2.3.61[39;22m CUFFT native runtime libraries
    └── [33mnvidia-nvjitlink-cu12[39m *
    [36mnvidia-curand-cu12[39m [39;1m10.3.6.82[39;22m CURAND native runtime libraries
    [36mnvidia-cusolver-cu12[39m [39;1m11.6.3.83[39;22m CUDA solver native runtime libraries
    ├── [33mnvidia-cublas-cu12[39m *
    ├── [33mnvidia-cusparse-cu12[39m *
    │   └── [32mnvidia-nvjitlink-cu12[39m * 
    └── [33mnvidia-nvjitlink-cu12[39m *
    [36mnvidia-cusparse-cu12[39m [39;1m12.5.1.3[39;22m CUSPARSE native runtime libraries
    └── [33mnvidia-nvjitlink-cu12[39m *
    [36mnvidia-ml-py[39m [39;1m12.570.86[39;22m Python Bindings for the NVIDIA Management Library
    [36mnvidia-nccl-cu12[39m [39;1m2.23.4[39;22m NVIDIA Collective Communication Library (NCCL) Runtime
    [36mnvidia-nvjitlink-cu12[39m [39;1m12.5.82[39;22m Nvidia JIT LTO Library
    [36moauthlib[39m [39;1m3.2.2[39;22m A generic, spec-compliant, thorough implementation of the OAuth request-signing logic
    [36mopenpyxl[39m [39;1m3.1.5[39;22m A Python library to read/write Excel 2010 xlsx/xlsm files
    └── [33met-xmlfile[39m *
    [36mpandas[39m [39;1m2.2.3[39;22m Powerful data structures for data analysis, time series, and statistics
    ├── [33mnumpy[39m >=1.26.0
    ├── [33mpython-dateutil[39m >=2.8.2
    │   └── [32msix[39m >=1.5 
    ├── [33mpytz[39m >=2020.1
    └── [33mtzdata[39m >=2022.7
    [36mpandas-datareader[39m [39;1m0.10.0[39;22m Data readers extracted from the pandas codebase,should be compatible with recent pandas versions
    ├── [33mlxml[39m *
    ├── [33mpandas[39m >=0.23
    │   ├── [32mnumpy[39m >=1.26.0 
    │   ├── [32mpython-dateutil[39m >=2.8.2 
    │   │   └── [35msix[39m >=1.5 
    │   ├── [32mpytz[39m >=2020.1 
    │   └── [32mtzdata[39m >=2022.7 
    └── [33mrequests[39m >=2.19.0
        ├── [32mcertifi[39m >=2017.4.17 
        ├── [32mcharset-normalizer[39m >=2,<4 
        ├── [32midna[39m >=2.5,<4 
        └── [32murllib3[39m >=1.21.1,<3 
    [36mpillow[39m [39;1m11.1.0[39;22m Python Imaging Library (Fork)
    [36mpiny[39m [39;1m1.1.0[39;22m Load YAML configs with environment variables interpolation
    ├── [33mclick[39m >=8,<9
    │   └── [32mcolorama[39m * 
    └── [33mpyyaml[39m >=6,<7
    [36mpip[39m [39;1m25.0.1[39;22m The PyPA recommended tool for installing Python packages.
    [36mpipreqs[39m [39;1m0.4.13[39;22m Pip requirements.txt generator based on imports in project
    ├── [33mdocopt[39m *
    └── [33myarg[39m *
        └── [32mrequests[39m * 
            ├── [35mcertifi[39m >=2017.4.17 
            ├── [35mcharset-normalizer[39m >=2,<4 
            ├── [35midna[39m >=2.5,<4 
            └── [35murllib3[39m >=1.21.1,<3 
    [36mplotly[39m [39;1m6.0.1[39;22m An open-source interactive data visualization library for Python
    ├── [33mnarwhals[39m >=1.15.1
    └── [33mpackaging[39m *
    [36mpsycopg2-binary[39m [39;1m2.9.10[39;22m psycopg2 - Python-PostgreSQL Database Adapter
    [36mpy[39m [39;1m1.11.0[39;22m library with cross-python path, ini-parsing, io, code, log facilities
    [36mpydot[39m [39;1m3.0.4[39;22m Python interface to Graphviz's Dot
    └── [33mpyparsing[39m >=3.0.9
    [36mpylint[39m [39;1m3.3.5[39;22m python code static checker
    ├── [33mastroid[39m >=3.3.8,<=3.4.0-dev0
    ├── [33mcolorama[39m >=0.4.5
    ├── [33mdill[39m >=0.3.7
    ├── [33misort[39m >=4.2.5,<5.13.0 || >5.13.0,<7
    ├── [33mmccabe[39m >=0.6,<0.8
    ├── [33mplatformdirs[39m >=2.2.0
    └── [33mtomlkit[39m >=0.10.1
    [36mpynvml[39m [39;1m12.0.0[39;22m Python utilities for the NVIDIA Management Library
    └── [33mnvidia-ml-py[39m >=12.0.0,<13.0.0a0
    [36mpyproject-flake8[39m [39;1m0.0.1a4[39;22m pyproject-flake8 (`pflake8`), a monkey patching wrapper to connect flake8 with pyproject.toml configuration 
    └── [33mflake8[39m *
        ├── [32mmccabe[39m >=0.7.0,<0.8.0 
        ├── [32mpycodestyle[39m >=2.12.0,<2.13.0 
        └── [32mpyflakes[39m >=3.2.0,<3.3.0 
    [36mpyright[39m [39;1m1.1.397[39;22m Command line wrapper for pyright
    ├── [33mnodeenv[39m >=1.6.0
    └── [33mtyping-extensions[39m >=4.1
    [36mpytest[39m [39;1m8.3.5[39;22m pytest: simple powerful testing with Python
    ├── [33mcolorama[39m *
    ├── [33miniconfig[39m *
    ├── [33mpackaging[39m *
    └── [33mpluggy[39m >=1.5,<2
    [36mpytest-cov[39m [39;1m6.0.0[39;22m Pytest plugin for measuring coverage.
    ├── [33mcoverage[39m >=7.5
    └── [33mpytest[39m >=4.6
        ├── [32mcolorama[39m * 
        ├── [32miniconfig[39m * 
        ├── [32mpackaging[39m * 
        └── [32mpluggy[39m >=1.5,<2 
    [36mpytest-flask[39m [39;1m1.3.0[39;22m A set of py.test fixtures to test Flask applications.
    ├── [33mflask[39m *
    │   ├── [32mblinker[39m >=1.9 
    │   ├── [32mclick[39m >=8.1.3 
    │   │   └── [35mcolorama[39m * 
    │   ├── [32mitsdangerous[39m >=2.2 
    │   ├── [32mjinja2[39m >=3.1.2 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   └── [32mwerkzeug[39m >=3.1 
    │       └── [35mmarkupsafe[39m >=2.1.1 (circular dependency aborted here)
    ├── [33mpytest[39m >=5.2
    │   ├── [32mcolorama[39m * 
    │   ├── [32miniconfig[39m * 
    │   ├── [32mpackaging[39m * 
    │   └── [32mpluggy[39m >=1.5,<2 
    └── [33mwerkzeug[39m *
        └── [32mmarkupsafe[39m >=2.1.1 
    [36mpython-lsp-black[39m [39;1m2.0.0[39;22m Black plugin for the Python LSP Server
    ├── [33mblack[39m >=23.11.0
    │   ├── [32mclick[39m >=8.0.0 
    │   │   └── [35mcolorama[39m * 
    │   ├── [32mipython[39m >=7.8.0 
    │   │   ├── [35mcolorama[39m * (circular dependency aborted here)
    │   │   ├── [35mdecorator[39m * 
    │   │   ├── [35mipython-pygments-lexers[39m * 
    │   │   │   └── [34mpygments[39m * 
    │   │   ├── [35mjedi[39m >=0.16 
    │   │   │   └── [34mparso[39m >=0.8.4,<0.9.0 
    │   │   ├── [35mmatplotlib-inline[39m * 
    │   │   │   └── [34mtraitlets[39m * 
    │   │   ├── [35mpexpect[39m >4.3 
    │   │   │   └── [34mptyprocess[39m >=0.5 
    │   │   ├── [35mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   │   └── [34mwcwidth[39m * 
    │   │   ├── [35mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   │   ├── [35mstack-data[39m * 
    │   │   │   ├── [34masttokens[39m >=2.1.0 
    │   │   │   ├── [34mexecuting[39m >=1.2.0 
    │   │   │   └── [34mpure-eval[39m * 
    │   │   └── [35mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    │   ├── [32mmypy-extensions[39m >=0.4.3 
    │   ├── [32mpackaging[39m >=22.0 
    │   ├── [32mpathspec[39m >=0.9.0 
    │   ├── [32mplatformdirs[39m >=2 
    │   └── [32mtokenize-rt[39m >=3.2.0 
    └── [33mpython-lsp-server[39m >=1.4.0
        ├── [32mdocstring-to-markdown[39m * 
        ├── [32mjedi[39m >=0.17.2,<0.20.0 
        │   └── [35mparso[39m >=0.8.4,<0.9.0 
        ├── [32mpluggy[39m >=1.0.0 
        ├── [32mpyflakes[39m >=3.2.0,<3.3.0 
        ├── [32mpython-lsp-jsonrpc[39m >=1.1.0,<2.0.0 
        │   └── [35mujson[39m >=3.0.0 
        ├── [32mrope[39m >=1.11.0 
        │   └── [35mpytoolconfig[39m >=1.2.2 
        │       ├── [34mpackaging[39m >=23.2 
        │       └── [34mplatformdirs[39m >=3.11.0 
        ├── [32mujson[39m >=3.0.0 (circular dependency aborted here)
        ├── [32mwhatthepatch[39m >=1.0.2,<2.0.0 
        └── [32myapf[39m >=0.33.0 
            └── [35mplatformdirs[39m >=3.5.1 (circular dependency aborted here)
    [36mpython-lsp-server[39m [39;1m1.12.2[39;22m Python Language Server for the Language Server Protocol
    ├── [33mdocstring-to-markdown[39m *
    ├── [33mjedi[39m >=0.17.2,<0.20.0
    │   └── [32mparso[39m >=0.8.4,<0.9.0 
    ├── [33mpluggy[39m >=1.0.0
    ├── [33mpyflakes[39m >=3.2.0,<3.3.0
    ├── [33mpython-lsp-jsonrpc[39m >=1.1.0,<2.0.0
    │   └── [32mujson[39m >=3.0.0 
    ├── [33mrope[39m >=1.11.0
    │   └── [32mpytoolconfig[39m >=1.2.2 
    │       ├── [35mpackaging[39m >=23.2 
    │       └── [35mplatformdirs[39m >=3.11.0 
    ├── [33mujson[39m >=3.0.0
    ├── [33mwhatthepatch[39m >=1.0.2,<2.0.0
    └── [33myapf[39m >=0.33.0
        └── [32mplatformdirs[39m >=3.5.1 
    [36mpyvis[39m [39;1m0.3.2[39;22m A Python network graph visualization library
    ├── [33mipython[39m >=5.3.0
    │   ├── [32mcolorama[39m * 
    │   ├── [32mdecorator[39m * 
    │   ├── [32mipython-pygments-lexers[39m * 
    │   │   └── [35mpygments[39m * 
    │   ├── [32mjedi[39m >=0.16 
    │   │   └── [35mparso[39m >=0.8.4,<0.9.0 
    │   ├── [32mmatplotlib-inline[39m * 
    │   │   └── [35mtraitlets[39m * 
    │   ├── [32mpexpect[39m >4.3 
    │   │   └── [35mptyprocess[39m >=0.5 
    │   ├── [32mprompt-toolkit[39m >=3.0.41,<3.1.0 
    │   │   └── [35mwcwidth[39m * 
    │   ├── [32mpygments[39m >=2.4.0 (circular dependency aborted here)
    │   ├── [32mstack-data[39m * 
    │   │   ├── [35masttokens[39m >=2.1.0 
    │   │   ├── [35mexecuting[39m >=1.2.0 
    │   │   └── [35mpure-eval[39m * 
    │   └── [32mtraitlets[39m >=5.13.0 (circular dependency aborted here)
    ├── [33mjinja2[39m >=2.9.6
    │   └── [32mmarkupsafe[39m >=2.0 
    ├── [33mjsonpickle[39m >=1.4.1
    └── [33mnetworkx[39m >=1.11
    [36mpyyaml[39m [39;1m6.0.2[39;22m YAML parser and emitter for Python
    [36mpyzmq[39m [39;1m26.3.0[39;22m Python bindings for 0MQ
    └── [33mcffi[39m *
        └── [32mpycparser[39m * 
    [36mrequests[39m [39;1m2.32.3[39;22m Python HTTP for Humans.
    ├── [33mcertifi[39m >=2017.4.17
    ├── [33mcharset-normalizer[39m >=2,<4
    ├── [33midna[39m >=2.5,<4
    └── [33murllib3[39m >=1.21.1,<3
    [36mrequests-oauthlib[39m [39;1m2.0.0[39;22m OAuthlib authentication support for Requests.
    ├── [33moauthlib[39m >=3.0.0
    └── [33mrequests[39m >=2.0.0
        ├── [32mcertifi[39m >=2017.4.17 
        ├── [32mcharset-normalizer[39m >=2,<4 
        ├── [32midna[39m >=2.5,<4 
        └── [32murllib3[39m >=1.21.1,<3 
    [36mrootpath[39m [39;1m0.2.1[39;22m Python project/package root path detection.
    └── [33msix[39m >=1.11.0
    [36mruff[39m [39;1m0.11.0[39;22m An extremely fast Python linter and code formatter, written in Rust.
    [36mscipy[39m [39;1m1.15.2[39;22m Fundamental algorithms for scientific computing in Python
    └── [33mnumpy[39m >=1.23.5,<2.5
    [36mseaborn[39m [39;1m0.13.2[39;22m Statistical data visualization
    ├── [33mmatplotlib[39m >=3.4,<3.6.1 || >3.6.1
    │   ├── [32mcontourpy[39m >=1.0.1 
    │   │   └── [35mnumpy[39m >=1.23 
    │   ├── [32mcycler[39m >=0.10 
    │   ├── [32mfonttools[39m >=4.22.0 
    │   ├── [32mkiwisolver[39m >=1.3.1 
    │   ├── [32mnumpy[39m >=1.23 (circular dependency aborted here)
    │   ├── [32mpackaging[39m >=20.0 
    │   ├── [32mpillow[39m >=8 
    │   ├── [32mpyparsing[39m >=2.3.1 
    │   └── [32mpython-dateutil[39m >=2.7 
    │       └── [35msix[39m >=1.5 
    ├── [33mnumpy[39m >=1.20,<1.24.0 || >1.24.0
    └── [33mpandas[39m >=1.2
        ├── [32mnumpy[39m >=1.26.0 
        ├── [32mpython-dateutil[39m >=2.8.2 
        │   └── [35msix[39m >=1.5 
        ├── [32mpytz[39m >=2020.1 
        └── [32mtzdata[39m >=2022.7 
    [36msetuptools[39m [39;1m76.1.0[39;22m Easily download, build, install, upgrade, and uninstall Python packages
    [36msphinx[39m [39;1m8.1.3[39;22m Python documentation generator
    ├── [33malabaster[39m >=0.7.14
    ├── [33mbabel[39m >=2.13
    ├── [33mcolorama[39m >=0.4.6
    ├── [33mdocutils[39m >=0.20,<0.22
    ├── [33mimagesize[39m >=1.3
    ├── [33mjinja2[39m >=3.1
    │   └── [32mmarkupsafe[39m >=2.0 
    ├── [33mpackaging[39m >=23.0
    ├── [33mpygments[39m >=2.17
    ├── [33mrequests[39m >=2.30.0
    │   ├── [32mcertifi[39m >=2017.4.17 
    │   ├── [32mcharset-normalizer[39m >=2,<4 
    │   ├── [32midna[39m >=2.5,<4 
    │   └── [32murllib3[39m >=1.21.1,<3 
    ├── [33msnowballstemmer[39m >=2.2
    ├── [33msphinxcontrib-applehelp[39m >=1.0.7
    ├── [33msphinxcontrib-devhelp[39m >=1.0.6
    ├── [33msphinxcontrib-htmlhelp[39m >=2.0.6
    ├── [33msphinxcontrib-jsmath[39m >=1.0.1
    ├── [33msphinxcontrib-qthelp[39m >=1.0.6
    └── [33msphinxcontrib-serializinghtml[39m >=1.1.9
    [36msphinx-autoapi[39m [39;1m3.6.0[39;22m Sphinx API documentation generator
    ├── [33mastroid[39m >=3
    ├── [33mjinja2[39m *
    │   └── [32mmarkupsafe[39m >=2.0 
    ├── [33mpyyaml[39m *
    └── [33msphinx[39m >=7.4.0
        ├── [32malabaster[39m >=0.7.14 
        ├── [32mbabel[39m >=2.13 
        ├── [32mcolorama[39m >=0.4.6 
        ├── [32mdocutils[39m >=0.20,<0.22 
        ├── [32mimagesize[39m >=1.3 
        ├── [32mjinja2[39m >=3.1 
        │   └── [35mmarkupsafe[39m >=2.0 
        ├── [32mpackaging[39m >=23.0 
        ├── [32mpygments[39m >=2.17 
        ├── [32mrequests[39m >=2.30.0 
        │   ├── [35mcertifi[39m >=2017.4.17 
        │   ├── [35mcharset-normalizer[39m >=2,<4 
        │   ├── [35midna[39m >=2.5,<4 
        │   └── [35murllib3[39m >=1.21.1,<3 
        ├── [32msnowballstemmer[39m >=2.2 
        ├── [32msphinxcontrib-applehelp[39m >=1.0.7 
        ├── [32msphinxcontrib-devhelp[39m >=1.0.6 
        ├── [32msphinxcontrib-htmlhelp[39m >=2.0.6 
        ├── [32msphinxcontrib-jsmath[39m >=1.0.1 
        ├── [32msphinxcontrib-qthelp[39m >=1.0.6 
        └── [32msphinxcontrib-serializinghtml[39m >=1.1.9 
    [36msphinx-rtd-theme[39m [39;1m3.0.2[39;22m Read the Docs theme for Sphinx
    ├── [33mdocutils[39m >0.18,<0.22
    ├── [33msphinx[39m >=6,<9
    │   ├── [32malabaster[39m >=0.7.14 
    │   ├── [32mbabel[39m >=2.13 
    │   ├── [32mcolorama[39m >=0.4.6 
    │   ├── [32mdocutils[39m >=0.20,<0.22 
    │   ├── [32mimagesize[39m >=1.3 
    │   ├── [32mjinja2[39m >=3.1 
    │   │   └── [35mmarkupsafe[39m >=2.0 
    │   ├── [32mpackaging[39m >=23.0 
    │   ├── [32mpygments[39m >=2.17 
    │   ├── [32mrequests[39m >=2.30.0 
    │   │   ├── [35mcertifi[39m >=2017.4.17 
    │   │   ├── [35mcharset-normalizer[39m >=2,<4 
    │   │   ├── [35midna[39m >=2.5,<4 
    │   │   └── [35murllib3[39m >=1.21.1,<3 
    │   ├── [32msnowballstemmer[39m >=2.2 
    │   ├── [32msphinxcontrib-applehelp[39m >=1.0.7 
    │   ├── [32msphinxcontrib-devhelp[39m >=1.0.6 
    │   ├── [32msphinxcontrib-htmlhelp[39m >=2.0.6 
    │   ├── [32msphinxcontrib-jsmath[39m >=1.0.1 
    │   ├── [32msphinxcontrib-qthelp[39m >=1.0.6 
    │   └── [32msphinxcontrib-serializinghtml[39m >=1.1.9 
    └── [33msphinxcontrib-jquery[39m >=4,<5
        └── [32msphinx[39m >=1.8 
            ├── [35malabaster[39m >=0.7.14 
            ├── [35mbabel[39m >=2.13 
            ├── [35mcolorama[39m >=0.4.6 
            ├── [35mdocutils[39m >=0.20,<0.22 
            ├── [35mimagesize[39m >=1.3 
            ├── [35mjinja2[39m >=3.1 
            │   └── [34mmarkupsafe[39m >=2.0 
            ├── [35mpackaging[39m >=23.0 
            ├── [35mpygments[39m >=2.17 
            ├── [35mrequests[39m >=2.30.0 
            │   ├── [34mcertifi[39m >=2017.4.17 
            │   ├── [34mcharset-normalizer[39m >=2,<4 
            │   ├── [34midna[39m >=2.5,<4 
            │   └── [34murllib3[39m >=1.21.1,<3 
            ├── [35msnowballstemmer[39m >=2.2 
            ├── [35msphinxcontrib-applehelp[39m >=1.0.7 
            ├── [35msphinxcontrib-devhelp[39m >=1.0.6 
            ├── [35msphinxcontrib-htmlhelp[39m >=2.0.6 
            ├── [35msphinxcontrib-jsmath[39m >=1.0.1 
            ├── [35msphinxcontrib-qthelp[39m >=1.0.6 
            └── [35msphinxcontrib-serializinghtml[39m >=1.1.9 
    [36msqlalchemy[39m [39;1m2.0.39[39;22m Database Abstraction Library
    ├── [33mgreenlet[39m !=0.4.17
    └── [33mtyping-extensions[39m >=4.6.0
    [36msympy[39m [39;1m1.13.1[39;22m Computer algebra system (CAS) in Python
    └── [33mmpmath[39m >=1.1.0,<1.4
    [36mtensorboard[39m [39;1m2.19.0[39;22m TensorBoard lets you watch Tensors Flow
    ├── [33mabsl-py[39m >=0.4
    ├── [33mgrpcio[39m >=1.48.2
    ├── [33mmarkdown[39m >=2.6.8
    ├── [33mnumpy[39m >=1.12.0
    ├── [33mpackaging[39m *
    ├── [33mprotobuf[39m >=3.19.6,<4.24.0 || >4.24.0
    ├── [33msetuptools[39m >=41.0.0
    ├── [33msix[39m >1.9
    ├── [33mtensorboard-data-server[39m >=0.7.0,<0.8.0
    └── [33mwerkzeug[39m >=1.0.1
        └── [32mmarkupsafe[39m >=2.1.1 
    [36mtensorflow[39m [39;1m2.19.0[39;22m TensorFlow is an open source machine learning framework for everyone.
    ├── [33mabsl-py[39m >=1.0.0
    ├── [33mastunparse[39m >=1.6.0
    │   ├── [32msix[39m >=1.6.1,<2.0 
    │   └── [32mwheel[39m >=0.23.0,<1.0 
    ├── [33mflatbuffers[39m >=24.3.25
    ├── [33mgast[39m >=0.2.1,<0.5.0 || >0.5.0,<0.5.1 || >0.5.1,<0.5.2 || >0.5.2
    ├── [33mgoogle-pasta[39m >=0.1.1
    │   └── [32msix[39m * 
    ├── [33mgrpcio[39m >=1.24.3,<2.0
    ├── [33mh5py[39m >=3.11.0
    │   └── [32mnumpy[39m >=1.19.3 
    ├── [33mkeras[39m >=3.5.0
    │   ├── [32mabsl-py[39m * 
    │   ├── [32mh5py[39m * 
    │   │   └── [35mnumpy[39m >=1.19.3 
    │   ├── [32mml-dtypes[39m * 
    │   │   ├── [35mnumpy[39m >=2.1.0 (circular dependency aborted here)
    │   │   └── [35mnumpy[39m >=1.26.0 (circular dependency aborted here)
    │   ├── [32mnamex[39m * 
    │   ├── [32mnumpy[39m * (circular dependency aborted here)
    │   ├── [32moptree[39m * 
    │   │   └── [35mtyping-extensions[39m >=4.5.0 
    │   ├── [32mpackaging[39m * 
    │   └── [32mrich[39m * 
    │       ├── [35mmarkdown-it-py[39m >=2.2.0 
    │       │   └── [34mmdurl[39m >=0.1,<1.0 
    │       └── [35mpygments[39m >=2.13.0,<3.0.0 
    ├── [33mlibclang[39m >=13.0.0
    ├── [33mml-dtypes[39m >=0.5.1,<1.0.0
    │   ├── [32mnumpy[39m >=2.1.0 
    │   └── [32mnumpy[39m >=1.26.0 (circular dependency aborted here)
    ├── [33mnumpy[39m >=1.26.0,<2.2.0
    ├── [33mnvidia-cublas-cu12[39m 12.5.3.2
    ├── [33mnvidia-cuda-cupti-cu12[39m 12.5.82
    ├── [33mnvidia-cuda-nvcc-cu12[39m 12.5.82
    ├── [33mnvidia-cuda-nvrtc-cu12[39m 12.5.82
    ├── [33mnvidia-cuda-runtime-cu12[39m 12.5.82
    ├── [33mnvidia-cudnn-cu12[39m 9.3.0.75
    │   └── [32mnvidia-cublas-cu12[39m * 
    ├── [33mnvidia-cufft-cu12[39m 11.2.3.61
    │   └── [32mnvidia-nvjitlink-cu12[39m * 
    ├── [33mnvidia-curand-cu12[39m 10.3.6.82
    ├── [33mnvidia-cusolver-cu12[39m 11.6.3.83
    │   ├── [32mnvidia-cublas-cu12[39m * 
    │   ├── [32mnvidia-cusparse-cu12[39m * 
    │   │   └── [35mnvidia-nvjitlink-cu12[39m * 
    │   └── [32mnvidia-nvjitlink-cu12[39m * (circular dependency aborted here)
    ├── [33mnvidia-cusparse-cu12[39m 12.5.1.3
    │   └── [32mnvidia-nvjitlink-cu12[39m * 
    ├── [33mnvidia-nccl-cu12[39m 2.23.4
    ├── [33mnvidia-nvjitlink-cu12[39m 12.5.82
    ├── [33mopt-einsum[39m >=2.3.2
    ├── [33mpackaging[39m *
    ├── [33mprotobuf[39m >=3.20.3,<4.21.0 || >4.21.0,<4.21.1 || >4.21.1,<4.21.2 || >4.21.2,<4.21.3 || >4.21.3,<4.21.4 || >4.21.4,<4.21.5 || >4.21.5,<6.0.0dev
    ├── [33mrequests[39m >=2.21.0,<3
    │   ├── [32mcertifi[39m >=2017.4.17 
    │   ├── [32mcharset-normalizer[39m >=2,<4 
    │   ├── [32midna[39m >=2.5,<4 
    │   └── [32murllib3[39m >=1.21.1,<3 
    ├── [33msetuptools[39m *
    ├── [33msix[39m >=1.12.0
    ├── [33mtensorboard[39m >=2.19.0,<2.20.0
    │   ├── [32mabsl-py[39m >=0.4 
    │   ├── [32mgrpcio[39m >=1.48.2 
    │   ├── [32mmarkdown[39m >=2.6.8 
    │   ├── [32mnumpy[39m >=1.12.0 
    │   ├── [32mpackaging[39m * 
    │   ├── [32mprotobuf[39m >=3.19.6,<4.24.0 || >4.24.0 
    │   ├── [32msetuptools[39m >=41.0.0 
    │   ├── [32msix[39m >1.9 
    │   ├── [32mtensorboard-data-server[39m >=0.7.0,<0.8.0 
    │   └── [32mwerkzeug[39m >=1.0.1 
    │       └── [35mmarkupsafe[39m >=2.1.1 
    ├── [33mtermcolor[39m >=1.1.0
    ├── [33mtyping-extensions[39m >=3.6.6
    └── [33mwrapt[39m >=1.11.0
    [36mtensorflow-datasets[39m [39;1m4.9.8[39;22m tensorflow/datasets is a library of datasets ready to use with TensorFlow.
    ├── [33mabsl-py[39m *
    ├── [33marray-record[39m >=0.5.0
    │   ├── [32mabsl-py[39m * 
    │   └── [32metils[39m * 
    │       ├── [35mabsl-py[39m * (circular dependency aborted here)
    │       ├── [35meinops[39m * 
    │       ├── [35mfsspec[39m * 
    │       ├── [35mimportlib-resources[39m * 
    │       ├── [35mnumpy[39m * 
    │       ├── [35mtqdm[39m * 
    │       │   └── [34mcolorama[39m * 
    │       ├── [35mtyping-extensions[39m * 
    │       ├── [35mtyping-extensions[39m * (circular dependency aborted here)
    │       ├── [35mtyping-extensions[39m * (circular dependency aborted here)
    │       └── [35mzipp[39m * 
    ├── [33mdm-tree[39m *
    │   ├── [32mabsl-py[39m >=0.6.1 
    │   ├── [32mattrs[39m >=18.2.0 
    │   ├── [32mnumpy[39m >=2.1.0 
    │   ├── [32mnumpy[39m >=1.26.0 (circular dependency aborted here)
    │   └── [32mwrapt[39m >=1.11.2 
    ├── [33metils[39m >=1.9.1
    │   ├── [32mabsl-py[39m * 
    │   ├── [32meinops[39m * 
    │   ├── [32mfsspec[39m * 
    │   ├── [32mimportlib-resources[39m * 
    │   ├── [32mnumpy[39m * 
    │   ├── [32mtqdm[39m * 
    │   │   └── [35mcolorama[39m * 
    │   ├── [32mtyping-extensions[39m * 
    │   ├── [32mtyping-extensions[39m * (circular dependency aborted here)
    │   ├── [32mtyping-extensions[39m * (circular dependency aborted here)
    │   └── [32mzipp[39m * 
    ├── [33mimmutabledict[39m *
    ├── [33mnumpy[39m *
    ├── [33mpromise[39m *
    │   └── [32msix[39m * 
    ├── [33mprotobuf[39m >=3.20
    ├── [33mpsutil[39m *
    ├── [33mpyarrow[39m *
    ├── [33mrequests[39m >=2.19.0
    │   ├── [32mcertifi[39m >=2017.4.17 
    │   ├── [32mcharset-normalizer[39m >=2,<4 
    │   ├── [32midna[39m >=2.5,<4 
    │   └── [32murllib3[39m >=1.21.1,<3 
    ├── [33msimple-parsing[39m *
    │   ├── [32mdocstring-parser[39m >=0.15,<1.0 
    │   └── [32mtyping-extensions[39m >=4.5.0 
    ├── [33mtensorflow-metadata[39m *
    │   ├── [32mabsl-py[39m >=0.9,<3.0.0 
    │   ├── [32mgoogleapis-common-protos[39m >=1.56.4,<2 
    │   │   └── [35mprotobuf[39m >=3.20.2,<4.21.1 || >4.21.1,<4.21.2 || >4.21.2,<4.21.3 || >4.21.3,<4.21.4 || >4.21.4,<4.21.5 || >4.21.5,<7.0.0 
    │   └── [32mprotobuf[39m >=4.25.2,<6.0.0dev (circular dependency aborted here)
    ├── [33mtermcolor[39m *
    ├── [33mtoml[39m *
    ├── [33mtqdm[39m *
    │   └── [32mcolorama[39m * 
    └── [33mwrapt[39m *
    [36mtensorflow-hub[39m [39;1m0.16.1[39;22m TensorFlow Hub is a library to foster the publication, discovery, and consumption of reusable parts of machine learning models.
    ├── [33mnumpy[39m >=1.12.0
    ├── [33mprotobuf[39m >=3.19.6
    └── [33mtf-keras[39m >=2.14.1
        └── [32mtensorflow[39m >=2.19,<2.20 
            ├── [35mabsl-py[39m >=1.0.0 
            ├── [35mastunparse[39m >=1.6.0 
            │   ├── [34msix[39m >=1.6.1,<2.0 
            │   └── [34mwheel[39m >=0.23.0,<1.0 
            ├── [35mflatbuffers[39m >=24.3.25 
            ├── [35mgast[39m >=0.2.1,<0.5.0 || >0.5.0,<0.5.1 || >0.5.1,<0.5.2 || >0.5.2 
            ├── [35mgoogle-pasta[39m >=0.1.1 
            │   └── [34msix[39m * (circular dependency aborted here)
            ├── [35mgrpcio[39m >=1.24.3,<2.0 
            ├── [35mh5py[39m >=3.11.0 
            │   └── [34mnumpy[39m >=1.19.3 
            ├── [35mkeras[39m >=3.5.0 
            │   ├── [34mabsl-py[39m * (circular dependency aborted here)
            │   ├── [34mh5py[39m * (circular dependency aborted here)
            │   ├── [34mml-dtypes[39m * 
            │   │   ├── [36mnumpy[39m >=2.1.0 (circular dependency aborted here)
            │   │   └── [36mnumpy[39m >=1.26.0 (circular dependency aborted here)
            │   ├── [34mnamex[39m * 
            │   ├── [34mnumpy[39m * (circular dependency aborted here)
            │   ├── [34moptree[39m * 
            │   │   └── [36mtyping-extensions[39m >=4.5.0 
            │   ├── [34mpackaging[39m * 
            │   └── [34mrich[39m * 
            │       ├── [36mmarkdown-it-py[39m >=2.2.0 
            │       │   └── [33mmdurl[39m >=0.1,<1.0 
            │       └── [36mpygments[39m >=2.13.0,<3.0.0 
            ├── [35mlibclang[39m >=13.0.0 
            ├── [35mml-dtypes[39m >=0.5.1,<1.0.0 (circular dependency aborted here)
            ├── [35mnumpy[39m >=1.26.0,<2.2.0 (circular dependency aborted here)
            ├── [35mnvidia-cublas-cu12[39m 12.5.3.2 
            ├── [35mnvidia-cuda-cupti-cu12[39m 12.5.82 
            ├── [35mnvidia-cuda-nvcc-cu12[39m 12.5.82 
            ├── [35mnvidia-cuda-nvrtc-cu12[39m 12.5.82 
            ├── [35mnvidia-cuda-runtime-cu12[39m 12.5.82 
            ├── [35mnvidia-cudnn-cu12[39m 9.3.0.75 
            │   └── [34mnvidia-cublas-cu12[39m * (circular dependency aborted here)
            ├── [35mnvidia-cufft-cu12[39m 11.2.3.61 
            │   └── [34mnvidia-nvjitlink-cu12[39m * 
            ├── [35mnvidia-curand-cu12[39m 10.3.6.82 
            ├── [35mnvidia-cusolver-cu12[39m 11.6.3.83 
            │   ├── [34mnvidia-cublas-cu12[39m * (circular dependency aborted here)
            │   ├── [34mnvidia-cusparse-cu12[39m * 
            │   │   └── [36mnvidia-nvjitlink-cu12[39m * (circular dependency aborted here)
            │   └── [34mnvidia-nvjitlink-cu12[39m * (circular dependency aborted here)
            ├── [35mnvidia-cusparse-cu12[39m 12.5.1.3 (circular dependency aborted here)
            ├── [35mnvidia-nccl-cu12[39m 2.23.4 
            ├── [35mnvidia-nvjitlink-cu12[39m 12.5.82 (circular dependency aborted here)
            ├── [35mopt-einsum[39m >=2.3.2 
            ├── [35mpackaging[39m * (circular dependency aborted here)
            ├── [35mprotobuf[39m >=3.20.3,<4.21.0 || >4.21.0,<4.21.1 || >4.21.1,<4.21.2 || >4.21.2,<4.21.3 || >4.21.3,<4.21.4 || >4.21.4,<4.21.5 || >4.21.5,<6.0.0dev 
            ├── [35mrequests[39m >=2.21.0,<3 
            │   ├── [34mcertifi[39m >=2017.4.17 
            │   ├── [34mcharset-normalizer[39m >=2,<4 
            │   ├── [34midna[39m >=2.5,<4 
            │   └── [34murllib3[39m >=1.21.1,<3 
            ├── [35msetuptools[39m * 
            ├── [35msix[39m >=1.12.0 (circular dependency aborted here)
            ├── [35mtensorboard[39m >=2.19.0,<2.20.0 
            │   ├── [34mabsl-py[39m >=0.4 (circular dependency aborted here)
            │   ├── [34mgrpcio[39m >=1.48.2 (circular dependency aborted here)
            │   ├── [34mmarkdown[39m >=2.6.8 
            │   ├── [34mnumpy[39m >=1.12.0 (circular dependency aborted here)
            │   ├── [34mpackaging[39m * (circular dependency aborted here)
            │   ├── [34mprotobuf[39m >=3.19.6,<4.24.0 || >4.24.0 (circular dependency aborted here)
            │   ├── [34msetuptools[39m >=41.0.0 (circular dependency aborted here)
            │   ├── [34msix[39m >1.9 (circular dependency aborted here)
            │   ├── [34mtensorboard-data-server[39m >=0.7.0,<0.8.0 
            │   └── [34mwerkzeug[39m >=1.0.1 
            │       └── [36mmarkupsafe[39m >=2.1.1 
            ├── [35mtermcolor[39m >=1.1.0 
            ├── [35mtyping-extensions[39m >=3.6.6 (circular dependency aborted here)
            └── [35mwrapt[39m >=1.11.0 
    [36mtoml[39m [39;1m0.10.2[39;22m Python Library for Tom's Obvious, Minimal Language
    [36mtqdm[39m [39;1m4.67.1[39;22m Fast, Extensible Progress Meter
    └── [33mcolorama[39m *
    [36mtwine[39m [39;1m6.1.0[39;22m Collection of utilities for publishing packages on PyPI
    ├── [33mid[39m *
    │   └── [32mrequests[39m * 
    │       ├── [35mcertifi[39m >=2017.4.17 
    │       ├── [35mcharset-normalizer[39m >=2,<4 
    │       ├── [35midna[39m >=2.5,<4 
    │       └── [35murllib3[39m >=1.21.1,<3 
    ├── [33mkeyring[39m >=15.1
    │   ├── [32mjaraco-classes[39m * 
    │   │   └── [35mmore-itertools[39m * 
    │   ├── [32mjaraco-context[39m * 
    │   ├── [32mjaraco-functools[39m * 
    │   │   └── [35mmore-itertools[39m * (circular dependency aborted here)
    │   ├── [32mjeepney[39m >=0.4.2 
    │   ├── [32mpywin32-ctypes[39m >=0.2.0 
    │   └── [32msecretstorage[39m >=3.2 
    │       ├── [35mcryptography[39m >=2.0 
    │       │   └── [34mcffi[39m >=1.12 
    │       │       └── [36mpycparser[39m * 
    │       └── [35mjeepney[39m >=0.6 (circular dependency aborted here)
    ├── [33mpackaging[39m >=24.0
    ├── [33mreadme-renderer[39m >=35.0
    │   ├── [32mdocutils[39m >=0.21.2 
    │   ├── [32mnh3[39m >=0.2.14 
    │   └── [32mpygments[39m >=2.5.1 
    ├── [33mrequests[39m >=2.20
    │   ├── [32mcertifi[39m >=2017.4.17 
    │   ├── [32mcharset-normalizer[39m >=2,<4 
    │   ├── [32midna[39m >=2.5,<4 
    │   └── [32murllib3[39m >=1.21.1,<3 
    ├── [33mrequests-toolbelt[39m >=0.8.0,<0.9.0 || >0.9.0
    │   └── [32mrequests[39m >=2.0.1,<3.0.0 
    │       ├── [35mcertifi[39m >=2017.4.17 
    │       ├── [35mcharset-normalizer[39m >=2,<4 
    │       ├── [35midna[39m >=2.5,<4 
    │       └── [35murllib3[39m >=1.21.1,<3 
    ├── [33mrfc3986[39m >=1.4.0
    ├── [33mrich[39m >=12.0.0
    │   ├── [32mmarkdown-it-py[39m >=2.2.0 
    │   │   └── [35mmdurl[39m >=0.1,<1.0 
    │   └── [32mpygments[39m >=2.13.0,<3.0.0 
    └── [33murllib3[39m >=1.26.0
    [36munittest2[39m [39;1m1.1.0[39;22m The new features in unittest backported to Python 2.4+.
    ├── [33margparse[39m *
    ├── [33msix[39m >=1.4
    └── [33mtraceback2[39m *
        └── [32mlinecache2[39m * 
    [36murllib3[39m [39;1m2.3.0[39;22m HTTP library with thread-safe connection pooling, file post, and more.
    [36mwheel[39m [39;1m0.45.1[39;22m A built-package format for Python
    [36myapf[39m [39;1m0.43.0[39;22m A formatter for Python code
    └── [33mplatformdirs[39m >=3.5.1



```python

```
