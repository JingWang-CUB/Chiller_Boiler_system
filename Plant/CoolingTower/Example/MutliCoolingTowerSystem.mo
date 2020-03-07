within WaterSideSystem.Plant.CoolingTower.Example;
model MutliCoolingTowerSystem
  import ChillerPlantSystem = WaterSideSystem.Plant;
  extends Modelica.Icons.Example;
  package MediumCW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.Power P_nominal=30000 "Nominal power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal=5.18
    "Temperature difference between the outlet and inlet of the cooling tower";
  parameter Modelica.SIunits.TemperatureDifference dTApp_nominal=4.44
    "Nominal approach temperature";
  parameter Modelica.SIunits.Temperature TWetBul_nominal=273.15+25
    "Nominal wet bulb temperature";
  parameter Modelica.SIunits.Pressure dP_nominal=1000
    "Pressure difference between the outlet and inlet of the modules ";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=10
    "Nominal mass flow rate at condenser water wide";
  parameter Real GaiPi=1 "Gain of the PI controller";
  parameter Real tIntPi=60 "Integration time of the PI controller";
  parameter Real v_flow_rate[:]={1} "Volume flow rate rate";
  parameter Real eta[:]={1} "Fan efficiency";
  ChillerPlantSystem.CoolingTower.MultiCoolingTowerSystem mulCooTowSys(
    redeclare package MediumCW = MediumCW,
    P_nominal=P_nominal,
    dTCW_nominal=dTCW_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    v_flow_rate=v_flow_rate,
    TCW_start=273.15 + 29.44,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal,
    dP_nominal=dP_nominal,
    eta=eta)
    annotation (Placement(transformation(extent={{-10,-10},{12,10}})));

  Modelica.Blocks.Sources.Constant TCWSet(k=273.15 + 29.44)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCW(
    use_T_in=true,
    m_flow=mCW_flow_nominal,
    redeclare package Medium = MediumCW,
    T=273.15 + 29.44,
    nPorts=1,
    use_m_flow_in=true) "Source for CW"
    annotation (Placement(transformation(extent={{-48,-50},{-28,-30}})));
  Modelica.Blocks.Sources.Sine TCWLeaChi(
    freqHz=1/86400,
    amplitude=2.59,
    offset=273.15 + 32.03)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant TWetBul(k=273.15 + 25)   annotation (Placement(transformation(extent={{-80,-60},
            {-60,-40}})));
  Modelica.Blocks.Sources.Step OnA(
    height=-1,
    offset=1,
    startTime=21600)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Step OnB(
    height=-1,
    offset=1,
    startTime=43200)
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
  Modelica.Blocks.Sources.Step OnC(
    height=-1,
    offset=1,
    startTime=64800)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Fluid.Sources.FixedBoundary sinCW(redeclare package Medium =
               MediumCW, nPorts=1) "Sink for CW" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-50})));
  Modelica.Blocks.Sources.RealExpression mCHW_flow(y=(OnA.y + OnB.y + OnC.y)*1)
    annotation (Placement(transformation(extent={{-26,-20},{-46,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWEntChi(
      m_flow_nominal=mCW_flow_nominal, redeclare package Medium = MediumCW,
    T_start=273.15 + 29.44)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation

  connect(TCWSet.y, mulCooTowSys.TCWSet) annotation (Line(
      points={{-59,70},{-20,70},{-20,7.9},{-10.99,7.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(OnA.y, mulCooTowSys.On[1]) annotation (Line(
      points={{-59,30},{-40,30},{-40,3.3},{-10.99,3.3}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(OnB.y, mulCooTowSys.On[2]) annotation (Line(
      points={{59,70},{0,70},{0,30},{-34,30},{-34,3.9},{-10.99,3.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(OnC.y, mulCooTowSys.On[3]) annotation (Line(
      points={{59,30},{4,30},{4,20},{-28,20},{-28,4.5},{-10.99,4.5}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TCWLeaChi.y, souCW.T_in) annotation (Line(
      points={{-59,-10},{-56,-10},{-56,-36},{-50,-36}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(souCW.ports[1], mulCooTowSys.port_a_CW) annotation (Line(
      points={{-28,-40},{-20,-40},{-20,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(TWetBul.y, mulCooTowSys.TWetBul) annotation (Line(
      points={{-59,-50},{-18,-50},{-18,-6},{-10.99,-6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mCHW_flow.y, souCW.m_flow_in) annotation (Line(
      points={{-47,-10},{-54,-10},{-54,-32},{-50,-32}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sinCW.ports[1],senTCWEntChi. port_b) annotation (Line(
      points={{60,-50},{40,-50},{40,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTCWEntChi.port_a, mulCooTowSys.port_b_CW) annotation (Line(
      points={{20,0},{12,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/CoolingTower/Example/MultiCoolingTowerSystem.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput);
end MutliCoolingTowerSystem;
