within WaterSideSystem.BaseClasses.Components.Example;
model PumpVariableSpeed

  import ChillerPlantSystem = WaterSideSystem;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=10
    "Nominal mass flow rate ";
    parameter Modelica.SIunits.Pressure dP_nominal=1000
    "Nominal Pressure difference";
    parameter Real v_flow_ratio[:] = {0,0.5,1};
    parameter Real v_flow_rate[:] = {0,m_flow_nominal/996,2*m_flow_nominal/996};
    parameter Real pressure[:] = {2*dP_nominal,dP_nominal,0};
    parameter Real Motor_eta[:] = {1,1,1} "Motor efficiency";
    parameter Real Hydra_eta[:] = {1,1,1} "Hydraulic efficiency";

  ChillerPlantSystem.BaseClasses.Components.PumpVariableSpeed
                                                pumVarSpeB(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    dP_nominal=dP_nominal,
    v_flow_ratio=v_flow_ratio,
    Pressure=pressure,
    N_nominal=1500,
    m_flow_nominal=m_flow_nominal/3,
    v_flow_rate=v_flow_rate/3,
    dPFrihealos_nominal=dP_nominal*0.5)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=2,
    p(displayUnit="Pa") = 100000,
    T=293.15) annotation (Placement(transformation(extent={{-80,-30},{-60,-10}},
          rotation=0)));
  Buildings.Fluid.FixedResistances.PressureDrop       dpDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dP_nominal*0.5) "Pressure drop"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  ChillerPlantSystem.BaseClasses.Components.PumpVariableSpeed
                                                pumVarSpeC(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    dP_nominal=dP_nominal,
    Pressure=pressure,
    N_nominal=1500,
    v_flow_ratio=v_flow_ratio,
    m_flow_nominal=m_flow_nominal/3,
    v_flow_rate=v_flow_rate/3,
    dPFrihealos_nominal=dP_nominal*0.5)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.Ramp SpeedC(duration=100, startTime=300)
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
  Modelica.Blocks.Sources.Ramp SpeedB(
    duration=100,
    height=1,
    startTime=150)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  ChillerPlantSystem.BaseClasses.Components.PumpVariableSpeed
                                                pumVarSpeA(
    redeclare package Medium = Medium,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    dP_nominal=dP_nominal,
    Pressure=pressure,
    N_nominal=1500,
    v_flow_ratio=v_flow_ratio,
    m_flow_nominal=m_flow_nominal/3,
    v_flow_rate=v_flow_rate/3,
    dPFrihealos_nominal=dP_nominal*0.5)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Ramp SpeedA(
    duration=100,
    height=1,
    startTime=0)
              annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation

  connect(sou.ports[1], pumVarSpeB.port_a) annotation (Line(
      points={{-60,-18},{-60,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumVarSpeB.port_b, dpDyn.port_a) annotation (Line(
      points={{20,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumVarSpeC.port_a, pumVarSpeB.port_a) annotation (Line(
      points={{0,30},{-20,30},{-20,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumVarSpeC.port_b, dpDyn.port_a) annotation (Line(
      points={{20,30},{40,30},{40,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(SpeedB.y, pumVarSpeB.Spe) annotation (Line(
      points={{-59,70},{-40,70},{-40,6},{-2,6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dpDyn.port_b, senMasFlo.port_a) annotation (Line(
      points={{80,0},{90,0},{90,-80},{20,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senMasFlo.port_b, sou.ports[2]) annotation (Line(
      points={{0,-80},{-60,-80},{-60,-22}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(SpeedC.y, pumVarSpeC.Spe) annotation (Line(
      points={{59,70},{-32,70},{-32,36},{-2,36}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pumVarSpeA.port_a, pumVarSpeB.port_a) annotation (Line(
      points={{0,-30},{-20,-30},{-20,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(pumVarSpeA.port_b, dpDyn.port_a) annotation (Line(
      points={{20,-30},{40,-30},{40,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(SpeedA.y, pumVarSpeA.Spe) annotation (Line(
      points={{-59,30},{-48,30},{-48,-24},{-2,-24}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/BaseClasses/Components/Example/PumpVariableSpeed.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=500),
    __Dymola_experimentSetupOutput);
end PumpVariableSpeed;
