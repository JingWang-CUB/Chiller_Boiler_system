within WaterSide.BaseClasses.Components.Example;
model PumpConstantSpeed

  import ChillerPlantSystem = WaterSide;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=10
    "Nominal mass flow rate ";
  parameter Real Motor_eta = 1 "Motor efficiency";
  parameter Real Hydra_eta = 1 "Hydraulic efficiency";
  ChillerPlantSystem.BaseClasses.Components.PumpConstantSpeed
                                                pumConSpeB(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=1,
    p=100000,
    T=293.15) annotation (Placement(transformation(extent={{-80,-30},{-60,-10}},
          rotation=0)));
  Modelica.Blocks.Sources.Step On(startTime=20)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  Buildings.Fluid.FixedResistances.PressureDrop       dpDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000) "Pressure drop"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop       dpDyn1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000) "Pressure drop"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=1,
    p=100000,
    T=293.15) annotation (Placement(transformation(extent={{-80,-90},{-60,-70}},
          rotation=0)));
equation

  connect(sou.ports[1], pumConSpeB.port_a) annotation (Line(
      points={{-60,-20},{-60,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(On.y, pumConSpeB.On) annotation (Line(
      points={{-59,70},{-46,70},{-46,6},{-0.9,6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pumConSpeB.port_b, dpDyn.port_a) annotation (Line(
      points={{20,0},{30,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(dpDyn.port_b, senMasFlo.port_a) annotation (Line(
      points={{50,0},{80,0},{80,-80},{20,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(dpDyn1.port_b, senMasFlo.port_a) annotation (Line(
      points={{20,-40},{60,-40},{60,0},{80,0},{80,-80},{20,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(dpDyn1.port_a, pumConSpeB.port_a) annotation (Line(
      points={{0,-40},{-20,-40},{-20,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senMasFlo.port_b, sink.ports[1])
    annotation (Line(points={{0,-80},{-32,-80},{-60,-80}}, color={0,127,255}));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Components/Example/PumpConstantSpeed.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end PumpConstantSpeed;
