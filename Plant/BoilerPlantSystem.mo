within WaterSideSystem.Plant;
model BoilerPlantSystem
  "The model is designed to simulate the Lejeune Plant(simulation period:1year)"
  import ChillerPlantSystem = WaterSideSystem.Plant;
  extends Modelica.Icons.Example;
 package MediumHW =
     Buildings.Media.Water
    "Medium in the hot water side";
  parameter Modelica.SIunits.Pressure dPHW_nominal = 3000
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.MassFlowRate mHW_flow_nominal = 10
    "Nominal mass flow rate at the chilled water side";
  parameter Modelica.SIunits.Temperature THW = 273.15 + 80
    "The start temperature of chilled water side";
  parameter Modelica.SIunits.TemperatureDifference dTHW_nominal= 20
    "Temperature difference between the outlet and inlet of the module";
  parameter Real GaiPi=1 "Gain of the component PI controller";
  parameter Real tIntPi=60 "Integration time of the component PI controller";
  parameter Real eta[:]={0.8} "Fan efficiency";
  parameter Modelica.SIunits.Pressure dP_nominal=478250
    "Nominal pressure drop for the secondary chilled water pump ";
  parameter Real v_flow_ratio[:] = {0.4,0.6,0.8,1,1.2};
  parameter Real v_flow_rate[:] = {0.4*mHW_flow_nominal/996,0.6*mHW_flow_nominal/996,0.8*mHW_flow_nominal/996,mHW_flow_nominal/996,1.2*mHW_flow_nominal/996};
  parameter Real pressure[:] = {1.28*dP_nominal,1.2*dP_nominal,1.1*dP_nominal,dP_nominal,0.75*dP_nominal};

  parameter Real Motor_eta_Sec[:] = {0.6,0.76,0.87,0.86,0.74}
    "Motor efficiency";
  parameter Real Hydra_eta_Sec[:] = {1,1,1,1,1} "Hydraulic efficiency";

  BaseClasses.Components.Building        bui(
    dP_nominal=dP_nominal*0.5,
    GaiPi=0.1,
    tIntPi=60,
    redeclare package Medium = MediumHW,
    m_flow_nominal=2*mHW_flow_nominal,
    TBuiSetPoi=273.15 + 60,
    conPI(reverseAction=false))
    annotation (Placement(transformation(extent={{108,8},{88,28}})));
  ChillerPlantSystem.Pump.SecPumpSystem pumSecCHW(
    dP_nominal=dP_nominal,
    v_flow_ratio=v_flow_ratio,
    v_flow_rate=v_flow_rate,
    Pressure=pressure,
    Motor_eta=Motor_eta_Sec,
    Hydra_eta=Hydra_eta_Sec,
    N_nominal=1500,
    dPFrihealos_nominal=dP_nominal*0.5,
    redeclare package Medium = MediumHW,
    m_flow_nominal=mHW_flow_nominal)
    annotation (Placement(transformation(extent={{22,0},{-12,36}})));
  Modelica.Blocks.Sources.Constant TCHWSet(k=273.15 + 80)
    annotation (Placement(transformation(extent={{-260,38},{-240,58}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Modelica.Blocks.Sources.Constant On(k=1)
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  BaseClasses.Control.TwoStage boilerStage(tWai=1800)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  ChillerPlantSystem.Pump.Control.SecPumCon secPumCon(          dPSetPoi=
        dP_nominal*0.5, tWai=1800)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHWBuiEnt(
    allowFlowReversal=true,
    redeclare package Medium = MediumHW,
    m_flow_nominal=mHW_flow_nominal)
                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-90})));
  Buildings.Utilities.IO.BCVTB.To_degC toDegC
    annotation (Placement(transformation(extent={{164,-58},{184,-38}})));
  ChillerPlantSystem.Boiler.MultiBoiler multiBoiler(
    redeclare package MediumHW = MediumHW,
    dPHW_nominal=dP_nominal*0.5,
    mHW_flow_nominal=mHW_flow_nominal,
    THW=THW,
    dTHW_nominal=dTHW_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    eta=eta)
    annotation (Placement(transformation(extent={{-92,-44},{-58,-16}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumHW, V_start=10)
    annotation (Placement(transformation(extent={{30,4},{38,12}})));
  Modelica.Blocks.Sources.Ramp CooLoa2(
    startTime=0,
    offset=0,
    duration=40000,
    height=-4200*2*mHW_flow_nominal*20)
    annotation (Placement(transformation(extent={{220,80},{200,100}})));
  Modelica.Blocks.Sources.Ramp CooLoa1(
    offset=0,
    duration=40000,
    startTime=46400,
    height=4200*2*mHW_flow_nominal*20)
    annotation (Placement(transformation(extent={{220,-60},{200,-40}})));
  Modelica.Blocks.Math.Add CooLoa
    annotation (Placement(transformation(extent={{168,38},{148,58}})));
equation
  connect(On.y, realToBoolean.u) annotation (Line(
      points={{-239,90},{-162,90}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(boilerStage.On, realToBoolean.y) annotation (Line(
      points={{-82,78},{-120,78},{-120,90},{-139,90}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(secPumCon.On, realToBoolean.y) annotation (Line(
      points={{58,58},{50,58},{40,58},{40,90},{-139,90}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(secPumCon.dP, bui.dP) annotation (Line(
      points={{58,46},{44,46},{44,22},{87,22}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(bui.y, secPumCon.yVal) annotation (Line(
      points={{87,26},{68,26},{48,26},{48,54},{58,54}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(senTHWBuiEnt.port_b, bui.port_a) annotation (Line(
      points={{120,-90},{140,-90},{140,18},{108,18}},
      color={255,0,0},
      thickness=1));
  connect(senTHWBuiEnt.T, toDegC.Kelvin) annotation (Line(
      points={{110,-79},{110,-79},{110,-48},{162,-48}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(multiBoiler.port_a_HW, pumSecCHW.port_b) annotation (Line(
      points={{-58,-18.8},{-58,18},{-12,18}},
      color={255,0,0},
      thickness=1));
  connect(pumSecCHW.port_a, bui.port_b) annotation (Line(
      points={{22,18},{88,18}},
      color={255,0,0},
      thickness=1));
  connect(multiBoiler.port_b_HW, senTHWBuiEnt.port_a) annotation (Line(
      points={{-58,-41.2},{-58,-41.2},{-58,-90},{100,-90}},
      color={255,0,0},
      thickness=1));
  connect(multiBoiler.Rat, boilerStage.Status) annotation (Line(
      points={{-56.3,-35.6},{-34,-35.6},{-34,40},{-100,40},{-100,62},{-82,62}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(multiBoiler.On, boilerStage.y) annotation (Line(
      points={{-93.53,-35.6},{-120,-35.6},{-120,30},{-40,30},{-40,70},{-59,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(multiBoiler.THWSet, TCHWSet.y) annotation (Line(
      points={{-93.53,-24.4},{-200,-24.4},{-200,48},{-239,48}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumSecCHW.SpeRat, secPumCon.Status) annotation (Line(
      points={{-13.7,28.8},{-20,28.8},{-20,42},{58,42}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(secPumCon.y, pumSecCHW.Spe) annotation (Line(
      points={{81,50},{88,50},{88,28.8},{23.53,28.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(expVesCHW.port_a, bui.port_b) annotation (Line(
      points={{34,4},{34,-2},{44,-2},{44,18},{88,18}},
      color={255,0,0},
      thickness=1));
  connect(CooLoa2.y,CooLoa. u1) annotation (Line(
      points={{199,90},{188,90},{188,54},{170,54}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(CooLoa1.y,CooLoa. u2) annotation (Line(
      points={{199,-50},{188,-50},{188,42},{170,42}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(CooLoa.y, bui.CooLoa) annotation (Line(
      points={{147,48},{116,48},{116,22},{108.9,22}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/ChillerPlantSystem.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-140},{240,
            120}})),
    experiment(
      StartTime=1.728e+007,
      StopTime=1.73664e+007,
      __Dymola_NumberOfIntervals=1440,
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
end BoilerPlantSystem;
