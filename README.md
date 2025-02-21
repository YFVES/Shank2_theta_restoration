# Shank2_theta_restoration
github repository for article 'Restoring interbrain prefrontal theta synchronization reverses social deficits'

# Installation


Matlab installation time : ~ 20 min
Python environment installationg time: ~ 5min
Repository installation time: ~ 10 min 



# RawData folder


The repository includes two sample raw data located in the Sample_RawData folder. 
1) Behavior_session : Raw data from a experimental session with behavioral and neural data recording. 

2) Optogenetics_session: Raw data from an optogenetics session with behavioral and neural data recording. 


#Matlab

This document describes the functions of the MATLAB (2021a) codes used in the article: Restoring interbrain prefrontal theta synchronization reverses social deficits. 


Download the entire folder, add it to the directory (with all the subfolders) in MATLAB. 
Sample Data are included within the different parts of analysis. 


	MClust_Spike-Soring_Toolbox_master
MClust is used to cut and cluster single neuron data. 


	MatlabImportExport_v6.0.0
Open Resource library of codes that includes codes to import Cheetah collected data to MATLAB 


	shadedErrorBar-master 
Open Resource library that draws a line plot with shaded error indicating standard error of the mean 


# 1.	Preprocessing 


Codes in this code are used to pre-process the neural data collected from each experimental session. 


Behavior_only_sessions (codes that are used for behavior only sessions, Fig 1-4, Extended Fig 1-4) 


	Shank2_struct_[year 2020, 2021, 2023]
Code outputs a K struct that includes mouse ID, genotype, pair type, timestamps, spike data)


	Shank2_struct_[year 2020, 2021, 2023]_behaviortimestamps 
Code appends to the K struct social, non-social, immobile (rest) behavior time stamps 


	Shank2_LFPmat_struct_save
Code outputs a .mat file that includes rawLFP data, Timestamps, ADMaxValue, InputRange, and Sampling Frequency


OptoStim_sessions (codes that are used for optogenetics sessions, Fig 5, Extended Fig 5-6) 

	Shank2_struct_optostim
Code outputs a K struct that includes mouse ID, genotype, pair type, timestamps, spike data)


	Shank2_struct_optostim_behaviortimestamps 
Code appends to the K struct social, non-social, immobile (rest) behavior time stamps 


	Shank2_optostim_LFP_struct
Code outputs a .mat file that includes rawLFP data, Timestamps, ADMaxValue, InputRange, and Sampling Frequency
Supporting


	Shank2_socialbehavior_boutcreation_mouse1
Code that extracts social behavior data to be included in the K struct


	Shank2_nonsocialbehavior_boutcreation_[year 2020, 2021]
Code that extracts non-social behavior data to be included in the K struct


	Shank2_immobile_[year 2020, 2021]
Code that extracts immobile (Rest)data to be included in the K struct
Run time : depending on the number of sessions 5-10 minutes, for one session about 1~2 minutes 


# 2.	Behavior (Fig 1, Extended Fig 1, 2)


	Xml2struct
This code is a function code imports behavior data annotated using Adobe Premiere Pro. It reads .xml files. 


	Xmlcode_7behaviors 
This code imports all the social behavioral data from direct interaction sessions. 


	Xmlcode_nonsocial
This code imports all the non-social and rest behavioral data from the direct interaction sessions. 


	Shank2_solitary_xml
This code imports all the non-social and rest behavioral data from the solitary recording sessions. 


	Shank2_socialgaze_total
This code imports gaze data from all the direct interaction sessions (csv output of DeepLabCut) and quantifies it. 


	Shank2_behavior_total
This code imports all behavioral data from all the direct interaction sessions


Sample Data Folders : GazeData (sample csv outputs from DeepLabCut) BehaviorData (sample xml outputs from Adobe Premiere Pro) 
Run time : depending on the number of sessions 5-10 minutes, for one session about 1~2 minutes 


# 3.	InterbrainSynchrony_PearsonCorrelationCoefficient 


*Pearson Correlation Coeffcient is referred to as PCC. 
Behavior (codes that are used for behavior only sessions, Fig 2-4, Extended Fig 1-4) 


	Shank2_wavelet_socialbehavior_pcc_[year 2020, 2021, 2023]
Code uses wavelet function to calculate PCC values for specific behaviors, social, non-social, and rest  


	Shank2_velocity_wavelet _pcc
Code uses wavelet function to calculate PCC values for velocity control epochs 


	Shank2_LFP_PCC
Code that calculates PCC values for entire LFP recording to make within/between comparisons, direct interaction sessions/solitary recording sessions 


	Shank2_LFP_pearson_coeff_first_last2min 
Code that calculates the PCC values for the 1st and last 2 minutes of direct interaction session (used to draw Fig. 3d-f)


	Shank2_LFP_pearson_coeff_2min_timeplot
Code that calculates the PCC values for 2 minute window over time and plots it with behavioral and gaze data (used to draw Fig. 3c) 


	Shank2_LFP_pearson_coeff_linearregression
Code that computes simple linear regression between time and PCC, time and behavior and time and gaze (used to draw Fig. 3c)


	calculatePCC
function that calculates PCC values for specific windows 
Gaze (codes that are used for behavior only sessions, Fig 3, Extended Fig 2) 


	Shank2_socialgaze_wavelet_PCC
Code uses wavelet function to calculate PCC values during social gaze epochs 


	Shank2_socialgaze_excl_socialbehavior_wavelet_PCC
Code uses wavelet function to calculate PCC values during social gaze epochs excluding epochs of social behavior 


	Shank2_headangle_wavelet_PCC
Code uses wavelet function to calculate PCC values for headangle control epochs 


	excludeInteractionTimes
function that excludes social behavior times from social gaze times 


	calculateWaveletCorrelation
function that calculates PCC values for specific epochs for different frequency bands 


Sample Data Folder : NeuralData (contains K struct files and LFP struct files in .mat formats), VelocityData (sample csv outputs from DeepLabCut), HeandAngleData (sample csv outputs from DeepLabCut)
Run time : depending on the number of sessions 5-10 minutes, for one session about 1~2 minutes 


# 4.	NeuronProperties (Extended Data Fig. 3)


	Shank2_spike_markEI 
This code is categorizes whether a neuron is excitatory or inhibitory based on is half-width and spike to valley ratio 


	Shank2_ISI_sessiontype 
This code calculates the inter-spike-interval for neurons based on session types (baseline, direct interaction, solitary) 


	Shank2_ISI_sessiontype_avereage
This code calculates the average inter-spike-interval for neurons based on session types (baseline, direct interaction, solitary) 


	Shank2_ISI_burstanalysis 
This code calculates the proportion of burst spikes for each neuron for each trial type 


	Shank2_ISI_behaviortype  
This code calculates the inter-spike-interval for neurons based on behaviors (social, non-social, rest) during direct interaction sessions 


	Shank2_direct_interaction_firingrate   
This code calculates average firing rate for all neurons during the direct interaction /solitary recording sessions 


	Shank2_baseline_firingrate   
This code calculates average firing rate for all neurons during baseline.  


	Shank2_averageSesssionFRs_average   
This code calculates average firing rate for all neurons during baseline, direct interaction session, and solitary recording session.   


Run time : depending on the number of sessions 5-10 minutes, for one session about 1~2 minutes 



# 5.	auROC (Fig 4, Extended Data Fig. 6)


	self/otherbehavior_socialnonsocial
This code runs generates time bins from self/other behavior respectively and uses them to calculate firing rates. Then, the code performs auROC(area under ROC) analysis.


	SDFgen_self/other
This code generates SDF for all time bins.


	drawing_SDF
This code draws the average value and s.e.m. of SDF for social neurons in social behavior onsets.


Sample Data Folder: contains .mat files that can be run through self/otherbehavior_socialnonsocial code to isolate social behavior encoding neurons 
Run time : 30~40 minutes depending on the number of neurons 


# 6.	PhaseLock (Fig. 4, Extended Data Fig. 4) 


	PhaseLock
This code uses spike data and LFP data to calculate Phase to Wave coupling for solitary recording and direct interaction sessions. 


	PhaseLock_optostim
This code uses spike data and LFP data to calculate Phase to Wave coupling for optostimulation sessions 


	circularStat
This function code conducts statistical testing that determines if a neuron is phase locked to wave 
Wavelet folder contains all the supporting function codes to run PhaseLock analysis 


Run time : depending on the number of sessions 5-10 minutes, for one session about 1~2 minutes 


# 7.	Optostimulation (Fig. 5, Extended Data Fig. 5) 


*Pearson Correlation Coeffcient is referred to as PCC. 
Behavior 


	Xmlcode_optostim
This code imports all the social, non-social, immobile (rest) behavioral data from direct interaction sessions. 


	Shank2_behavior_total_optostim_threewindows 
Code quantifies social behavioral data in three 5 minutes windows 


	Shank2_behavior_total_optostim_nonsocial 
Code quantifies non-social and immobile (rest) behavioral data in three 1 minute windows 


	Shank2_behavior_total_optostim 
Code quantifies social behavioral data in three 1 minute windows 


InterbrainSynchrony 
	Shank2_optostim_LFP_thetapower_threeepoch 
Code quantifies theta power in each of the sync, desync, no stim epochs 


	Shank2_optostim_LFP_PCC
Code calculates the PCC value for each of the sync, desync, no stim epochs. 



Sample Data Folder: OptoStim_NeuralData (contains K struct files and LFP struct files in .mat formats), Optostim_BehaviorData (sample xml outputs from Adobe Premiere Pro)


Run time : depending on the number of sessions 5-10 minutes, for one session about 1~2 minutes 


# Python


This document describes the functions of the python (3.10) codes used in the article: Restoring interbrain prefrontal theta synchronization reverses social deficits. 
Download the entire folder, install all the used libraries using pip(we recommend using anaconda virtual environment), and run the code. 
Sample Data are included within the analysis. 


# 1.	Regress out analysis(Fig 4)


Codes in this code are used to perform LFP-social neuron regress out analysis


	regressout
Code generates SDF from social/nonsocial/random neurons and regress them out from theta power LFP and calculate the synchrony between LFPs.  
Run time : depending on the number of social neurons and sessions, usually 3~5 minutes per session.







