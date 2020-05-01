within WaterSide.Plant.SubSystem;
model CondenserWaterLoop
  import ChillerPlantSystem = WaterSide.Plant;
  extends Modelica.Icons.Example;
  package MediumCHW = Buildings.Media.Water
    "Medium model";
  package MediumCW = Buildings.Media.Water "Medium model";
  parameter Real tWai = 1800 "Waiting time";
  parameter Modelica.SIunits.TemperatureDifference dT = 0.5
    "Temperature difference for stage control";
  parameter Modelica.SIunits.Power PChi_nominal = 756/5.42
    "Nominal chiller power (at y=1)";
  parameter Modelica.SIunits.Power PTow_nominal = 1E3
    "Nominal cooling tower power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCHW_nominal = 5.56
    "Temperature difference at chilled water side";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal = 5.18
    "Temperature difference at condenser water wide";
  parameter Modelica.SIunits.Pressure dPCHW_nominal = 6000
    "Pressure difference at chilled water side";
  parameter Modelica.SIunits.Pressure dPCW_nominal = 6000
    "Pressure difference at condenser water wide";
  parameter Modelica.SIunits.Temperature TCHW_nominal = 273.15 + 5.56
    "Temperature difference at chilled water side";
  parameter Modelica.SIunits.Temperature TCW_nominal = 273.15 + 29.44
    "Temperature difference at condenser water wide";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = 2500*3.517/4.2/5.42
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = mCHW_flow_nominal*(5.56+1)/5.56
    "Nominal mass flow rate at condenser water wide";
  parameter Real k = 1 "Gain of the PID controller";
  parameter Real Ti = 60 "Intregration time of the PID controller";
  parameter Real Motor_eta = 1
                              "Motor efficiency";
  parameter Real Hydra_eta = 1 "Hydraulic efficiency";
  parameter Modelica.SIunits.Temperature TWetBul_nominal=273.15+25
    "Nominal wet bulb temperature";
  parameter Modelica.SIunits.Pressure dP_nominal=1000
    "Pressure difference between the outlet and inlet of the modules ";
  parameter Real GaiPi=1 "Gain of the PI controller";
  parameter Real tIntPi=60 "Integration time of the PI controller";
  parameter Real v_flow_rate[:]={1} "Volume flow rate rate";
  parameter Real eta[:]={1} "Fan efficiency";
  parameter Modelica.SIunits.TemperatureDifference dTApp_nominal=4.44
    "Nominal approach temperature";
  parameter Real TraPoi1=2500 "Transition point form OneOn to TwoOn";
  parameter Real TraPoi2=5000 "Transition point form TwoOn to ThreeOn";
  parameter Real DeaBanWid=100 "Chiller stage control dead band width";
  parameter Real MinRat=0.2 "Minimum part load ratio";
  parameter Modelica.SIunits.Pressure dPByp_nominal=1000
    "Pressure difference between the outlet and inlet of the modules ";
  ChillerPlantSystem.CoolingTower.CoolingTowerWithBypass
                                            cooTowWithByp(
    redeclare package MediumCW = MediumCW,
    TSet=273.15 + 15.56,
    P_nominal=PTow_nominal,
    dTCW_nominal=dTCW_nominal,
    dP_nominal=dP_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    v_flow_rate=v_flow_rate,
    eta=eta,
    dPByp_nominal=dPByp_nominal,
    byp(dPByp_nominal=dPByp_nominal),
    TCW_start=273.15 + 29.44,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  ChillerPlantSystem.Chiller.MultiChillerSystem mulChiSys(
    redeclare package MediumCHW = MediumCHW,
    redeclare package MediumCW = MediumCW,
    dPCHW_nominal=dPCHW_nominal,
    dPCW_nominal=dPCW_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    TCW_start=273.15 + 29.44,
    TCHW_start=273.15 + 5.56,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_823kW_6_28COP_Vanes())
               annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  ChillerPlantSystem.Pump.PumpSystem pumCW(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta) annotation (Placement(transformation(extent={{-40,-80},
            {-20,-60}})));
  Buildings.Fluid.Sources.FixedBoundary sinCHW(redeclare package Medium =
               MediumCHW, nPorts=1) "Sink for CHW" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={72,-70})));
  Buildings.Fluid.Sources.MassFlowSource_T souCHW(
    nPorts=1,
    m_flow=3*mCW_flow_nominal,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    T=298.15) "Source for CHW"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  Modelica.Blocks.Sources.Constant TCWSet(k=273.15 + 29.44)
    annotation (Placement(transformation(extent={{-100,-42},{-80,-22}})));
  Modelica.Blocks.Sources.Constant TWetBul(k=273.15 + 12)   annotation (Placement(transformation(extent={{-100,
            -80},{-80,-60}})));
  Modelica.Blocks.Sources.Constant TCHWSet(k=273.15 + 5.56)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWEntChi(
      redeclare package Medium = MediumCHW, m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Modelica.Blocks.Sources.RealExpression mCHW_flow(y=3*mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{110,-30},{90,-10}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(redeclare package Medium =
                       MediumCW)
    annotation (Placement(transformation(extent={{-74,-93},{-66,-84}})));
  Modelica.Blocks.Sources.Sine TCHWEntChi(
    freqHz=1/43200,
    amplitude=2.5,
    offset=273.15 + 7)
                    annotation (Placement(transformation(extent={{112,-60},{92,
            -40}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-60,72},{-40,92}})));
  Modelica.Blocks.Sources.Step     On(startTime=44000,
    height=0,
    offset=1)
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  BaseClasses.Control.ChillerStage chillerStage(tWai=900)
    annotation (Placement(transformation(extent={{-58,40},{-38,60}})));
equation
  connect(pumCW.port_b, mulChiSys.port_a_CW) annotation (Line(
      points={{-20,-70},{-10,-70},{-10,-58},{0,-58}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mulChiSys.port_b_CW, cooTowWithByp.port_a) annotation (Line(
      points={{0,-42},{-10,-42},{-10,-4},{-40,-4}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(sinCHW.ports[1], mulChiSys.port_b_CHW) annotation (Line(
      points={{62,-70},{28,-70},{28,-58},{20,-58}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(cooTowWithByp.port_b, pumCW.port_a) annotation (Line(
      points={{-40,-18},{-28,-18},{-28,-40},{-60,-40},{-60,-70},{-40,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(TCWSet.y, cooTowWithByp.TCWSet) annotation (Line(
      points={{-79,-32},{-70,-32},{-70,-10},{-60.9,-10}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TWetBul.y, cooTowWithByp.TWetBul) annotation (Line(
      points={{-79,-70},{-68,-70},{-68,-16},{-60.9,-16}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(souCHW.ports[1], senTCHWEntChi.port_a) annotation (Line(
      points={{60,-40},{50,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTCHWEntChi.port_b, mulChiSys.port_a_CHW) annotation (Line(
      points={{30,-40},{28,-40},{28,-42},{20,-42}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mCHW_flow.y, souCHW.m_flow_in) annotation (Line(
      points={{89,-20},{82,-20},{82,-32}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(expVesCW.port_a, pumCW.port_a) annotation (Line(
      points={{-70,-93},{-70,-98},{-60,-98},{-60,-70},{-40,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mulChiSys.TCHWSet, TCHWSet.y) annotation (Line(
      points={{-0.9,-46},{-24,-46},{-24,10},{-79,10}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TCHWEntChi.y, souCHW.T_in) annotation (Line(
      points={{91,-50},{88,-50},{88,-36},{82,-36}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(On.y,realToBoolean. u) annotation (Line(
      points={{-79,80},{-70,80},{-70,82},{-62,82}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash,
      pattern=LinePattern.Dash));
  connect(mulChiSys.Rat, chillerStage.Status) annotation (Line(
      points={{21,-54},{30,-54},{30,18},{30,26},{30,34},{-72,34},{-72,42},{-60,42}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(pumCW.On, chillerStage.y) annotation (Line(
      points={{-40.9,-64},{-48,-64},{-48,-62},{-48,-54},{-18,-54},{-18,50},{-37,
          50}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realToBoolean.y, chillerStage.On) annotation (Line(points={{-39,82},{-24,
          82},{-24,66},{-66,66},{-66,58},{-60,58}}, color={255,0,255}));
  connect(mulChiSys.On, chillerStage.y) annotation (Line(
      points={{-0.9,-54},{-10,-54},{-18,-54},{-18,50},{-37,50}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cooTowWithByp.On, chillerStage.y) annotation (Line(
      points={{-60.9,-4},{-68,-4},{-68,24},{-30,24},{-30,50},{-37,50}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/SubSystem/CondenserWaterloop.mos"
        "Simulate and plot"),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{120,100}})),
    experiment(StopTime=172800),
    __Dymola_experimentSetupOutput);
end CondenserWaterLoop;
