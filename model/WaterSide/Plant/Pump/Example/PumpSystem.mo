within WaterSide.Plant.Pump.Example;
model PumpSystem
  import WaterSide.Plant.Pump;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=10
    "Nominal mass flow rate ";
  parameter Real Motor_eta = 1 "Motor efficiency";
  parameter Real Hydra_eta = 1 "Hydraulic efficiency";
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=2,
    p=0,
    T=293.15) annotation (Placement(transformation(extent={{-80,-30},{-60,-10}},
          rotation=0)));
  Buildings.Fluid.FixedResistances.PressureDrop       dpDyn(
    redeclare package Medium = Medium,
    dp_nominal=6000,
    m_flow_nominal=3*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Step OnC(startTime=30)
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
  Modelica.Blocks.Sources.Step OnB(startTime=20)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Step OnA(startTime=10)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  Pump.PumpSystem pumSys(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta) annotation (Placement(transformation(extent={{-8,-6},{
            22,24}})));
equation

  connect(dpDyn.port_b,senMasFlo. port_a) annotation (Line(
      points={{80,0},{88,0},{88,-80},{20,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senMasFlo.port_b,sou. ports[1]) annotation (Line(
      points={{0,-80},{-60,-80},{-60,-18}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumSys.port_b, dpDyn.port_a)
    annotation (Line(
      points={{22,9},{36,9},{36,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(sou.ports[2], pumSys.port_a)
    annotation (Line(
      points={{-60,-22},{-60,9},{-8,9}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(OnC.y, pumSys.On[3]) annotation (Line(
      points={{59,70},{-20,70},{-20,18.9},{-9.35,18.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(OnB.y, pumSys.On[2]) annotation (Line(
      points={{-59,70},{-40,70},{-40,18},{-9.35,18}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(OnA.y, pumSys.On[1]) annotation (Line(
      points={{-59,30},{-44,30},{-44,17.1},{-9.35,17.1}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/Pump/Example/PumpSystem.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end PumpSystem;
