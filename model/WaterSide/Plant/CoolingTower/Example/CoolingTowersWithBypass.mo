within WaterSide.Plant.CoolingTower.Example;
model CoolingTowersWithBypass
  import ChillerPlantSystem = WaterSide.Plant;
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
  parameter Real v_flow_rate[3,:]={{1},{1},{1}} "Volume flow rate rate";
  parameter Real eta[3,:]={{1},{1},{1}} "Fan efficiency";
  parameter Modelica.SIunits.Pressure dPByp_nominal=1000
    "Pressure difference between the outlet and inlet of the modules ";
  ChillerPlantSystem.CoolingTower.CoolingTowersWithBypass
                                            cooTowWitByp(
    redeclare package MediumCW = MediumCW,
    P_nominal=P_nominal,
    dTCW_nominal=dTCW_nominal,
    dP_nominal=dP_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    v_flow_rate=v_flow_rate,
    dPByp_nominal=dPByp_nominal,
    TSet=273.15 + 15.56,
    TCW_start=273.15 + 29.44,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal,
    eta=eta,
    n=3)
    annotation (Placement(transformation(extent={{-20,2},{0,22}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCW(
    use_T_in=true,
    m_flow=mCW_flow_nominal,
    redeclare package Medium = MediumCW,
    T=273.15 + 29.44,
    nPorts=1,
    use_m_flow_in=true) "Source for CW"
    annotation (Placement(transformation(extent={{40,8},{20,28}})));
  Buildings.Fluid.Sources.FixedBoundary sinCW(redeclare package Medium =
               MediumCW, nPorts=1) "Sink for CW" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,-70})));
  Modelica.Blocks.Sources.Constant TWetBul(k=273.15 + 25)   annotation (Placement(transformation(extent={{-80,-80},
            {-60,-60}})));
  Modelica.Blocks.Sources.Constant TCWSet(k=273.15 + 29.44)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Step OnA(
    height=-1,
    offset=1,
    startTime=21600)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Step OnB(
    height=-1,
    offset=1,
    startTime=43200)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Step OnC(
    height=-1,
    offset=1,
    startTime=64800)
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Modelica.Blocks.Sources.Sine TCWLeaChi(
    freqHz=1/21600,
    amplitude=17.31,
    offset=273.15 + 17.31)
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Modelica.Blocks.Sources.RealExpression mCHW_flow(y=(OnA.y + OnB.y + 1)*
        mCW_flow_nominal)
    annotation (Placement(transformation(extent={{80,14},{60,34}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWEntChi(
      redeclare package Medium = MediumCW, m_flow_nominal=3*mCW_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-30})));
equation

  connect(souCW.ports[1], cooTowWitByp.port_a) annotation (Line(
      points={{20,18},{0,18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(TWetBul.y, cooTowWitByp.TWetBul) annotation (Line(
      points={{-59,-70},{-32,-70},{-32,6},{-20.9,6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TCWSet.y, cooTowWitByp.TCWSet) annotation (Line(
      points={{-59,-30},{-40,-30},{-40,12},{-20.9,12}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TCWLeaChi.y, souCW.T_in) annotation (Line(
      points={{59,-30},{50,-30},{50,22},{42,22}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mCHW_flow.y, souCW.m_flow_in) annotation (Line(
      points={{59,24},{50,24},{50,26},{42,26}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sinCW.ports[1],senTCWEntChi. port_b) annotation (Line(
      points={{20,-70},{10,-70},{10,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTCWEntChi.port_a, cooTowWitByp.port_b) annotation (Line(
      points={{10,-20},{10,4},{0,4}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(OnA.y, cooTowWitByp.On[1]) annotation (Line(
      points={{-59,10},{-44,10},{-44,17.4},{-20.9,17.4}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(OnB.y, cooTowWitByp.On[2]) annotation (Line(
      points={{-59,50},{-42,50},{-42,18},{-20.9,18}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(OnC.y, cooTowWitByp.On[3]) annotation (Line(
      points={{59,50},{14,50},{-32,50},{-32,18.6},{-20.9,18.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/CoolingTower/Example/CoolingTowerWithBypass.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput);
end CoolingTowersWithBypass;
