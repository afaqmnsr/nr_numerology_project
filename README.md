# 5G Numerology Project - DAT610

## Project Overview
Study of 5G NR **numerology (SCS)**, **mobility (TDL-A)**, and **HARQ** affect **BLER**, **throughput**, and **latency** using **MATLAB scripts** 


**Group**: Afaq, Said, Sirina  
**Tech**: Numerology (Sub-carrier spacing)  
**Metrics**: Latency, Throughput, BLER  
**Environment**: SCS: 15/30/60 kHz; SNR –5…30 dB; Channels: AWGN & TDL-A; Mobility: 0 & 120 km/h; HARQ: off & on

## Project Structure
- `run_awgn_baseline.m` - AWGN baseline study (Afaq) **DONE**
- `run_tdlA_mobility.m` - TDL-A + mobility study (Said) **DONE**
- `run_harq_study.m` - HARQ study (Sirina) **DONE**
- `common_config.m` - Shared parameters **DONE**
- `utils/` - Helper functions **DONE**

## Progress Status

### Afaq - AWGN Baseline (COMPLETED)
**Scenarios**: SCS = 15/30/60; AWGN; SNR –5:2:30 dB; HARQ off; AMC + error bars

**Deliverables**:
- Fig A1: BLER vs SNR (AWGN, 15/30/60) 
- Fig A2: Throughput vs SNR with error bars (AWGN, AMC)
- Fig A3: Latency vs SNR (1.00/0.50/0.25 ms slots)

**Run**: `run('run_awgn_baseline.m')`

### Said - TDL-A + Mobility (COMPLETED)
**Scenarios**: SCS = 15/30/60; TDL-A; SNR –5:2:30 dB; mobility 0 and 120 km/h; HARQ off

**Expected Deliverables**:
- Fig S1: BLER vs SNR (TDL-A, 0 km/h) for 15/30/60
- Fig S2: BLER vs SNR (TDL-A, 120 km/h) for 15/30/60
- Fig S3: Throughput vs SNR (TDL-A, 0 vs 120 km/h) at one SCS

**Run**: `run_tdlA_mobility.m` 

### Sirina - HARQ Study (COMPLETED)
**Scenarios**: Pick SCS = 30 kHz; TDL-A; SNR –5:2:30 dB; compare HARQ off vs on

**Deliverables**:
- Fig R1: Latency vs SNR (HARQ off/on)
- Fig R2: Throughput vs SNR (HARQ off/on)
- Fig R3: Latency CDF at mid SNR (12 dB), off vs on

**Run**: `run_harq_study.m` 

## Next Steps
1. Afaq: COMPLETED - Baseline script run, results generated
2. Said: Implement TDL-A + mobility simulation
3. Sirina: COMPLETED - HARQ study
4. FIRST DRAFT DONE - Compile final report with all figures
