within WaterSideSystem.Plant;
model ChillerPlantSystem_FMU
  "The model is designed to simulate the Lejeune Plant(simulation period:1year)"
  import ChillerPlantSystem = WaterSideSystem.Plant;
  extends Modelica.Icons.Example;
  package MediumCHW = Buildings.Media.Water
    "Medium model";
  package MediumCW = Buildings.Media.Water "Medium model";
  parameter Real tWai = 900 "Waiting time";
  parameter Modelica.SIunits.TemperatureDifference dT = 0.5
    "Temperature difference for stage control";
  parameter Modelica.SIunits.Power PChi_nominal = 1442/COP_nominal
    "Nominal chiller power (at y=1)";
  parameter Modelica.SIunits.Power PTow_nominal = 1E3
    "Nominal cooling tower power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCHW_nominal = 5.56
    "Temperature difference at chilled water side";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal = 5.18
    "Temperature difference at condenser water wide";
  parameter Modelica.SIunits.Pressure dPCHW_nominal = 210729
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.Pressure dPCW_nominal = 92661
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.Pressure dPTow_nominal = 191300
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.Temperature TCHW_nominal = 273.15 + 5.56
    "Temperature at chilled water side";
  parameter Modelica.SIunits.Temperature TCW_nominal = 273.15 + 23.89
    "Temperature at condenser water wide";
  parameter Modelica.SIunits.TemperatureDifference dTApp_nominal=4.44
    "Nominal approach temperature";
  parameter Real COP_nominal = 6.61 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = 1442/4.2/5.56
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = mCHW_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water wide";

  parameter Real Motor_eta = 0.87 "Motor efficiency";
  parameter Real Hydra_eta = 1 "Hydraulic efficiency";
  parameter Modelica.SIunits.Pressure dP_nominal=478250
    "Nominal pressure drop for the secondary chilled water pump ";
  parameter Real v_flow_ratio[:] = {0.4,0.6,0.8,1,1.2};
  parameter Real v_flow_rate[:] = {0.4*mCHW_flow_nominal/996,0.6*mCHW_flow_nominal/996,0.8*mCHW_flow_nominal/996,mCHW_flow_nominal/996,1.2*mCHW_flow_nominal/996};
  parameter Real pressure[:] = {1.28*dP_nominal,1.2*dP_nominal,1.1*dP_nominal,dP_nominal,0.75*dP_nominal};

  parameter Real Motor_eta_Sec[:] = {0.6,0.76,0.87,0.86,0.74}
    "Motor efficiency";
  parameter Real Hydra_eta_Sec[:] = {1,1,1,1,1} "Hydraulic efficiency";
  parameter Modelica.SIunits.Pressure dPByp_nominal=100
    "Pressure difference between the outlet and inlet of the modules ";
  parameter Real vTow_flow_rate[:]={1} "Volume flow rate rate";
  parameter Real eta[:]={1} "Fan efficiency";
  parameter Modelica.SIunits.Temperature TWetBul_nominal=273.15+19.45
    "Nominal wet bulb temperature";
  Chiller.MultiChillerSystem mulChiSys(
    redeclare package MediumCHW = MediumCHW,
    redeclare package MediumCW = MediumCW,
    dPCHW_nominal=dPCHW_nominal,
    dPCW_nominal=dPCW_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    TCW_start=273.15 + 23.89,
    TCHW_start=273.15 + 5.56,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD())
    annotation (Placement(transformation(extent={{-96,-28},{-58,10}})));
  BaseClasses.Components.Building        bui(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=3*mCHW_flow_nominal,
    TBuiSetPoi=273.15 + 11.12,
    dP_nominal=dP_nominal*0.5,
    GaiPi=0.1,
    tIntPi=60)
    annotation (Placement(transformation(extent={{108,8},{88,28}})));
  ChillerPlantSystem.Pump.SecPumpSystem pumSecCHW(
    redeclare package Medium = MediumCHW,
    dP_nominal=dP_nominal,
    m_flow_nominal=mCHW_flow_nominal,
    v_flow_ratio=v_flow_ratio,
    v_flow_rate=v_flow_rate,
    Pressure=pressure,
    Motor_eta=Motor_eta_Sec,
    Hydra_eta=Hydra_eta_Sec,
    N_nominal=1500,
    dPFrihealos_nominal=dP_nominal*0.5)
    annotation (Placement(transformation(extent={{44,-108},{78,-72}})));
  Modelica.Blocks.Sources.Constant TCHWSet(k=273.15 + 5.56)
    annotation (Placement(transformation(extent={{-260,38},{-240,58}})));
  ChillerPlantSystem.Pump.PumpSystem pumPriCHW(
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{-12,0},{-48,36}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWByp(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    allowFlowReversal=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-10})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(
      redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{-44,-78},{-36,-70}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(redeclare package Medium =
                       MediumCHW) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-52})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Modelica.Blocks.Sources.Constant On(k=1)
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  ChillerPlantSystem.CoolingTower.CoolingTowerWithBypass
                                            cooTowWithByp(
    redeclare package MediumCW = MediumCW,
    TSet=273.15 + 15.56,
    P_nominal=PTow_nominal,
    dTCW_nominal=dTCW_nominal,
    dP_nominal=dP_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=0.1,
    tIntPi=60,
    eta=eta,
    dPByp_nominal=dPByp_nominal,
    byp(dPByp_nominal=dPByp_nominal),
    TCW_start=273.15 + 29.44,
    v_flow_rate=vTow_flow_rate,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal)
    annotation (Placement(transformation(extent={{-188,-42},{-160,-14}})));
  ChillerPlantSystem.Pump.PumpSystem pumCW(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta) annotation (Placement(transformation(extent={{-146,-110},
            {-112,-74}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(
      redeclare package Medium = MediumCW)
    annotation (Placement(transformation(extent={{-184,-78},{-176,-70}})));
  Modelica.Blocks.Sources.Constant TCWSet(k=273.15 + 23.89)
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam=
        "Resources/WeatherData/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-222,-100},{-202,-80}})));
  BaseClasses.Control.ChillerStage chillerStage(tWai=1800)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  ChillerPlantSystem.Pump.Control.SecPumCon secPumCon(          dPSetPoi=
        dP_nominal*0.5, tWai=1800)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  ChillerPlantSystem.CoSimulation.CooLoa cooLoa(tsta=209*86400, tend=217*86400)
    annotation (Placement(transformation(extent={{180,26},{160,46}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWBuiEnt(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    allowFlowReversal=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-90})));
  Buildings.Utilities.IO.BCVTB.To_degC toDegC
    annotation (Placement(transformation(extent={{164,-58},{184,-38}})));
equation
  connect(senTCHWByp.port_a, senMasFloByp.port_b) annotation (Line(
      points={{0,-20},{0,-42}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTCHWByp.port_b, pumPriCHW.port_a) annotation (Line(
      points={{0,0},{0,18},{-12,18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mulChiSys.TCHWSet, TCHWSet.y) annotation (Line(
      points={{-97.71,-1.4},{-142,-1.4},{-142,48},{-239,48}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mulChiSys.port_a_CHW, pumPriCHW.port_b) annotation (Line(
      points={{-58,6.2},{-54,6.2},{-54,18},{-48,18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mulChiSys.port_b_CHW, senMasFloByp.port_a) annotation (Line(
      points={{-58,-24.2},{-56,-24.2},{-56,-90},{0,-90},{0,-62}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(expVesCHW.port_a, senMasFloByp.port_a) annotation (Line(
      points={{-40,-78},{-40,-90},{-1.77636e-015,-90},{-1.77636e-015,-62}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(On.y, realToBoolean.u) annotation (Line(
      points={{-239,90},{-162,90}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cooTowWithByp.port_a, mulChiSys.port_b_CW) annotation (Line(
      points={{-160,-19.6},{-160,18},{-100,18},{-100,4},{-98,4},{-98,6.2},{-96,
          6.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(cooTowWithByp.port_b, pumCW.port_a) annotation (Line(
      points={{-160,-39.2},{-160,-92},{-146,-92}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumCW.port_b, mulChiSys.port_a_CW) annotation (Line(
      points={{-112,-92},{-100,-92},{-100,-24.2},{-96,-24.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(expVesCW.port_a, pumCW.port_a) annotation (Line(
      points={{-180,-78},{-180,-92},{-146,-92}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));

  connect(TCWSet.y, cooTowWithByp.TCWSet) annotation (Line(
      points={{-239,-10},{-220,-10},{-220,-28},{-189.26,-28}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-240,-90},{-212,-90}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None,
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TWetBul, cooTowWithByp.TWetBul) annotation (Line(
      points={{-212,-90},{-200,-90},{-200,-36},{-198,-36},{-198,-36.4},{-189.26,
          -36.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(pumSecCHW.port_a, senMasFloByp.port_a) annotation (Line(
      points={{44,-90},{0,-90},{0,-62},{-1.83187e-015,-62}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(bui.port_b, pumPriCHW.port_a) annotation (Line(
      points={{88,18},{-12,18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(chillerStage.y, mulChiSys.On) annotation (Line(
      points={{-59,70},{-40,70},{-40,40},{-120,40},{-120,-16.6},{-97.71,-16.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(pumCW.On, mulChiSys.On) annotation (Line(
      points={{-147.53,-81.2},{-152,-81.2},{-152,-40},{-112,-40},{-112,-16.6},{
          -97.71,-16.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cooTowWithByp.On, mulChiSys.On) annotation (Line(
      points={{-189.26,-19.6},{-200,-19.6},{-200,-8},{-120,-8},{-120,-16.6},{
          -97.71,-16.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chillerStage.On, realToBoolean.y) annotation (Line(
      points={{-82,78},{-120,78},{-120,90},{-139,90}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(chillerStage.Status, mulChiSys.Rat) annotation (Line(
      points={{-82,62},{-90,62},{-90,36},{-44,36},{-44,-16.6},{-56.1,-16.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumPriCHW.On, mulChiSys.On) annotation (Line(
      points={{-10.38,28.8},{10,28.8},{10,52},{-120,52},{-120,-16.6},{-97.71,
          -16.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(secPumCon.On, realToBoolean.y) annotation (Line(
      points={{58,58},{50,58},{40,58},{40,90},{-139,90}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(pumSecCHW.SpeRat, secPumCon.Status) annotation (Line(
      points={{79.7,-79.2},{98,-79.2},{98,-20},{40,-20},{40,42},{58,42}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(secPumCon.dP, bui.dP) annotation (Line(
      points={{58,46},{44,46},{44,22},{87,22}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(bui.y, secPumCon.yVal) annotation (Line(
      points={{87,26},{68,26},{48,26},{48,54},{58,54}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(secPumCon.y, pumSecCHW.Spe) annotation (Line(
      points={{81,50},{104,50},{122,50},{122,-68},{28,-68},{28,-79.2},{42.47,
          -79.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cooLoa.Loa, bui.CooLoa) annotation (Line(
      points={{159,36},{138,36},{138,22},{108.9,22}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumSecCHW.port_b, senTCHWBuiEnt.port_a) annotation (Line(
      points={{78,-90},{100,-90}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWBuiEnt.port_b, bui.port_a) annotation (Line(
      points={{120,-90},{140,-90},{140,18},{108,18}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWBuiEnt.T, toDegC.Kelvin) annotation (Line(
      points={{110,-79},{110,-79},{110,-48},{162,-48}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(toDegC.Celsius, cooLoa.CHW_temp) annotation (Line(
      points={{185,-48},{214,-48},{214,36},{182,36}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/ChillerPlantSystem.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-140},{240,
            120}})),
    experiment(
      StartTime=1.80576e+007,
      StopTime=1.87488e+007,
      __Dymola_NumberOfIntervals=11520,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>The schematic drawing of the Lejeune plant is shown as folowing.</p>
<p><img src=\"Resources/Images/lejeunePlant/lejeune_schematic_drawing.jpg\" alt=\"image\"/> </p>
<p>In addition, the parameters are listed as below.</p>
<p>The parameters for the chiller plant.</p>
<p><img src=\"Resources/Images/lejeunePlant/Chiller.png\" alt=\"image\"/> </p>
<p>The parameters for the primary chilled water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/PriCHWPum.png\" alt=\"image\"/> </p>
<p>The parameters for the secondary chilled water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/SecCHWPum1.png\" alt=\"image\"/> </p>
<p><img src=\"Resources/Images/lejeunePlant/SecCHWPum2.png\" alt=\"image\"/> </p>
<p>The parameters for the condenser water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/CWPum.png\" alt=\"image\"/> </p>
</html>"));
end ChillerPlantSystem_FMU;
