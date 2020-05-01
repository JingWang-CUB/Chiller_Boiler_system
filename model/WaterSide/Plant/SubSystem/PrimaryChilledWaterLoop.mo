within WaterSide.Plant.SubSystem;
model PrimaryChilledWaterLoop
  "This model is designed to test the model in the primary chilled water loop"
  import ChillerPlantSystem = WaterSide.Plant;
  extends Modelica.Icons.Example;
  package MediumCHW = Buildings.Media.Water
    "Medium model";
  package MediumCW = Buildings.Media.Water "Medium model";
  parameter Real tWai = 900 "Waiting time";
  parameter Modelica.SIunits.Power PChi_nominal = 1000*3517/COP_nominal
    "Nominal chiller power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCHW_nominal = 5.56
    "Temperature difference at chilled water side";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal = 5.18
    "Temperature difference at condenser water wide";
  parameter Modelica.SIunits.Pressure dPCHW_nominal = 91166
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.Pressure dPCW_nominal = 92661
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.Temperature TCHW_nominal = 273.15 + 5.56
    "Temperature at chilled water side";
  parameter Modelica.SIunits.Temperature TCW_nominal = 273.15 + 29.44
    "Temperature at condenser water wide";
  parameter Real COP_nominal = 7.35 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = PChi_nominal*COP_nominal/4200/5.56
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = mCHW_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water wide";
  parameter Real k = 1 "Gain of the PID controller";
  parameter Real Ti = 60 "Intregration time of the PID controller";
  parameter Real Motor_eta = 1 "Motor efficiency";
  parameter Real Hydra_eta = 1 "Hydraulic efficiency";

  Chiller.MultiChillerSystem mulChiSys(
    redeclare package MediumCHW = MediumCHW,
    redeclare package MediumCW = MediumCW,
    dPCHW_nominal=dPCHW_nominal,
    dPCW_nominal=dPCW_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    TCW_start=273.15 + 29.44,
    TCHW_start=273.15 + 5.56,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_PFH_4020kW_7_35COP_Vanes())
    annotation (Placement(transformation(extent={{-116,-22},{-88,6}})));
  Modelica.Blocks.Sources.Ramp TRet2(
    startTime=0,
    height=5.56,
    offset=273.15 + 5.56,
    duration=40000)
    annotation (Placement(transformation(extent={{160,2},{140,22}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCW(
    redeclare package Medium = MediumCW,
    nPorts=1,
    m_flow=3*mCW_flow_nominal,
    use_m_flow_in=true,
    use_T_in=true,
    T=298.15) "Source for CW"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Fluid.Sources.FixedBoundary sinCW(redeclare package Medium =
               MediumCW, nPorts=1) "Sink for CW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,20})));
  Modelica.Blocks.Sources.Constant TCHWSet(k=273.15 + 5.56)
    annotation (Placement(transformation(extent={{-220,38},{-200,58}})));
  Modelica.Blocks.Sources.RealExpression mCW_flow(y=(chillerStage.y[1] +
        chillerStage.y[2] + chillerStage.y[3])*mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-220,-26},{-200,-6}})));
  Modelica.Blocks.Sources.Constant TCWEntChi(k=273.15 + 12.78)
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));
  ChillerPlantSystem.Pump.PumpSystem pumPriCHW(
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{-40,0},{-70,36}})));
  Modelica.Blocks.Sources.Ramp TRet1(
    offset=0,
    height=-5.56,
    duration=40000,
    startTime=46400)
    annotation (Placement(transformation(extent={{160,-38},{140,-18}})));
  Modelica.Blocks.Math.Add CooLoa
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Modelica.Blocks.Sources.Constant On(k=1)
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Buildings.Fluid.Sources.FixedBoundary sinCHW(nPorts=1,
      redeclare package Medium = MediumCHW) "Sink for CHW" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-100})));
  Buildings.Fluid.Sources.Boundary_pT souCHW(
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    nPorts=1) "source for CHW"
    annotation (Placement(transformation(extent={{10,8},{-10,28}})));
  BaseClasses.Control.ChillerStage chillerStage(tWai=900)
    annotation (Placement(transformation(extent={{-122,60},{-102,80}})));
equation
  connect(souCW.ports[1], mulChiSys.port_a_CW) annotation (Line(
      points={{-160,-100},{-130,-100},{-130,-19.2},{-116,-19.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mCW_flow.y, souCW.m_flow_in) annotation (Line(
      points={{-199,-16},{-190,-16},{-190,-92},{-182,-92}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TCWEntChi.y, souCW.T_in) annotation (Line(
      points={{-199,-110},{-190,-110},{-190,-96},{-182,-96}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRet2.y, CooLoa.u1) annotation (Line(
      points={{139,12},{128,12},{128,56},{102,56}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRet1.y, CooLoa.u2) annotation (Line(
      points={{139,-28},{120,-28},{120,44},{102,44}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mulChiSys.TCHWSet, TCHWSet.y) annotation (Line(
      points={{-117.26,-2.4},{-150,-2.4},{-150,48},{-199,48}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mulChiSys.port_a_CHW, pumPriCHW.port_b) annotation (Line(
      points={{-88,3.2},{-74,3.2},{-74,18},{-70,18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mulChiSys.port_b_CW, sinCW.ports[1]) annotation (Line(
      points={{-116,3.2},{-130,3.2},{-130,20},{-160,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(On.y, realToBoolean.u) annotation (Line(
      points={{-199,90},{-182,90}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sinCHW.ports[1], mulChiSys.port_b_CHW) annotation (Line(
      points={{-10,-100},{-74,-100},{-74,-19.2},{-88,-19.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(souCHW.ports[1], pumPriCHW.port_a) annotation (Line(
      points={{-10,18},{-40,18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(chillerStage.On, realToBoolean.y) annotation (Line(
      points={{-124,78},{-124,78},{-140,78},{-140,90},{-159,90}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(mulChiSys.Rat, chillerStage.Status) annotation (Line(
      points={{-86.6,-13.6},{-80,-13.6},{-80,42},{-132,42},{-132,62},{-124,62}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(chillerStage.y, mulChiSys.On) annotation (Line(
      points={{-101,70},{-86,70},{-86,36},{-140,36},{-140,-13.6},{-117.26,-13.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(pumPriCHW.On, chillerStage.y) annotation (Line(points={{-38.65,28.8},{
          -22,28.8},{-22,70},{-101,70}}, color={0,0,127}));
  connect(CooLoa.y, souCHW.T_in) annotation (Line(points={{79,50},{40,50},{40,22},
          {12,22}}, color={0,0,127}));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/SubSystem/PrimaryChilledWaterLoop.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-140},{220,120}})),
    experiment(StopTime=90000, __Dymola_Algorithm="Radau"),
    __Dymola_experimentSetupOutput);
end PrimaryChilledWaterLoop;
