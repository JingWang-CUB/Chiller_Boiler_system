# -*- coding: utf-8 -*-
"""
This module compiles the defined test case model into an FMU.

The following libraries must be on the MODELICAPATH:

- Modelica IBPSA
- Modelica Buildings
- Modelica BuildingControlEmulator

"""


from pyfmi import load_fmu
from pymodelica import compile_fmu

# DEFINE MODEL
# ------------
#mopath='model/test.mo'
#modelpath='Mixingbox'

modelpath='WaterSideSystem.Plant.BoilerPlantSystem_withInput'
mopath=['model/WaterSideSystem']
# modelpath='Modelica.StateGraph.Examples.FirstExample_Variant3'
# mopath=[]
# ------------

# COMPILE FMU
# -----------
fmu_path = compile_fmu(modelpath, mopath,compiler_log_level='error',target='me',version='2.0',jvm_args='-Xmx5g')
# -----------

# TEST FMU
# -----------
#fmu = load_fmu(modelpath.replace('.','_')+'.fmu')
# fmu = load_fmu('wrapped.fmu')
# # -----------
# print fmu.simulate_options()

   