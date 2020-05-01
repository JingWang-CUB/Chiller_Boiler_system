within WaterSide.Plant.SubSystem;
model SecondaryChilledWaterLoop
  "This model is designed to test the model in the secondary chilled water loop"
  import ChillerPlantSystem = WaterSide.Plant;
  extends Modelica.Icons.Example;
  package MediumCHW = Buildings.Media.Water
    "Medium model";
  parameter Real tWai = 900 "Waiting time";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = 2500*3.517/4.2/5.56
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.SIunits.Pressure dP_nominal=478250
    "Nominal pressure drop for the secondary chilled water pump ";
  parameter Real v_flow_ratio[:] = {0,0.5,1};
  parameter Real v_flow_rate[:] = {0.4*mCHW_flow_nominal/996,0.6*mCHW_flow_nominal/996,0.8*mCHW_flow_nominal/996,mCHW_flow_nominal/996,1.2*mCHW_flow_nominal/996};
  parameter Real pressure[:] = {1.28*dP_nominal,1.2*dP_nominal,1.1*dP_nominal,dP_nominal,0.75*dP_nominal};
  parameter Real Motor_eta_Sec[:] = {1,1,1,1,1} "Motor efficiency";
  parameter Real Hydra_eta_Sec[:] = {1,1,1,1,1} "Hydraulic efficiency";
  BaseClasses.Components.Building        bui(
    redeclare package Medium = MediumCHW,
    TBuiSetPoi=273.15 + 11.12,
    dP_nominal=dP_nominal*0.5,
    GaiPi=0.1,
    tIntPi=120,
    V=10,
    m_flow_nominal=2*mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{80,-100},{60,-80}})));
  Modelica.Blocks.Sources.Ramp CooLoa2(
    startTime=0,
    offset=0,
    height=4200*3*mCHW_flow_nominal*5.56,
    duration=40000)
    annotation (Placement(transformation(extent={{200,20},{180,40}})));
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
    annotation (Placement(transformation(extent={{-50,0},{-6,36}})));
  Modelica.Blocks.Sources.Constant TCHWSet(k=273.15 + 5.56)
    annotation (Placement(transformation(extent={{-160,12},{-140,32}})));
  Modelica.Blocks.Sources.Ramp CooLoa1(
    offset=0,
    height=-4200*3*mCHW_flow_nominal*5.56,
    duration=40000,
    startTime=46400)
    annotation (Placement(transformation(extent={{200,-122},{180,-102}})));
  Modelica.Blocks.Math.Add CooLoa
    annotation (Placement(transformation(extent={{140,-100},{120,-80}})));
  Buildings.Fluid.Sources.Boundary_pT souCHW(
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    nPorts=1) "source for CHW"
    annotation (Placement(transformation(extent={{-110,8},{-90,28}})));
  Buildings.Fluid.Sources.FixedBoundary sinCHW(nPorts=1,
      redeclare package Medium = MediumCHW) "Sink for CHW" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-90})));
  ChillerPlantSystem.Pump.Control.SecPumCon
                                dPControl(dPSetPoi=dP_nominal, tWai=900)
    annotation (Placement(transformation(extent={{-60,74},{-40,94}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Modelica.Blocks.Sources.Constant On(k=1)
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
equation
  connect(CooLoa2.y, CooLoa.u1) annotation (Line(
      points={{179,30},{160,30},{160,-84},{142,-84}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(CooLoa1.y, CooLoa.u2) annotation (Line(
      points={{179,-112},{160,-112},{160,-96},{142,-96}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(bui.Loa, CooLoa.y) annotation (Line(
      points={{80.9,-86},{111,-86},{111,-90},{119,-90}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pumSecCHW.port_b, bui.port_a) annotation (Line(
      points={{-6,18},{100,18},{100,-90},{80,-90}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(sinCHW.ports[1], bui.port_b) annotation (Line(
      points={{-90,-90},{60,-90}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(souCHW.ports[1], pumSecCHW.port_a) annotation (Line(
      points={{-90,18},{-50,18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(TCHWSet.y, souCHW.T_in) annotation (Line(
      points={{-139,22},{-112,22}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dPControl.y, pumSecCHW.Spe)
    annotation (Line(
      points={{-39,84},{-30,84},{-20,84},{-20,52},{-62,52},{-62,28.8},{-51.98,28.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(On.y,realToBoolean. u) annotation (Line(
      points={{-159,100},{-142,100}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dPControl.On, realToBoolean.y) annotation (Line(
      points={{-62,92},{-100,92},{-100,100},{-119,100}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(pumSecCHW.SpeRat, dPControl.Status)
    annotation (Line(
      points={{-3.8,28.8},{20,28.8},{20,60},{-80,60},{-80,76},{-62,76}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(bui.y, dPControl.yVal) annotation (Line(
      points={{59,-82},{-6,-82},{-84,-82},{-84,88},{-62,88}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(bui.dP, dPControl.dP) annotation (Line(
      points={{59,-86},{-4,-86},{-76,-86},{-76,80},{-62,80}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/SubSystem/SecondaryChilledWaterLoop.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{220,120}})),
    experiment(StopTime=90000, __Dymola_Algorithm="Radau"),
    __Dymola_experimentSetupOutput);
end SecondaryChilledWaterLoop;
