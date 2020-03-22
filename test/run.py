from pyfmi import load_fmu

import numpy as np

eplus=load_fmu('building_fmu.fmu')

eplus.initialize(tStart=86400*200,tStop=86400*201)

modelica = load_fmu('WaterSideSystem_Plant_ChillerPlantSystem_withInput.fmu')

modelica.set_log_level(7)

options=modelica.simulate_options()

options['initialize'] = True

start_time = 86400*200 

eplus.do_step(current_t=start_time, step_size=60)

for i in range(720):       

    load = eplus.get('m')[0]*(eplus.get('T_out')[0]-eplus.get('T_in')[0])*4200
    
    print load
    
    print eplus.get('m')[0]
        
    u_list = []

    u_trajectory = start_time

    u_list.append('CooLoa')
                        
    u_trajectory = np.vstack((u_trajectory, load))
                        
    input_object = (u_list, np.transpose(u_trajectory))  
 
    
    res = modelica.simulate(start_time=start_time, 
                              final_time=start_time+60, 
                              options=options, 
                              input=input_object)
                              
    options['initialize'] = False    
    
    eplus.set('CHW_temp', res['bui.TCHWLeaPri'][-1]-273.15) 
    
    start_time = start_time +60
    
    eplus.do_step(current_t=start_time, step_size=60)
    

print eplus.get('m')